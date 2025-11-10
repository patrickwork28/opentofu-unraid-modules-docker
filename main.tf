module "containers" {
  source = "./modules/docker-container"

  for_each = var.containers

  container_data = each.value
}

module "containers_xml" {
  source = "./modules/unraid-docker-xml"

  for_each = {
    for key, container in var.containers : key => container
    if try(container.template_data.enable, false) == true
  }

  enable = each.value.template_data.enable

  shared_container_data = {
    name       = each.value.name
    hostname   = each.value.hostname
    image      = each.value.image
    network    = each.value.network
    privileged = each.value.privileged
    restart    = each.value.restart

    user       = try(each.value.user, null)
    command    = try(each.value.command, [])
    entrypoint = try(each.value.entrypoint, [])
    envs       = try(each.value.envs, [])
    ports      = try(each.value.ports, [])
    mounts     = try(each.value.mounts, [])
    labels     = try(each.value.labels, [])
    devices    = try(each.value.devices, [])
  }

  xml_specific_data = {
    name           = each.value.name
    overview       = each.value.template_data.overview
    requires       = try(each.value.template_data.requires, "")
    support        = each.value.template_data.support
    project        = each.value.template_data.project
    registry       = each.value.image
    icon           = each.value.template_data.icon
    webui          = each.value.template_data.webui
    extra_params   = each.value.template_data.extra_params
    postargs       = try(each.value.template_data.postargs, "")
    cpuset         = try(each.value.template_data.cpuset, "")
    shell          = each.value.template_data.shell
    category       = each.value.template_data.category
    template_url   = each.value.template_data.template_url
    date_installed = each.value.template_data.date_installed
    donate_text    = each.value.template_data.donate_text
    donate_link    = each.value.template_data.donate_link
    myip           = try(each.value.template_data.myip, "")
  }

  unraid_xml_folderpath = var.unraid.xml_folderpath
  unraid_host           = var.unraid.host
  unraid_user           = var.unraid.user
  unraid_ssh_privatekey = var.unraid.ssh_privatekey
}
