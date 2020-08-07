resource "null_resource" "generate-hosts" {
    provisioner "local-exec" {
        command = join(" ", [
            "${path.module}/generate-hosts.py",
            "--domain-name", var.dns_domain,
            "--master-count", var.master_count,
            "--worker-count", var.worker_count,
            "--infra-count", var.infra_count,
            "--cidr", var.cidr_address,
            "--cluster-id", var.cluster_id,
            "--mac-oui", var.mac_oui,
            ">", "${var.gen_dir}/hosts.json",
        ])
    }
}

data "local_file" "hosts" {
    depends_on = [ null_resource.generate-hosts ]
    filename = "${var.gen_dir}/hosts.json"
}

locals {
    hosts = jsondecode(data.local_file.hosts.content)
}
