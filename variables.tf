variable "gen_dir" {
    type = string
    default = "./generated"
    description  = "Path to store all generated artifacts"
}

variable "base_domain" {
    type = string
    default = "example.io"
    description = "Cluster base DNS domain"
}

variable "cluster_name" {
    type = string
    default = "mycluster"
    description = "Cluster name"
}

variable "cluster_network_cidr_address" {
    type = string
    default = "192.168.200.0/24"
    description = "Cluster network interface CIDR address"
}

variable "cluster_network_name" {
    type = string
    default = "ocp"
    description = "Network name to create"
}

variable "cluster_network_bridge" {
    type = string
    default = "ocp"
    description = "Network bridge device name to create"
}

variable "cluster_network_mac_oui" {
    type = string
    default = "52:54:00"
    description = "MAC address vendor OUI to generate MAC addresses with for machines"
}

variable "bootstrap_cpu" {
    type = number
    default = 4
    description = "Bootstrap number of CPUs"
}

variable "bootstrap_memory" {
    type = number
    default = 16
    description = "Bootstrap memory in GiB"
}

variable "bootstrap_disk_size" {
    type = number
    default = 120
    description = "Bootstrap disk size in GiB - TODO currently IGNORED"
}

variable "master_count" {
    type = number
    default = 1
    description = "Number of masters"
}

variable "master_cpu" {
    type = number
    default = 4
    description = "Number of CPUs per master"
}

variable "master_memory" {
    type = number
    default = 16
    description = "Memory in GiB per master"
}

variable "master_disk_size" {
    type = number
    default = 120
    description = "Disk size in GiB per master - TODO currently IGNORED"
}

variable "worker_count" {
    type = number
    default = 1
    description = "Number of workers"
}

variable "worker_cpu" {
    type = number
    default = 2
    description = "Number of CPUs per worker"
}

variable "worker_memory" {
    type = number
    default = 8
    description = "Memory in GiB per worker"
}

variable "worker_disk_size" {
    type = number
    default = 120
    description = "Disk size in GiB per worker - TODO currently IGNORED"
}

variable "infra_count" {
    type = number
    default = 0
    description = "Number of infras"
}

variable "infra_cpu" {
    type = number
    default = 2
    description = "Number of CPUs per infra"
}

variable "infra_memory" {
    type = number
    default = 8
    description = "Memory in GiB per infra"
}

variable "infra_disk_size" {
    type = number
    default = 120
    description = "Disk size in GiB per infra - TODO currently IGNORED"
}

variable "pull_secret_file" {
    type = string
    description = "File containing pull secret"
}

variable "openshift_installer" {
    type = string
    description = "Path to the OpenShift installer"
}
