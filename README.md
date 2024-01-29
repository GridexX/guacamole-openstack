# Guacamole provisioning

This repository provides Terraform files to launch a Virtual Machine and deploy a Guacamole instance on it.

## Requirements

- A SSH Public key imported on Openstack. 
- The credential of your OpenStack cluster in a `clouds.yaml` file.
- Complete the `var.tf` file with the needed information

## Deploy

```bash
cd ./terraform
terraform init
terraform plan -out tfplan
terraform apply -auto-approve tfplan
```

## Access the Guacamole instance

Once deployed, the IP of the machine is displayed. You can then open your browser and go to http://$IP:8080/guacamole.

## Delete

```bash
terraform destroy -auto-approve
```
