variable "bootstrap-complete" {
    description = "Reference to a local file resource indicating that the bootstrap is completed"
}

variable "kube-config" {
    type = string
    description = "Path to cluster access file"
}

variable "worker_count" {
    description = "Number of workers"
}

variable "infra_count" {
    description = "Number of infras"
}
