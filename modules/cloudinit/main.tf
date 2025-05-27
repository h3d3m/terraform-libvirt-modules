resource "libvirt_cloudinit_disk" "this" {
  name           = var.name
  pool           = var.pool
  user_data      = var.user_data
  meta_data      = var.meta_data
  network_config = var.network_config
}