# opentofu-unraid-docker
OpenTofu Modules for Unraid docker

## Version 1.0 Release Notes
The module is now completed and ready for release as version 1.0. The Unraid UI configuration has been updated to exclude the "net.unraid.docker.managed" variable, which is not managed by Unraid. This change allows the configuration to be saved in XML format for backup purposes. The module has been tested in Unraid 7.1.4.

## Docker Connection via SSH
To connect to the Docker daemon on the Unraid machine via SSH, you need to add your SSH key and export the `DOCKER_HOST` environment variable. You can do this by running the following commands:
```
export DOCKER_HOST="ssh://<user>@<host>"
```
Replace `<user>` and `<host>` with the actual username and hostname of your Unraid machine.
