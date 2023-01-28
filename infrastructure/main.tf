resource "aws_key_pair" "auth_key" {
  key_name   = "${var.project_name}-key"
  public_key = file(join(".", ["${var.key-file}", "pub"]))
}

/* Just a random example of using local variable
  locals {
  name   = "auto-scaling-group-dev-node"
  region = "us-east-1"
  tags = {
    Name = "${var.project_name}-${var.environment}-dev-node"
  }
}

  resource "aws_launch_template" "main" {
  name_prefix   = "${local.name}-launch-template"
  image_id      = data.aws_ami.server_ami.id
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
} */

resource "aws_instance" "node_instance" {
  count                       = 1
  ami                         = data.aws_ami.server_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.auth_key.key_name
  vpc_security_group_ids      = ["${aws_security_group.default_sg.id}"]
  subnet_id                   = element(aws_subnet.main_public_subnet.*.id, count.index)
  associate_public_ip_address = true
  user_data                   = file("userdata.tmpl")

  root_block_device {
    volume_size = 8 # in gigabytes
  }

  // SSH config file
  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tmpl", {
      hostname     = aws_instance.node_instance.0.public_ip,
      user         = "ubuntu"
      identityfile = var.key-file
    })
    interpreter = var.host_os == "windows" ? ["Powershell", ".Command"] : ["bash", "-c"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-dev-node"
  }
}
