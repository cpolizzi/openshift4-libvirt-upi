output "instance" {
    value = {
        user = "centos",
        ssh_key = tls_private_key.haproxy,
        host = libvirt_domain.loadbalancer.name,
        ip = libvirt_domain.loadbalancer.network_interface.0.addresses.0,
    }
}
