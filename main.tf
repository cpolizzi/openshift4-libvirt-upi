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

module "machines-info" {
    source = "./machines-info"
    gen_dir = var.gen_dir
    master_count = var.master_count
    worker_count = var.worker_count
    infra_count = var.infra_count
    dns_domain = "${var.cluster_name}.${var.base_domain}"
    cidr_address = var.cluster_network_cidr_address
    mac_oui = var.cluster_network_mac_oui
    cluster_id = 1
}

module "network" {
    source = "./network"
    network_name = var.cluster_network_name
    network_bridge = var.cluster_network_bridge
    dns_domain = "${var.cluster_name}.${var.base_domain}"
    cidr_address = var.cluster_network_cidr_address
    hosts_info = module.machines-info.hosts_config
    masters_count = var.master_count
}

module "boostrap-node" {
    source = "./machines"
    node_role = "bootstrap"
    instances_count = 1
    hosts_info = [ module.machines-info.hosts_config.bootstrap ]
    ignition_config_path = module.install-config.bootstrap_ignition
    image_dir = "/var/lib/libvirt/images"
    image_name = "rhcos-4.7.0-x86_64-qemu.x86_64.qcow2"
    network_name = var.cluster_network_name
    cpu = var.bootstrap_cpu
    memory = var.bootstrap_memory
    disk_size = var.bootstrap_disk_size
}

module "control-nodes" {
    source = "./machines"
    node_role = "master"
    instances_count = var.master_count
    hosts_info = module.machines-info.hosts_config.masters
    ignition_config_path = module.install-config.master_ignition
    image_dir = "/var/lib/libvirt/images"
    image_name = "rhcos-4.7.0-x86_64-qemu.x86_64.qcow2"
    network_name = var.cluster_network_name
    cpu = var.master_cpu
    memory = var.master_memory
    disk_size = var.master_disk_size
}

module "compute-nodes" {
    source = "./machines"
    node_role = "worker"
    instances_count = var.worker_count
    hosts_info = module.machines-info.hosts_config.workers
    ignition_config_path = module.install-config.compute_ignition
    image_dir = "/var/lib/libvirt/images"
    image_name = "rhcos-4.7.0-x86_64-qemu.x86_64.qcow2"
    network_name = var.cluster_network_name
    cpu = var.worker_cpu
    memory = var.worker_memory
    disk_size = var.worker_disk_size
}

#module "infra-nodes" {
#    source = "./machines"
#    node_role = "worker"
#    instances_count = var.infra_count
#    hosts_info = module.machines-info.hosts_config.infras
#    ignition_config_path = module.install-config.compute_ignition
#    image_dir = "/var/lib/libvirt/images"
#    image_name = "rhcos-4.7.0-x86_64-qemu.x86_64.qcow2"
#    network_name = var.cluster_network_name
#    cpu = var.infra_cpu
#    memory = var.infra_memory
#    disk_size = var.infra_disk_size
#}

module "loadbalancer" {
    source = "./haproxy"
    host_info = module.machines-info.hosts_config.loadbalancer
    network_name = var.cluster_network_name
}

module "ansible" {
    source = "./ansible"
    gen_dir = var.gen_dir
    loadbalancer = module.loadbalancer.instance
    bootstrap = {
        host = module.machines-info.hosts_config.bootstrap.hostname,
        fqdn = module.machines-info.hosts_config.bootstrap.fqdn,
        ip = module.machines-info.hosts_config.bootstrap.ip-address,
    }
    hosts_info_file = abspath("${var.gen_dir}/hosts.json")
}
