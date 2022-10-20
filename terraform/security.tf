resource "oci_core_security_list" "minecraft" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.minecraft.id
  display_name   = "Minecraft Subnet Security List"
  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
    description      = "Allow all outbound."
    destination_type = "CIDR_BLOCK"
    stateless        = false
  }
  ingress_security_rules {
    protocol    = "6"
    source      = "YOUR.IP.GOES.HERE/32"
    description = "Allow SSH inbound to VM for admin."
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Allow TCP Minecraft traffic inbound."
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 25565
      min = 25565
    }
  }
  ingress_security_rules {
    protocol    = "17"
    source      = "0.0.0.0/0"
    description = "Allow UDP Minecraft traffic inbound."
    source_type = "CIDR_BLOCK"
    stateless   = false
    udp_options {
      max = 25565
      min = 25565
    }
  }
}