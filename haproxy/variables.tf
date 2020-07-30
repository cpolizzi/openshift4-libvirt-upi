variable "node_name" {
    type = string
    default = "loadbalancer"
    description = "VM name to create"
}

variable "image_dir" {
    type = string
    default = "/var/lib/libvirt/images"
    description = "Absolute path to directory containing disk images"
}

variable "image_name" {
    type = string
    default = "CentOS-8-GenericCloud-8.2.2004-20200611.2.x86_64.qcow2"
    description = "Disk image name within `var.image_dir` to use for VM creation"
}

variable "network_name" {
    type = string
    default = "default"
    description = "Existing network interface to use"
}
