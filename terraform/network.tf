resource "oci_core_vcn" "minecraft" {
  compartment_id = oci_identity_compartment.minecraft.id
  cidr_blocks    = ["10.1.0.0/16"]
  display_name   = "Minecraft VCN"
  is_ipv6enabled = false
}

resource "oci_core_subnet" "minecraft" {
  cidr_block                 = "10.10.0.0/24"
  compartment_id             = oci_identity_compartment.minecraft.id
  vcn_id                     = oci_core_vcn.minecraft.id
  display_name               = "Minecraft Subnet"
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.minecraft.id
  security_list_ids          = [oci_core_security_list.minecraft.id]
}

resource "oci_core_internet_gateway" "minecraft" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.minecraft.id
  enabled        = true
  display_name   = "Minecraft Internet Gateway"
}

resource "oci_core_route_table" "minecraft" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.minecraft.id
  display_name   = "Minecraft Route Table"
  route_rules {
    network_entity_id = oci_core_internet_gateway.minecraft.id
    description       = "Default Route"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}