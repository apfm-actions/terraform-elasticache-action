locals {
  default_engine_version = var.engine == "redis" ? "5.0.0" : "1.5.16"
  engine_version         = var.engine_version != "" ? var.engine_version : local.default_engine_version

  node_type = var.node_type != "" ? var.node_type : "cache.t2.micro"

  memcached_node_count = min(compact([var.node_count != "" ? var.node_count : 1, 20])...)
  node_count           = var.engine == "redis" ? 1 : local.memcached_node_count

  vpc_id     = var.vpc_id != "" ? var.vpc_id : var.network_vpc_id
  subnet_ids = var.subnet_ids != "" ? var.subnet_ids : var.subnet_id_private

  default_port = var.engine == "redis" ? 6370 : 11211
  port         = var.port != "" ? var.port : local.default_port

  maintenance_window = var.maintenance_window != "" ? var.maintenance_window : "sun:02:30-sun:03:30"

  tags = {
    environment = terraform.workspace
    owner       = var.project_owner
    project     = var.project_name
    email       = var.project_email
  }
}

data "aws_vpc" "selected" {
  id = local.vpc_id
}

data "aws_subnet" "selected" {
  count = length(split(",", local.subnet_ids))
  id    = element(split(",", local.subnet_ids), count.index)
}

resource "aws_elasticache_parameter_group" "selected" {
  name   = "${var.github_project}${replace(local.engine_version, "/^([[:digit:]]+)[.]([[:alnum:]]+).*/", "$1-$2")}"
  family = "${var.engine}${replace(local.engine_version, "/^([[:digit:]]+)[.]([[:alnum:]]+).*/", "$1.$2")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_subnet_group" "selected" {
  name       = "${var.github_project}-subnet"
  subnet_ids = data.aws_subnet.selected[*].id
}

resource "aws_elasticache_cluster" "selected" {
  cluster_id           = var.github_project
  engine               = var.engine
  engine_version       = local.engine_version
  parameter_group_name = aws_elasticache_parameter_group.selected.name
  node_type            = local.node_type
  num_cache_nodes      = local.node_count
  port                 = local.port
  subnet_group_name    = aws_elasticache_subnet_group.selected.name
  security_group_ids   = [aws_security_group.default.id]
  maintenance_window   = local.maintenance_window
  tags                 = local.tags
  apply_immediately    = true
}
