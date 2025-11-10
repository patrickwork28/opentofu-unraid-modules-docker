# OpenTofu Unraid Docker Module

Terraform/OpenTofu module for managing Docker containers with optional Unraid XML template generation.

## Features

- Manage multiple Docker containers using `for_each`
- Upload configuration files to containers
- Support for environment variables, ports, mounts, labels, devices
- Optional Unraid XML template generation
- Independent container lifecycle - changes to one container don't affect others

## Usage

```hcl
module "docker_containers" {
  source = "git::https://github.com/YOUR_USERNAME/opentofu-unraid-docker-module.git?ref=v1.0.0"

  containers = {
    nginx = {
      name       = "nginx"
      hostname   = "nginx"
      image      = "nginx:alpine"
      network    = "bridge"
      restart    = "unless-stopped"
      entrypoint = []

      ports = [
        { host = 8080, container = 80, protocol = "tcp" }
      ]

      envs = [
        { name = "TZ", value = "Asia/Ho_Chi_Minh" }
      ]

      configs = [
        {
          file        = "/etc/nginx/nginx.conf"
          source      = "./nginx.conf"
          permissions = "0644"
        }
      ]

      labels = [
        { name = "app", value = "nginx" }
      ]

      template_data = {
        enable = false
      }
    }
  }

  unraid = {
    xml_folderpath = "/boot/config/plugins/dockerMan/templates-user"
    host           = "unraid-server"
    user           = "root"
    ssh_privatekey = "/path/to/ssh/key"
  }
}
```

## Requirements

- Terraform/OpenTofu >= 1.0
- Docker provider ~> 3.6

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| containers | Map of container configurations | `map(object)` | yes |
| unraid | Unraid server configuration | `object` | yes |

## Container Configuration

Each container in the `containers` map supports:

- `name` - Container name
- `hostname` - Container hostname
- `image` - Docker image
- `network` - Network mode (bridge, host, etc.)
- `restart` - Restart policy (no, on-failure, always, unless-stopped)
- `entrypoint` - Custom entrypoint
- `command` - Custom command
- `user` - User to run as
- `privileged` - Run in privileged mode
- `cpuset` - CPU set
- `envs` - Environment variables
- `ports` - Port mappings
- `mounts` - Volume mounts
- `labels` - Container labels
- `devices` - Device mappings
- `configs` - Configuration files to upload
- `capabilities` - Linux capabilities
- `security_opts` - Security options
- `template_data` - Unraid XML template data (optional)

## Outputs

| Name | Description |
|------|-------------|
| container_ids | Map of container IDs |
| container_names | Map of container names |
| container_ips | Map of container IP addresses |

## License

MIT
