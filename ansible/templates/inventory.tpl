[haproxy]
${haproxy-host} ansible_host=${haproxy-ip}

[bootstrap]
${bootstrap-fqdn} ansible-host=${bootstrap-ip}

[haproxy:vars]
ansible_user = ${haproxy-user}
ansible_ssh_private_key_file = ${ssh-private-key}

[all:vars]
ansible_ssh_common_args = -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
