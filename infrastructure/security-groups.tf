
locals {
  ingress_rules = [
    {
      description  = "SSH port"
      port         = 22
      tcp_protocol = "tcp"
      cidr_blocks  = ["0.0.0.0/0", local.workstation-external-cidr]
    },
    {
      description  = "Web server port"
      port         = 80
      tcp_protocol = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }
  ]
  # Playing around with locals :)
  /* egress_rules = [
    {
      description = "To any port"
      any_port    = 0
      any_protocol = "-1"
    }
  ] */
}

resource "aws_security_group" "default_sg" {
  name        = "${var.project_name} ${var.environment} security group"
  description = "${var.environment} Allows incoming ssh from anywhere, and any outgoing connexion to anywhere"
  vpc_id      = aws_vpc.remote_dev_vpc.id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.tcp_protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  # Below block is just an example for egress using locals, not necessary
  /* dynamic "egress" {
    for_each = local.egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.any_port
      to_port     = egress.value.any_port
      protocol    = egress.value.any_protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  } */
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
