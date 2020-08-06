resource "null_resource" "generate-hosts" {
    provisioner "local-exec" {
        command = join(" ", [
            "./generate-hosts.py",
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

data "template_file" "hosts" {
    template = templatefile("${path.module}/templates/hosts.xml", {
        config = local.hosts
    })
}

resource "local_file" "hosts" {
    content = data.template_file.hosts.rendered
    filename = "${var.gen_dir}/out.hosts.xml"
    file_permission = "0644"
}
