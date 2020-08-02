variable "node_role" {
    type = string
    description = "Cluster node role"
}

variable "node_name_prefix" {
    type = string
    default = ""
    description = "Prefix of cluster node machine names"
}

variable "node_name_suffix" {
    type = string
    default = ""
    description = "Suffix of cluster node machine names"
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
