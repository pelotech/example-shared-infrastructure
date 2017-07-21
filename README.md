# example-shared-infrastructure

This repository contains an example of a terraform template that creates ec2 servers, and then deploys containers on them with rancher.

In order to run it, you'll need to fill out the example.tfvars file with values from your environment. You can then create it with
```
$ terraform apply -var-file=example.tfvars
```