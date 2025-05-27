resource "libvirt_pool" "this" {
  name = var.name
  type = var.type
  target {
    path = var.path
  }
}