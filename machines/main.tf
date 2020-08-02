locals {
    node_name = format("%s%s%s", var.node_name_prefix, var.node_role, var.node_name_suffix)
}

resource "libvirt_volume" "volume" {
    count = var.instances_count
    name = format("${local.node_name}%02d.qcow", count.index)
# TODO We have to currently ignore being able to size the disk because the libvirt terraform provider
#    size = var.disk_size * 1024 * 1024 * 1024
    pool = "default"
    source = "${var.image_dir}/${var.image_name}"
    format = "qcow2"
}

resource "libvirt_ignition" "ignition" {
    name = var.node_role
    content = var.ignition_config_path
}

resource "libvirt_domain" "instance" {
    count = var.instances_count
    name   = format("${local.node_name}%02d", count.index)
    memory = var.memory * 1024
    vcpu   = var.cpu
    coreos_ignition = libvirt_ignition.ignition.id

    network_interface {
        network_name = var.network_name
        wait_for_lease = true
    }

    disk {
        volume_id = libvirt_volume.volume[count.index].id
    }
}
