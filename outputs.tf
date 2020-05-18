output "address" {
  value = var.engine == "redis" ? aws_elasticache_cluster.selected.cache_nodes[0].address : aws_elasticache_cluster.selected.cluster_address
}

output "port" {
  value = local.port
}

output "endpoint" {
  value = var.engine == "redis" ? "${aws_elasticache_cluster.selected.cache_nodes[0].address}:${aws_elasticache_cluster.selected.cache_nodes[0].port}" : aws_elasticache_cluster.selected.configuration_endpoint
}
