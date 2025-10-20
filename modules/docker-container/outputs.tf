locals {
  container = length(var.container_data.ignore_changes) > 0 ? docker_container.ignore[0] : docker_container.this[0]
}

output "container_id" {
  description = "The ID of the created Docker container"
  value       = local.container.id
}

output "container_name" {
  description = "The name of the created Docker container"
  value       = local.container.name
}

output "image_name" {
  description = "The name of the Docker image used"
  value       = docker_image.this.name
}

output "container_ip" {
  description = "The IP address of the Docker container"
  value = try(local.container.network_data[0].ip_address, "")
}

output "container_network_mode" {
  description = "The network mode of the Docker container"
  value       = local.container.network_mode
}