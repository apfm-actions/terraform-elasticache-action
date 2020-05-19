resource "aws_security_group" "default" {
  name        = var.github_project
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = local.port
    to_port     = local.port
    protocol    = "tcp"
    cidr_blocks = compact(data.aws_subnet.selected[*].cidr_block)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    owner   = var.project_owner
    project = var.project_name
    email   = var.project_email
  }
}
