resource "oci_identity_compartment" "minecraft" {
  compartment_id = "ocid1.tenancy.oc1..abcdefghijklmnopqrstuzwxyz"
  description    = "Compartment for minecraft server."
  name           = "minecraft"
}
