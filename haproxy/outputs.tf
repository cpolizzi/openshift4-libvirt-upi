output "instance" {
    value = {
        user = "centos",
        ssh_key = tls_private_key.haproxy,
        host = libvirt_domain.instance.name,
        ip = libvirt_domain.instance.network_interface.0.addresses.0,
    }
}
