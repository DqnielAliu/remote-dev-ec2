output "node_instance_ip" {
  value = aws_instance.node_instance.0.public_ip
}
