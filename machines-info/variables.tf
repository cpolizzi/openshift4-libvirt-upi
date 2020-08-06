variable "gen_dir" {
    type = string
    description  = "Path to store all generated artifacts"
}

variable "master_count" {
    type = number
    description = "Number of masters"
}

variable "worker_count" {
    type = number
    description = "Number of workers"
}

variable "infra_count" {
    type = number
    description = "Number of infras"
}

variable "dns_domain" {
    type = string
    description = "DNS domain on which machines will be associated with"
}

variable "cidr_address" {
    type = string
    description = "Subnet which machines will be associated with"
}

variable "mac_oui" {
    type = string
    description = "MAC address vendor OUI to generate MAC addresses with for machines"
}

variable "cluster_id" {
    type = number
    default = 1
    description = "Single octet cluster ID"
}
