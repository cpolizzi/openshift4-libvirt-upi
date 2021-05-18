resource "null_resource" "csr-approver" {
    depends_on = [ var.bootstrap-complete ]

    provisioner "local-exec" {
        command = join(" ", [
            "${path.module}/watch-for-csr.py",
            "--worker-count", var.worker_count,
            "--infra-count", var.infra_count,
        ])

        environment = {
            KUBECONFIG = var.kube-config
        }
    }
}
