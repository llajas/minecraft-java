#!/usr/bin/env ruby

require 'yaml'
require 'fileutils'
require 'highline/import'

def run_ansible_playbook(inventory_file, playbook_file, vars_file, verbose = 0)
  command = ["ansible-playbook", "-i", inventory_file, "-e", "@#{vars_file}", playbook_file]
  command.concat(["-v"] * verbose) # Add the desired number of '-v' options
  system(*command)
end

def create_inventory_file(ip_address, ssh_user)
  inventory_content = {
    "mcservers" => {
      "hosts" => {
        ip_address => {}
      },
      "vars" => {
        "ansible_user" => ssh_user
      }
    }
  }

  # Create 'inventories' directory if it doesn't exist
  inventory_dir = 'inventories'
  FileUtils.mkdir_p(inventory_dir)

  # Path to the inventory file
  inventory_file_path = File.join(inventory_dir, 'servers.yaml')

  # Write the content to the file
  File.write(inventory_file_path, inventory_content.to_yaml)

  puts "Inventory file created at #{inventory_file_path}"
  inventory_file_path
end

def write_vars_to_file(vars_dict)
  # Create 'inventories' directory if it doesn't exist
  inventory_dir = 'inventories'
  FileUtils.mkdir_p(inventory_dir)

  vars_file_path = File.join(inventory_dir, 'server_properties_vars.yaml')
  File.write(vars_file_path, vars_dict.to_yaml)
  vars_file_path
end

def get_input(prompt_message, env_var, default = '')
  ENV[env_var] || ask("#{prompt_message} [#{default}]: ") { |q| q.default = default }
end

def main
  mc_server_ip = get_input("Enter the Minecraft Server IP", "MC_SERVER_IP")
  mc_ssh_user = get_input("Enter the SSH User for Minecraft Server", "MC_SSH_USER", "root")
  mc_vault_token = get_input("Enter the Vault Token for Minecraft", "MC_VAULT_TOKEN")
  mc_vault_url = get_input("Enter the Vault URL for Minecraft", "MC_VAULT_URL")
  mc_secret_path = get_input("Enter the Secret Path for Minecraft in Vault", "MC_SECRET_PATH")
  mc_level_seed = get_input("Enter the desired seed for the Minecraft world", "MC_LEVEL_SEED")
  mc_gamemode = get_input("Enter the Minecraft Game Mode (survival, creative, adventure, spectator)", "MC_GAMEMODE", "survival")
  mc_level_name = get_input("Enter the Minecraft Server Name", "MC_LEVEL_NAME")
  mc_difficulty = get_input("Enter the Minecraft Difficulty (peaceful, easy, normal, hard)", "MC_DIFFICULTY", "peaceful")
  mc_pvp = get_input("Enable PvP? (true/false)", "MC_PVP", "true")
  verbose_level = get_input("Enter the verbose level (0-4)", "0").to_i

  inventory_file = create_inventory_file(mc_server_ip, mc_ssh_user)
  playbook_file = "minecraft-server.yaml"

  server_properties_vars = {
    "mc_level_seed" => mc_level_seed,
    "mc_gamemode" => mc_gamemode,
    "mc_level_name" => mc_level_name,
    "mc_difficulty" => mc_difficulty,
    "mc_pvp" => mc_pvp
  }

  vars_file = write_vars_to_file(server_properties_vars)

  run_ansible_playbook(inventory_file, playbook_file, vars_file, verbose_level)
end

main if __FILE__ == $0

