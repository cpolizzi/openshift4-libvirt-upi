variable "network_name" {
    type = string
    description = "Network name to create"
}

variable "network_bridge" {
    type = string
    description = "Network bridge device name to create"
}

variable "dns_domain" {
    type = string
    description = "DNS domain to associate with the network"
}

variable "cidr_address" {
    type = string
    description = "Subnet to associate with the network in CIDR notation"
}

variable "hosts_info" {
    description = "JSON structure containing configuration information for all nodes"
}
