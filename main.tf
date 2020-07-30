provider "libvirt" {
    uri = "qemu:///system"
}

module "loadbalancer" {
    source = "./haproxy"
}

module "ansible" {
    source = "./ansible"
    gen_dir = var.gen_dir
    loadbalancer = module.loadbalancer.instance
}
