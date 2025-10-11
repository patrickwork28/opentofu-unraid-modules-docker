resource "docker_image" "this" {
  name         = var.container_data.image
  keep_locally = true
}

resource "docker_container" "this" {
  name         = var.container_data.name
  hostname     = var.container_data.hostname
  image        = docker_image.this.image_id
  restart      = var.container_data.restart
  network_mode = var.container_data.network
  cpu_set      = var.container_data.cpuset != "" ? var.container_data.cpuset : null
  
  user         = try(var.container_data.user, null)
  privileged   = try(var.container_data.privileged, false)
  command      = try(var.container_data.command, [])
  entrypoint   = try(var.container_data.entrypoint, [])

  env = [
    for env in try(var.container_data.envs, []) : "${env.name}=${env.value}"
  ]

  dynamic "capabilities" {
    for_each = try(var.container_data.capabilities, null) != null ? [var.container_data.capabilities] : []
    content {
      add  = try(capabilities.value.add, [])
      drop = try(capabilities.value.drop, [])
    }
  }

  security_opts = try(var.container_data.security_opts, [])

  dynamic "ports" {
    for_each = try(var.container_data.ports, [])
    content {
      internal = ports.value.container
      external = ports.value.host
      protocol = ports.value.protocol
    }
  }

  dynamic "mounts" {
    for_each = try(var.container_data.mounts, [])
    content {
      target    = mounts.value.container_path
      source    = try(mounts.value.host_path, null)
      type      = mounts.value.type
      read_only = try(mounts.value.mode, null) == "ro"
      
      dynamic "tmpfs_options" {
        for_each = mounts.value.type == "tmpfs" && try(mounts.value.tmpfs_options, null) != null ? [mounts.value.tmpfs_options] : []
        content {
          mode       = try(tmpfs_options.value.mode, null)
          size_bytes = try(tmpfs_options.value.size_bytes, null)
        }
      }
    }
  }

  dynamic "labels" {
    for_each = try(var.container_data.labels, [])
    content {
      label = labels.value.name
      value = labels.value.value
    }
  }

  dynamic "devices" {
    for_each = try(var.container_data.devices, [])
    content {
      host_path          = devices.value.host_path
      container_path     = devices.value.container_path
      permissions        = devices.value.permissions
    }
  }
  dynamic "upload" {
    for_each = try(var.container_data.configs, [])
    content {
      file           = upload.value.file
      content        = try(upload.value.content, null)
      content_base64 = try(upload.value.content_base64, null)
      source         = try(upload.value.source, null)
      source_hash    = try(upload.value.source_hash, null)
      executable     = try(upload.value.executable, false)
      permissions    = try(upload.value.permissions, null)
    }
  }
  
  depends_on = [ docker_image.this ]
}
