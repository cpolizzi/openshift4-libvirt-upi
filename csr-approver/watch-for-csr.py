#!/usr/bin/env python3

from kubernetes import client, config, watch
from datetime import datetime, timezone
from urllib3.exceptions import ProtocolError
import argparse

#
# Approve a CSR
#-----
def approve(client, api, request):
    # TODO Handle possible duplication (e.g., approved vs issued)
    print("Approving {} {}".format(request.metadata.name, request.spec.username))
    approval_condition = client.V1CertificateSigningRequestCondition(
            last_update_time = datetime.now(timezone.utc).astimezone(),
            status = "True",
            type = "Approved")
    request.status.conditions = [ approval_condition ]
    response = api.replace_certificate_signing_request_approval(request.metadata.name, request)
    return response

#
# Refresh CSR list resource version
#-----
def refresh_version(client, api):
    requests = api.list_certificate_signing_request()
    return requests.metadata.resource_version


# Parse arguments
parser = argparse.ArgumentParser(description="Certificate Signing Request (CSR) Approver")
parser.add_argument("--worker-count", type=int, required=True, help="Number of worker nodes")
parser.add_argument("--infra-count", type=int, required=True, help="Number of infra nodes")
args = parser.parse_args()

# We expect for each node for there to be two CSRS: 1 for for MCO bootstapper and 1 for the node itself
remaining_node_count = (args.worker_count + args.infra_count) * 2

# Configs can be set in Configuration class directly or using helper utility
config.load_kube_config()

# Certificates API
certs_api = client.CertificatesV1Api()

# Obtain resource version
version = refresh_version(client, certs_api)

# Watch for CSR's and quit when we receive number we expect to approve
print("Watching for certificate signing requests:")
finished = False
while (not finished):
    w = watch.Watch()
    try:
        for event in w.stream(certs_api.list_certificate_signing_request, resource_version = version):
            if event["type"] == "ADDED":
                request = event["object"]
                approve(client, certs_api, request)
                remaining_node_count -= 1
                if remaining_node_count == 0:
                    print("All expected CSR's have been approved")
                    finished = True
    except (client.exceptions.ApiException) as e:
        # We are always going to refresh the resource list version
        # We would normally expect a 410 in the exception status which means we need to refresh anyway
        # We could receive a 409 in the exception status which means we have a conflict and we would just refresh anway
        version = refresh_version(client, certs_api)
    except (ProtocolError) as e:
        pass