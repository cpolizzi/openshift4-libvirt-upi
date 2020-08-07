resource "libvirt_volume" "volume" {
    count = var.instances_count
    name = format("${var.hosts_info[count.index].hostname}.qcow")
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
    name   = var.hosts_info[count.index].hostname
    memory = var.memory * 1024
    vcpu   = var.cpu
    coreos_ignition = libvirt_ignition.ignition.id

    network_interface {
        network_name = var.network_name
        hostname = var.hosts_info[count.index].hostname
        mac = var.hosts_info[count.index].mac-address
        wait_for_lease = true
    }

    disk {
        volume_id = libvirt_volume.volume[count.index].id
    }
}
