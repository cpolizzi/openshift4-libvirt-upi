variable "gen_dir" {
    type = string
}

variable "base_domain" {
    type = string
    description = "Cluster base DNS domain"
}

variable "cluster_name" {
    type = string
    description = "Cluster name"
}

variable "masters_count" {
    type = number
    description = "Number of masters"
}

variable "pull_secret" {
    description = "Cluster pull secret"
}

variable "openshift_installer" {
    type = string
    description = "Path to the OpenShift installer"
}
