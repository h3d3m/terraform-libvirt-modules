resource "libvirt_pool" "default" {
  name = var.name
  type = var.type
  target {
    path = var.path
  }
}