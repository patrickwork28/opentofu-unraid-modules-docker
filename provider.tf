provider "docker" {
  host = "ssh://${var.unraid.user}@${var.unraid.host}"

  ssh_opts = [
    "-i", pathexpand(var.unraid.ssh_privatekey),
    "-o", "StrictHostKeyChecking=no"
  ]
}
