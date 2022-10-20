A Java Minecraft server for Oracle Cloud to be used under their free tier. Infrastructure provisioned with Terraform and server setup via Ansible running on 'Oracle-Linux-9.0-aarch64-2022.08.17-0'

You'll need to obtain the root compartment ID, or ocid from your Oracle account after signing up. You can find the id of the root compartment by logging into Oracle Cloud's UI, searching for and going to compartments, selecting the root compartment, and then clicking "show" next to OCID:

You can find the id of the root compartment by logging into Oracle Cloud's UI, going to compartments, selecting the root compartment, and then clicking "show" next to OCID which will be the value for 'compartment_id' within 'base.tf'.

'network.tf' will establish all networking needed for the server to run and create the route needed for internet access. Feel free to adjust the IP/subnets as needed.

'vm.tf' will need the region your working from established in 'availability_domain' and you'll want to adjust the path for 'ssh_authorized_keys' to point towards your public key to ne uploaded, allowing remote administration and Ansible provisioning via SSH. You can also adjust the server settings and configuration here (RAM, CPU, boot volume size). The image ID points towards 'Oracle-Linux-9.0-aarch64-2022.08.17-0' - 'https://docs.oracle.com/en-us/iaas/images/image/cab2edc5-68e2-4a00-85b3-3abd7ec738ad/'

For 'security.tf', you'll want to adjust the 'source' under the first 'ingress_security_rules' to contain only your (server admins) public IP address to restrict access from others. You can also add additional ingress rules for separate IP's or ranges if you want to get into that level of depth.

Lastly, in 'provider', you'll want to declare the name of the workspace in use by the oci utilty - (https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/climanualinst.htm & https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/climanualinst.htm) - You'll also want to declare the region that you're working from based on where you created your account. 

With that in place, you'll be able to authenticate in via the OCI tool and start provisioning via Terraform where you'll receive the public IP of the cloud instance upon completion as an output to place into your '/etc/ansible/hosts' file under the 'mcservers' group tag. Feel free to save this IP as well in the event you device to point a domain name towards it.

Before proceeding, keep this in mind:

    The server has the following properties:
        -hard difficulty
        -Survival mode 
        -No seed
        -white list enabled and enforced.

Update 'server.properties.tpl' to adjust difficulty and game mode as well as a custom seed and any of the other options above as well as others such as server name, etc. (https://minecraft.fandom.com/wiki/Server.properties)

'whitelist.json.tpl' can be updated using the UUID (https://minecraftuuid.com/) of your players along with their name. This also goes for 'ops.json.tpl' where server operator level can be added & adjusted between 1-4 (https://minecraft.fandom.com/wiki/Permission_level)

Run the playbook (you will need to accept the server ID on first connect via SSH - accept the identity if asked by your client) and your server will be running at the intended address

To-Do:
Add in variables for options to be entered as the scripts run and set defaults