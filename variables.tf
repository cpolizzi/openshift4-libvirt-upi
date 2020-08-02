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
    default = "my-cluster"
    description = "Cluster name"
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
    default = 4
    description = "Number of CPUs per worker"
}

variable "worker_memory" {
    type = number
    default = 16
    description = "Memory in GiB per worker"
}

variable "worker_disk_size" {
    type = number
    default = 120
    description = "Disk size in GiB per worker - TODO currently IGNORED"
}

variable "pull_secret_file" {
    type = string
    description = "File containing pull secret"
}

variable "openshift_installer" {
    type = string
    description = "Path to the OpenShift installer"
}
