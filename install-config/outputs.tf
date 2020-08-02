output "bootstrap_ignition" {
    value = format("%s/bootstrap.ign", dirname(local_file.install-config.filename))
}

output "compute_ignition" {
    value = format("%s/compute.ign", dirname(local_file.install-config.filename))
}

output "master_ignition" {
    value = format("%s/master.ign", dirname(local_file.install-config.filename))
}
