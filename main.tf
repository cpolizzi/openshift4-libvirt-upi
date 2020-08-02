terraform {
    required_version = ">= 0.12"
}

provider "libvirt" {
    uri = "qemu:///system"
}

resource "local_file" "pull-secret" {
    content = file("${var.pull_secret_file}")
    filename = "${var.gen_dir}/cluster/pull-secret.json"
    file_permission = 0644
}

resource "null_resource" "cleanup" {
    provisioner "local-exec" {
        when = destroy
        command = "rm -rf ${var.gen_dir}"
    }
}

module "install-config" {
    source = "./install-config"
    gen_dir = var.gen_dir
    base_domain = var.base_domain
    cluster_name = var.cluster_name
    masters_count = var.master_count
    pull_secret = local_file.pull-secret.content
    openshift_installer = var.openshift_installer
}

module "control-nodes" {
    source = "./machines"
    node_role = "master"
    node_name_prefix = "ocp-"
    node_name_suffix = "-"
    instances_count = 3
    ignition_config_path = module.install-config.master_ignition
    image_dir = "/var/lib/libvirt/images"
    image_name = "rhcos-4.5.2-x86_64-qemu.x86_64.qcow2"
    network_name = "default"
    cpu = var.master_cpu
    memory = var.master_memory
    disk_size = var.master_disk_size
}

module "compute-nodes" {
    source = "./machines"
    node_role = "worker"
    node_name_prefix = "ocp-"
    node_name_suffix = "-"
    instances_count = 2
    ignition_config_path = module.install-config.master_ignition
    image_dir = "/var/lib/libvirt/images"
    image_name = "rhcos-4.5.2-x86_64-qemu.x86_64.qcow2"
    network_name = "default"
    cpu = var.worker_cpu
    memory = var.worker_memory
    disk_size = var.worker_disk_size
}

module "loadbalancer" {
    source = "./haproxy"
}

module "ansible" {
    source = "./ansible"
    gen_dir = var.gen_dir
    loadbalancer = module.loadbalancer.instance
}
