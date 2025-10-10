module "opentofu-unraid-docker" {
  source = "../path/to/your/repo"

  containers = var.containers
  unraid     = var.unraid
}