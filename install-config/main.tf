resource "tls_private_key" "cluster" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "ssh-private-key" {
    content = tls_private_key.cluster.private_key_pem
    filename = "${var.gen_dir}/cluster/keys/${var.cluster_name}"
    file_permission = "0600"
}

resource "local_file" "ssh-public-key" {
    content = tls_private_key.cluster.public_key_openssh
    filename = "${var.gen_dir}/cluster/keys/${var.cluster_name}.pub"
    file_permission = "0644"
}

resource "local_file" "install-config" {
    content  = templatefile("${path.module}/templates/install-config.yaml", {
        base-domain = var.base_domain,
        cluster-name = var.cluster_name,
        masters_count = var.masters_count,
        pull-secret = trimspace(var.pull_secret),
        ssh-key = trimspace(tls_private_key.cluster.public_key_openssh)
    })
    filename = "${var.gen_dir}/cluster/install-config.yaml"
    file_permission = "0644"

    provisioner "local-exec" {
        command = "${var.openshift_installer} --dir ${var.gen_dir}/cluster create manifests"
    }

    provisioner "local-exec" {
        command = "sed -ire 's/\\(mastersSchedulable: +\\)true/\\1false/' ${var.gen_dir}/cluster/manifests/cluster-scheduler-02-config.yml"
    }

    provisioner "local-exec" {
        command = "${var.openshift_installer} --dir ${var.gen_dir}/cluster create ignition-configs"
    }
}
