data "oci_core_image" "oracle_linux_9" {
  image_id = "ocid1.image.oc1.iad.aaaaaaaa26f5jvfjhdsdiy5pee3yiud7ersl7325cmbf4cltf7mqzczuz6bq"
}

resource "oci_core_instance" "minecraft_server" {

  availability_domain = "US-REGION-01"
  compartment_id      = oci_identity_compartment.minecraft.id
  shape               = "VM.Standard.A1.Flex"

  availability_config {
    is_live_migration_preferred = true
    recovery_action             = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    assign_public_ip       = true
    display_name           = "minecraft-server-vnic"
    skip_source_dest_check = false
    subnet_id              = oci_core_subnet.minecraft.id
  }
  display_name = "minecraft_server"
  metadata = {
    ssh_authorized_keys = file("/Users/username/.ssh/id_rsa.pub")
  }
  shape_config {
    memory_in_gbs = 6
    ocpus         = 2
  }
  source_details {
    source_id               = data.oci_core_image.oracle_linux_9.id
    source_type             = "image"
    boot_volume_size_in_gbs = 100
  }
  preserve_boot_volume = false
}