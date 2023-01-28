resource "null_resource" "ansible-provision" {

  depends_on = [aws_instance.node_instance]

  # SSH Keys configuration
  provisioner "local-exec" {
    command = "echo \"[node_instance:vars]\nansible_ssh_private_key_file = '${var.key-file}'\" > '${var.inventory-file}'"
  }

  #Create Nodes Inventory
  provisioner "local-exec" {
    command = "echo \"\n[node_instance]\" >> '${var.inventory-file}'"
  }
  provisioner "local-exec" {
    command = "echo \"${join("\n", formatlist("%s", aws_instance.node_instance.*.public_ip))}\" >> '${var.inventory-file}'"
  }
}

