#!/usr/bin/env python3

import ipaddress
import argparse
import json
import sys
from enum import Enum

class NodeRole(Enum):
    loadbalancer = 0
    bootstrap = 1
    master = 2
    worker = 3
    infra = 4

parser = argparse.ArgumentParser(description="Machine information generation")
parser.add_argument("--domain-name", type=str, required=True, help="DNS domain name")
parser.add_argument("--cidr", type=str, required=True, help="Subnet")
parser.add_argument("--mac-oui", type=str, required=True, help="MAC address OUI")
parser.add_argument("--cluster-id", type=lambda x: int(x, 0), default=1, required=False, help="Cluster ID as a single octet")
parser.add_argument("--master-count", type=int, required=True, help="Number of master nodes")
parser.add_argument("--worker-count", type=int, required=True, help="Number of worker nodes")
parser.add_argument("--infra-count", type=int, required=True, help="Number of infra nodes")
args = parser.parse_args()

def generate_machine(name, domain_name, ip, mac_oui, cluster_id, role_id, machine_id):
    hostname = name
    oui = mac_oui if mac_oui else generate_mac_oui()
    nic = "{:02x}:{:02x}:{:02x}".format(cluster_id, role_id, machine_id)
    return {
        "hostname": hostname,
        "fqdn": "{}.{}".format(hostname, domain_name),
        "mac-address": "{}:{}".format(oui, nic),
        "ip-address": str(ip),
    }

def generate_loadbalancer(domain_name, ip, mac_oui, cluster_id):
    return generate_machine("loadbalancer", domain_name, ip, mac_oui, cluster_id, NodeRole.loadbalancer.value, 0)

def generate_bootstrap(domain_name, ip, mac_oui, cluster_id):
    return generate_machine("bootstrap", domain_name, ip, mac_oui, cluster_id, NodeRole.bootstrap.value, 0)

def generate_infra(domain_name, ip, mac_oui, cluster_id, infra_id):
    return generate_machine("infra-{:02d}".format(infra_id), domain_name, ip, mac_oui, cluster_id, NodeRole.infra.value, infra_id)

def generate_master(domain_name, ip, mac_oui, cluster_id, master_id):
    return generate_machine("master-{:02d}".format(master_id), domain_name, ip, mac_oui, cluster_id, NodeRole.master.value, master_id)

def generate_worker(domain_name, ip, mac_oui, cluster_id, worker_id):
    return generate_machine("worker-{:02d}".format(worker_id), domain_name, ip, mac_oui, cluster_id, NodeRole.worker.value, worker_id)

def generate_infras(count, domain_name, ip, mac_oui, cluster_id):
    result = list()
    for i in range(count):
        result.append(generate_infra(domain_name = domain_name, ip = ip + i, mac_oui = mac_oui, cluster_id = cluster_id, infra_id = i))
    return result

def generate_masters(count, domain_name, ip, mac_oui, cluster_id):
    result = list()
    for i in range(count):
        result.append(generate_master(domain_name = domain_name, ip = ip + i, mac_oui = mac_oui, cluster_id = cluster_id, master_id = i))
    return result

def generate_workers(count, domain_name, ip, mac_oui, cluster_id):
    result = list()
    for i in range(count):
        result.append(generate_worker(domain_name = domain_name, ip = ip + i, mac_oui = mac_oui, cluster_id = cluster_id, worker_id = i))
    return result

def main():
    ipnet = ipaddress.ip_network(args.cidr)
    machines = {
        "loadbalancer": generate_loadbalancer(domain_name = args.domain_name, ip = ipnet.network_address + 10, mac_oui = args.mac_oui, cluster_id = args.cluster_id),
        "bootstrap": generate_bootstrap(domain_name = args.domain_name, ip = ipnet.network_address + 10, mac_oui = args.mac_oui, cluster_id = args.cluster_id),
        "masters": generate_masters(count = args.master_count, domain_name = args.domain_name, ip = ipnet.network_address + 20, mac_oui = args.mac_oui, cluster_id = args.cluster_id),
        "workers": generate_workers(count = args.worker_count, domain_name = args.domain_name, ip = ipnet.network_address + 30, mac_oui = args.mac_oui, cluster_id = args.cluster_id),
        "infras": generate_infras(count = args.infra_count, domain_name = args.domain_name, ip = ipnet.network_address + 40, mac_oui = args.mac_oui, cluster_id = args.cluster_id),
    }
    print(json.dumps(machines))

if __name__ == "__main__":
    main()
