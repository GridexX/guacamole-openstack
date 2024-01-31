# Guacamole provisioning

This repository provides a Docker Compose setup for deploying Guacamole on OpenStack using Terraform. The setup includes integration with Keycloak for authentication.

## Requirements

- A SSH Public key imported on Openstack.
- The credential of your OpenStack cluster in a `clouds.yaml` file.
- Complete the `var.tf` file with the needed information

## Deploy

```bash
cd ./terraform
terraform init
terraform plan -out tfplan --var keycloak_hostname=$KC_HOSTNAME --var guacamole_hostname=$GUACAMOLE_HOSTNAME 
terraform apply -auto-approve tfplan
```

> [!IMPORTANT]
> Replace `$KC_HOSTNAME` and `$GUACAMOLE_HOSTNAME` with the hostname you want to use for Keycloak and Guacamole respectively.

## Creating a User in Keycloak

1. After deploying the Docker Compose stack, retrieve the passwords created by running the following command:

    ```bash
    ssh debian@$IP_ADDRESS "cat ~/compose-guacamole-keycloak/.env"
    ```

    > [!NOTE]
    > The IP address of the instance can be found in the Terraform output.

2. Access the KEYCLOAK service at `https://KC_HOSTNAME` and connect with the admin user and the `KEYCLOAK_ADMIN_PASSWORD` password retrieved in the previous step.

3. After logging, create a new realm and name it `guacamole`. Then, navigate to the "Users" section. Click "Add User" and provide the necessary details for the new user. Assign the user a password and remember the credentials for later access to Guacamole.

## Adding a VM to Connect

1. Go to `https://GUACAMOLE_HOSTNAME` and log in with the user created in the previous step.

1. In the Guacamole interface, navigate to the "Settings" section.

1. Click on the "Connections" tab.

1. Click "New Connection" and provide the necessary details, including the connection name, protocol, and the address of the VM you want to connect to.

1. Save the connection, and you should now be able to connect to the added VM through Guacamole.

> [!NOTE]
> Please note that additional configuration may be required based on your OpenStack setup and network configurations.

## Author

Written by [GridexX](https://github.com/GridexX) during February 2024. 