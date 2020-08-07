resource "libvirt_volume" "volume" {
    name = format("${var.host_info.hostname}.qcow")
    pool = "default"
    source = "${var.image_dir}/${var.image_name}"
    format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
    name = "centos-common-init.iso"
    user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/cloud_init.cfg")
    vars = {
        ssh-public-key = tls_private_key.haproxy.public_key_openssh,
    }
}

resource "libvirt_domain" "instance" {
    name   = var.host_info.hostname
    memory = "1024" # TODO
    vcpu   = 1 # TODO
    cloudinit = libvirt_cloudinit_disk.commoninit.id

    network_interface {
        network_name = var.network_name
        hostname = var.host_info.hostname
        mac = var.host_info.mac-address
        wait_for_lease = true
    }

    disk {
        volume_id = libvirt_volume.volume.id
    }
}

resource "tls_private_key" "haproxy" {
    algorithm = "RSA"
    rsa_bits = 4096
}
