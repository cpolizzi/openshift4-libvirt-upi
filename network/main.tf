data "libvirt_network_dns_srv_template" "etcd" {
    count = var.masters_count
    service = "etcd-server-ssl"
    protocol = "tcp"
    domain = var.dns_domain
    target = "etcd-${count.index}.${var.dns_domain}"
    port = 2380
    weight = 10
    priority = 0
}

data "libvirt_network_dns_host_template" "host-aliases" {
    count = var.masters_count
    ip = var.hosts_info.masters[count.index].ip-address
    hostname = "etcd-${count.index}.${var.dns_domain}"
}

resource "libvirt_network" "openshift" {
    name = var.network_name
    bridge = var.network_bridge
    mode = "nat"
    domain = var.dns_domain
    addresses = [ var.cidr_address ]
    dns {
        enabled = true
        local_only = true
        dynamic srvs {
            for_each = data.libvirt_network_dns_srv_template.etcd.*.rendered
            content {
                service = srvs.value["service"]
                protocol = srvs.value["protocol"]
                domain = srvs.value["domain"]
                target = srvs.value["target"]
                port = srvs.value["port"]
                weight = srvs.value["weight"]
                priority = srvs.value["priority"]
            }
        }
        dynamic hosts {
            for_each = data.libvirt_network_dns_host_template.host-aliases.*.rendered
            content {
                ip = hosts.value["ip"]
                hostname = hosts.value["hostname"]
            }
        }
        hosts {
            ip = var.hosts_info.loadbalancer.ip-address
            hostname = "api.${var.dns_domain}"
        }
        hosts {
            ip = var.hosts_info.loadbalancer.ip-address
            hostname = "api-int.${var.dns_domain}"
        }
    }
    dhcp {
        enabled = true
    }

    # tag::network-customization[]
    xml {
        xslt = templatefile("${path.module}/templates/network.xsl", {
            dns_domain = var.dns_domain,
            hosts = var.hosts_info,
        })
    }
    # end::network-customization[]
}
