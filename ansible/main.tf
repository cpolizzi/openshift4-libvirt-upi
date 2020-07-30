resource "local_file" "ssh-private-key" {
    content = var.loadbalancer.ssh_key.private_key_pem
    filename = "${var.gen_dir}/ssh/loadbalancer"
    file_permission = "0600"
}

resource "local_file" "ssh-public-key" {
    content = var.loadbalancer.ssh_key.public_key_openssh
    filename = "${var.gen_dir}/ssh/loadbalancer.pub"
    file_permission = "0644"
}

resource "local_file" "ansible-inventory" {
    content  = templatefile("${path.module}/templates/inventory.tpl", {
        haproxy-host = var.loadbalancer.host,
        haproxy-ip = var.loadbalancer.ip,
        haproxy-user = var.loadbalancer.user,
        ssh-private-key = local_file.ssh-private-key.filename,
    })
    filename = "${var.gen_dir}/ansible/inventory"
    file_permission = "0644"
}

resource "null_resource" "ansible-inventory" {
    provisioner "local-exec" {
        command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ${local_file.ansible-inventory.filename} ${path.module}/playbooks/haproxy.yaml"
    }
}
