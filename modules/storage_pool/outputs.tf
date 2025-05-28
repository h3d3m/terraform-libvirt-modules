output "id" {
  description = "ID of the libvirt storage pool"
  value = libvirt_pool.this.id
}

output "name" {
  description = "A unique name for the resource"
  value = libvirt_pool.this.name
}