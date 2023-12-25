#!/usr/bin/env python

import os
import subprocess
import yaml
from rich.prompt import Prompt

def run_ansible_playbook(inventory_file: str, playbook_file: str, vars_file: str, verbose: int = 0) -> None:
    command = ["ansible-playbook", "-i", inventory_file, "-e", f"@{vars_file}", playbook_file]
    command.extend(["-v"] * verbose)  # Add the desired number of '-v' options
    subprocess.run(command)

def create_inventory_file(ip_address: str, ssh_user: str) -> None:
    inventory_content = {
        "mcservers": {
            "hosts": {
                ip_address: {}
            },
            "vars": {
                "ansible_user": ssh_user
            }
        }
    }

    # Create 'inventories' directory if it doesn't exist
    inventory_dir = 'inventories'
    os.makedirs(inventory_dir, exist_ok=True)

    # Path to the inventory file
    inventory_file_path = os.path.join(inventory_dir, 'servers.yaml')

    # Write the content to the file
    with open(inventory_file_path, 'w') as file:
        yaml.dump(inventory_content, file, default_flow_style=False)

    print(f"Inventory file created at {inventory_file_path}")
    return inventory_file_path

def write_vars_to_file(vars_dict: dict) -> str:
    # Create 'inventories' directory if it doesn't exist
    inventory_dir = 'inventories'
    os.makedirs(inventory_dir, exist_ok=True)

    vars_file_path = os.path.join(inventory_dir, 'server_properties_vars.yaml')
    with open(vars_file_path, 'w') as file:
        yaml.dump(vars_dict, file, default_flow_style=False)
    return vars_file_path

def get_input(prompt_message: str, env_var: str, default: str = '') -> str:
    return os.environ.get(env_var) or Prompt.ask(prompt_message, default=default)

def main() -> None:
    mc_server_ip = get_input("Enter the Minecraft Server IP", "MC_SERVER_IP")
    mc_ssh_user = get_input("Enter the SSH User for Minecraft Server","MC_SSH_USER", default="root")
    mc_vault_token = get_input("Enter the Vault Token for Minecraft", "MC_VAULT_TOKEN")
    mc_vault_url = get_input("Enter the Vault URL for Minecraft", "MC_VAULT_URL")
    mc_secret_path = get_input("Enter the Secret Path for Minecraft in Vault", "MC_SECRET_PATH")
    mc_level_seed = get_input("Enter the desired seed for the Minecraft world", "MC_LEVEL_SEED")
    mc_gamemode = get_input("Enter the Minecraft Game Mode (survival, creative, adventure, spectator)", "MC_GAMEMODE", default="survival")
    mc_level_name = get_input("Enter the Minecraft Server Name", "MC_LEVEL_NAME")
    mc_difficulty = get_input("Enter the Minecraft Difficulty (peaceful, easy, normal, hard)", "MC_DIFFICULTY", default="peaceful")
    mc_pvp = get_input("Enable PvP? (true/false)", "MC_PVP", default="true")
    verbose_level = int(Prompt.ask("Enter the verbose level (0-4)", default="0"))

    inventory_file = create_inventory_file(mc_server_ip, mc_ssh_user)
    playbook_file = "minecraft-server.yaml"

    server_properties_vars = {
        "mc_level_seed": mc_level_seed,
        "mc_gamemode": mc_gamemode,
        "mc_level_name": mc_level_name,
        "mc_difficulty": mc_difficulty,
        "mc_pvp": mc_pvp,
    }

    vars_file = write_vars_to_file(server_properties_vars)

    run_ansible_playbook(inventory_file, playbook_file, vars_file, verbose=verbose_level)

if __name__ == '__main__':
    main()

