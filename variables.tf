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

variable "masters_count" {
    type = number
    default = "1"
    description = "Number of masters"
}

variable "pull_secret_file" {
    type = string
    description = "File containing pull secret"
}

variable "openshift_installer" {
    type = string
    description = "Path to the OpenShift installer"
}
