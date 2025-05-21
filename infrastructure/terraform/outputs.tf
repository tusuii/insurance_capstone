output "master_public_ip" {
  value       = aws_instance.master.public_ip
  description = "Public IP of master node"
}

output "worker_public_ips" {
  value       = aws_instance.workers[*].public_ip
  description = "Public IPs of worker nodes"
}

output "master_private_ip" {
  value       = aws_instance.master.private_ip
  description = "Private IP of master node"
}

output "worker_private_ips" {
  value       = aws_instance.workers[*].private_ip
  description = "Private IPs of worker nodes"
}

# Generate Ansible inventory file
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl",
    {
      master_ip = aws_instance.master.public_ip
      worker_ips = aws_instance.workers[*].public_ip
    }
  )
  filename = "${path.module}/../ansible/inventory"
}
