resource "libvirt_network" "openshift" {
    name = var.network_name
    bridge = var.network_bridge
    mode = "nat"
    domain = var.dns_domain
    addresses = [ var.cidr_address ]
    dns {
        enabled = true
        local_only = true
    }
    dhcp {
        enabled = true
    }

    xml {
        xslt = templatefile("${path.module}/templates/network.xsl", {
            reservations = [
                { "name"="foo", "mac"="52:52:00:01:00:00", "ip"="192.168.200.10" },
                { "name"="bar", "mac"="52:52:00:01:00:01", "ip"="192.168.200.11" },
                { "name"="biz", "mac"="52:52:00:01:00:02", "ip"="192.168.200.12" },
                { "name"="baz", "mac"="52:52:00:01:00:03", "ip"="192.168.200.13" },
            ]
        })
    }
}
