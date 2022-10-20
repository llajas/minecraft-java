output "instance_ip_addr" {
  value = oci_core_instance.minecraft_server.public_ip
}
