resource "docker_image" "this" {
  name          = var.container_data.image
  keep_locally  = true
  pull_triggers = []
}

# Container without ignore_changes
resource "docker_container" "this" {
  count = length(var.container_data.ignore_changes) == 0 ? 1 : 0
  
  name         = var.container_data.name
  hostname     = var.container_data.hostname
  image        = docker_image.this.image_id
  restart      = var.container_data.restart
  network_mode = var.container_data.network
  cpu_set      = var.container_data.cpuset != "" ? var.container_data.cpuset : null
  
  user       = var.container_data.user
  privileged = var.container_data.privileged
  command    = length(var.container_data.command) > 0 ? var.container_data.command : null
  entrypoint = length(var.container_data.entrypoint) > 0 ? var.container_data.entrypoint : []
  
  log_opts = {
    "max-file" = "1"
    "max-size" = "50m"
  }

  env = [
    for env in var.container_data.envs : "${env.name}=${env.value}"
  ]

  dynamic "capabilities" {
    for_each = var.container_data.capabilities != null ? [var.container_data.capabilities] : []
    content {
      add  = capabilities.value.add
      drop = capabilities.value.drop
    }
  }

  security_opts = var.container_data.security_opts

  dynamic "ports" {
    for_each = var.container_data.ports
    content {
      internal = ports.value.container
      external = ports.value.host
      protocol = ports.value.protocol
    }
  }

  dynamic "mounts" {
    for_each = var.container_data.mounts
    content {
      target    = mounts.value.container_path
      source    = mounts.value.host_path
      type      = mounts.value.type
      read_only = mounts.value.mode == "ro"
      
      dynamic "tmpfs_options" {
        for_each = mounts.value.type == "tmpfs" && mounts.value.tmpfs_options != null ? [mounts.value.tmpfs_options] : []
        content {
          mode       = tmpfs_options.value.mode
          size_bytes = tmpfs_options.value.size_bytes
        }
      }
    }
  }

  dynamic "labels" {
    for_each = var.container_data.labels
    content {
      label = labels.value.name
      value = labels.value.value
    }
  }

  dynamic "devices" {
    for_each = var.container_data.devices
    content {
      host_path      = devices.value.host_path
      container_path = devices.value.container_path
      permissions    = devices.value.permissions
    }
  }
  
  dynamic "upload" {
    for_each = var.container_data.configs
    content {
      file           = upload.value.file
      content        = upload.value.content
      content_base64 = upload.value.content_base64
      source         = upload.value.source
      source_hash    = upload.value.source_hash
      executable     = upload.value.executable
      permissions    = upload.value.permissions
    }
  }
}

# Container with ignore_changes
resource "docker_container" "ignore" {
  count = length(var.container_data.ignore_changes) > 0 ? 1 : 0
  
  name         = var.container_data.name
  hostname     = var.container_data.hostname
  image        = docker_image.this.image_id
  restart      = var.container_data.restart
  network_mode = var.container_data.network
  cpu_set      = var.container_data.cpuset != "" ? var.container_data.cpuset : null
  
  user       = var.container_data.user
  privileged = var.container_data.privileged
  command    = length(var.container_data.command) > 0 ? var.container_data.command : null
  entrypoint = length(var.container_data.entrypoint) > 0 ? var.container_data.entrypoint : []
  
  log_opts = {
    "max-file" = "1"
    "max-size" = "50m"
  }
  
  lifecycle {
    ignore_changes = [
      entrypoint, command, log_opts, capabilities, ports
    ]
  }

  env = [
    for env in var.container_data.envs : "${env.name}=${env.value}"
  ]

  dynamic "capabilities" {
    for_each = var.container_data.capabilities != null ? [var.container_data.capabilities] : []
    content {
      add  = capabilities.value.add
      drop = capabilities.value.drop
    }
  }

  security_opts = var.container_data.security_opts

  dynamic "ports" {
    for_each = var.container_data.ports
    content {
      internal = ports.value.container
      external = ports.value.host
      protocol = ports.value.protocol
    }
  }

  dynamic "mounts" {
    for_each = var.container_data.mounts
    content {
      target    = mounts.value.container_path
      source    = mounts.value.host_path
      type      = mounts.value.type
      read_only = mounts.value.mode == "ro"
      
      dynamic "tmpfs_options" {
        for_each = mounts.value.type == "tmpfs" && mounts.value.tmpfs_options != null ? [mounts.value.tmpfs_options] : []
        content {
          mode       = tmpfs_options.value.mode
          size_bytes = tmpfs_options.value.size_bytes
        }
      }
    }
  }

  dynamic "labels" {
    for_each = var.container_data.labels
    content {
      label = labels.value.name
      value = labels.value.value
    }
  }

  dynamic "devices" {
    for_each = var.container_data.devices
    content {
      host_path      = devices.value.host_path
      container_path = devices.value.container_path
      permissions    = devices.value.permissions
    }
  }
  
  dynamic "upload" {
    for_each = var.container_data.configs
    content {
      file           = upload.value.file
      content        = upload.value.content
      content_base64 = upload.value.content_base64
      source         = upload.value.source
      source_hash    = upload.value.source_hash
      executable     = upload.value.executable
      permissions    = upload.value.permissions
    }
  }
}
