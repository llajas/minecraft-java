A Java Minecraft server for Oracle Cloud to be used under their free tier. Infrastructure provisioned with Terraform and server setup via Ansible running on 'Oracle-Linux-9.0-aarch64-2022.08.17-0'

## Terraform

You'll need to obtain the root compartment ID, or ocid from your Oracle account after signing up. You can find the id of the root compartment by logging into Oracle Cloud's UI, searching for and going to compartments, selecting the root compartment, and then clicking "show" next to OCID:

You can find the id of the root compartment by logging into Oracle Cloud's UI, going to compartments, selecting the root compartment, and then clicking "show" next to OCID which will be the value for 'compartment_id' within 'base.tf'.

'network.tf' will establish all networking needed for the server to run and create the route needed for internet access. Feel free to adjust the IP/subnets as needed.

'vm.tf' will need the region your working from established in 'availability_domain' and you'll want to adjust the path for 'ssh_authorized_keys' to point towards your public key to ne uploaded, allowing remote administration and Ansible provisioning via SSH. You can also adjust the server settings and configuration here (RAM, CPU, boot volume size). The image ID points towards 'Oracle-Linux-9.0-aarch64-2022.08.17-0' - 'https://docs.oracle.com/en-us/iaas/images/image/cab2edc5-68e2-4a00-85b3-3abd7ec738ad/'

For 'security.tf', you'll want to adjust the 'source' under the first 'ingress_security_rules' to contain only your (server admins) public IP address to restrict access from others. You can also add additional ingress rules for separate IP's or ranges if you want to get into that level of depth.

Lastly, in 'provider', you'll want to declare the name of the workspace in use by the oci utilty - (https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/climanualinst.htm & https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/climanualinst.htm) - You'll also want to declare the region that you're working from based on where you created your account. 

With that in place, you'll be able to authenticate in via the OCI tool and start provisioning via Terraform where you'll receive the public IP of the cloud instance upon completion as an output to place into your '/etc/ansible/hosts' file under the 'mcservers' group tag. Feel free to save this IP as well in the event you device to point a domain name towards it.

## Ansible

This project uses Ansible to automate the setup and management of a Minecraft server. It includes a Ruby script to generate necessary templates and Ansible tasks for server control and configuration management.

### Features

- Template Generation: A Ruby script generates the required templates for Ansible to use.
- Server Management: Start, stop, and restart the Minecraft server using screen.
- Whitelist Management: Automatically generate and update the whitelist.json file from Vault data.
- Update Handling: Streamline updates to the Minecraft server. Each subsequent run will locate the latest available Java Minecraft and Fabric Modding API plugin versions to build a unique URL that will contain the latest stable release of Java with Fabric sideloaded into the server. No mods are included but this will give a great foundation to start adding mods to.

### Prerequisites

- Ansible installed on the control machine.
- Ruby installed for running the script.
- Access to a configured Minecraft server.
- A Vault server for secure data storage.

### Installation & Setup

1. Configure Vault Secrets:
    - Store Minecraft server details and user information in Vault.
2. Run the Ruby script!
    - The script will query you for the details of the server to:
        - Generate the unique templates files required for player/admin access and server whitelisting
        - Run the Ansible Playbook

Alternatively, you can set the variables in your shell using the following settings and the script will pickup on them once run:

```sh
export MC_SERVER_IP=<YOUR_VALUE_HERE>
export MC_VAULT_TOKEN=<YOUR_VALUE_HERE>
export MC_VAULT_URL=$VAULT_ADDR
export MC_SECRET_PATH=<YOUR_VALUE_HERE>
export MC_GAMEMODE=survival
export MC_LEVEL_NAME=ServerName
export MC_DIFFICULTY=hard
export MC_PVP=true
export MC_SSH_USER=root
export MC_LEVEL_SEED=-0123456789
```

### Tasks Included
- Template Generation: The Ruby script prepares required templates for Ansible.
- Always Up-To-Date: The Ansible Playbook checks both Fabric and official Minecraft API's for the latest versions of the Fabric Installer & Loader as well as the latest stable version of Minecraft Java. 
- Check and Stop Minecraft Server: Checks if the server is running and stops it if necessary.
- Start Minecraft Server: Initiates the server in a new screen session.
- Generate Whitelist: Retrieves player data from Vault to create `whitelist.json` & `ops.json` files to limit players to only those authorized and provide them their permissions.
