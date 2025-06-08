# modules/libvirt-network/outputs.tf
output "id" {
  description = "Network ID"
  value       = libvirt_network.this.id
}

output "bridge" {
  description = "Bridge interface name"
  value       = libvirt_network.this.bridge
}

output "addresses" {
  description = "IP address ranges"
  value       = libvirt_network.this.addresses
}