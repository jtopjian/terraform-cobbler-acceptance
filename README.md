# terraform-cobbler-acceptance

Creates a simple Ubuntu environment and installs Cobbler for use in acceptance testing.

## Instructions

The Terraform configuration will most likely require modification to suit your testing environment, for example, if you don't have access to an OpenStack environment or if your OpenStack environment does not support IPv6. Modify `main.tf` accordingly.

Next, generate an SSH key like so:

```shell
terraform-cobbler-acceptance$ mkdir key
terraform-cobbler-acceptance$ cd key
terraform-cobbler-acceptance/key$ ssh-keygen -t rsa -f id_rsa
```

## Deployment

See `files/deploy.sh` for how the Cobbler environment is being created.

## Login Information

Once Cobbler is set up, you can use the following credentials for testing:

* username: cobbler
* password: password
