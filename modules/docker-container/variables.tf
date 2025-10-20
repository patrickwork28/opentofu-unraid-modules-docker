variable "container_data" {
  description = "Single container configuration"
  type = object({
    name       = string
    hostname   = string
    image      = string
    network    = string
    restart    = string
    pids_limit = optional(number, 1024)
    cpuset     = optional(string, "")
    user       = optional(string)
    privileged = optional(bool, false)
    command    = optional(list(string), [])
    entrypoint = optional(list(string), [])

    envs = optional(list(object({
      name  = string
      value = string
    })), [])
    
    capabilities = optional(object({
      add  = optional(list(string), [])
      drop = optional(list(string), [])
    }))

    security_opts = optional(list(string), [])
    
    ports = optional(list(object({
      host      = number
      container = number
      protocol  = string
    })), [])

    mounts = optional(list(object({
      type           = string
      host_path      = optional(string)
      container_path = string
      mode           = optional(string)
      tmpfs_options = optional(object({
        mode       = optional(number)
        size_bytes = optional(number)
      }))
    })), [])

    configs = optional(list(object({
      file           = string
      content        = optional(string)
      content_base64 = optional(string)
      source         = optional(string)
      source_hash    = optional(string)
      executable     = optional(bool, false)
      permissions    = optional(string)
    })), [])

    labels = optional(list(object({
      name  = string
      value = string
    })), [])

    devices = optional(list(object({
      host_path      = string
      container_path = string
      permissions    = string
    })), [])
    
    ignore_changes = optional(list(string), [])
  })

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.container_data.name))
    error_message = "Container name must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = contains(["no", "on-failure", "always", "unless-stopped"], var.container_data.restart)
    error_message = "Restart policy must be one of: no, on-failure, always, unless-stopped."
  }

  validation {
    condition     = try(var.container_data.pids_limit > 0, true)
    error_message = "When specified, PIDs limit must be greater than 0."
  }
}
