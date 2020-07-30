resource "libvirt_volume" "loadbalancer" {
    name = "${var.node_name}.qcow"
    pool = "default"
    source = "${var.image_dir}/${var.image_name}"
    format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name = "loadbalancer-common-init.iso"
  user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/cloud_init.cfg")
    vars = {
        ssh-public-key = tls_private_key.haproxy.public_key_openssh,
    }
}

resource "libvirt_domain" "loadbalancer" {
    name   = "loadbalancer"
    memory = "1024"
    vcpu   = 1
    cloudinit = libvirt_cloudinit_disk.commoninit.id

    network_interface {
        network_name = var.network_name
        wait_for_lease = true
    }

    disk {
        volume_id = libvirt_volume.loadbalancer.id
    }
}

resource "tls_private_key" "haproxy" {
    algorithm = "RSA"
    rsa_bits = 4096
}
