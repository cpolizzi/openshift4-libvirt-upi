variable "gen_dir" {
    type = string
}

variable "loadbalancer" {
    description = "Load balancer information contain host name, IP, user, ssh key"
}

variable "hosts_info_file" {
    type = string
    description = "Path to JSON file containing configuration information for all nodes"
}
