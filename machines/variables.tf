variable "hosts_info" {
    description = "JSON structure containing configuration information for all nodes"
}

variable "node_role" {
    type = string
    description = "Cluster node role"
}

variable "instances_count" {
    type = number
    default = 1
    description = "Number of machines to create"
}

variable "ignition_config_path" {
    type = string
    description = "Path to ignition config to use"
}

variable "image_dir" {
    type = string
    default = "/var/lib/libvirt/images"
    description = "Absolute path to directory containing disk images"
}

variable "image_name" {
    type = string
    default = "rhcos-qemu-image.qcow"
    description = "Disk image name within `var.image_dir` to use for VM creation"
}

variable "network_name" {
    type = string
    default = "default"
    description = "Existing network interface to use"
}

variable "cpu" {
    type = number
    default = 1
    description = "Number of CPUs"
}

variable "memory" {
    type = number
    default = 16
    description = "Memory in GiB"
}

variable "disk_size" {
    type = number
    default = 120
    description = "Disk size in GiB - TODO currently IGNORED"
}
