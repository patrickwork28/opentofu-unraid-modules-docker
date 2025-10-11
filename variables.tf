variable "containers" {
  type = map(object({
    name       = string
    hostname   = string
    image      = string
    network    = string
    restart    = string
    pids_limit = number
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
    }), { add = [], drop = [] })

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

    template_data = object({
      enable       = optional(bool, true)
      shell        = string
      repository   = string
      support      = string
      project      = string
      overview     = string
      category     = string
      webui        = string
      template_url = string
      icon         = string
      extra_params = string
      date_installed = string
      donate_text  = string
      donate_link  = string
      myip       = optional(string, "")
      postargs   = optional(string, "")
      cpuset     = optional(string, "")
      requires   = optional(string, "")
    })
  }))

  validation {
    condition = alltrue([
      for key, container in var.containers : can(regex("^[a-z0-9-]+$", key))
    ])
    error_message = "Container keys must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers : can(regex("^[a-z0-9-]+$", container.name))
    ])
    error_message = "Container names must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers : contains(["no", "on-failure", "always", "unless-stopped"], container.restart)
    ])
    error_message = "Restart policy must be one of: no, on-failure, always, unless-stopped."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers : contains(["sh", "bash"], container.template_data.shell)
    ])
    error_message = "Shell must be either 'sh' or 'bash'."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers :
      alltrue([
        for port in try(container.ports, []) :
        contains(["tcp", "udp"], port.protocol)
      ])
    ])
    error_message = "Port protocols must be either 'tcp' or 'udp'."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers :
      alltrue([
        for mount in try(container.mounts, []) :
        mount.host_path == null || can(regex("^/.*", mount.host_path))
      ])
    ])
    error_message = "Host paths must be absolute paths starting with '/'."
  }

  validation {
    condition = alltrue([
      for key, container in var.containers :
      alltrue([
        for mount in try(container.mounts, []) :
        mount.mode == null || contains(["ro", "rw"], mount.mode)
      ])
    ])
    error_message = "Mount modes must be either 'ro' (read-only) or 'rw' (read-write)."
  }
}

variable "config_files" {
  description = "Map of configuration files with their content"
  type = map(object({
    content = string
  }))
  default = {}
}

variable "unraid" {
  description = "Unraid server configuration for XML template deployment"
  type = object({
    xml_folderpath = optional(string, "/boot/config/plugins/dockerMan/templates-user")
    host           = string
    user           = optional(string, "root")
    ssh_privatekey = string
  })
}
