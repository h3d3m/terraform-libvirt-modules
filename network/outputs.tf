output "network_id" {
  description = "The libvirt network ID for referencing in libvirt_domain.network_interface"
  value       = libvirt_network.default.id
}

output "network_name" {
  description = "The libvirt network name for referencing in libvirt_domain.network_interface"
  value       = libvirt_network.default.name
}

output "network_bridge" {
  description = "Bridge device name created by libvirt"
  value       = libvirt_network.default.bridge
}

output "network_addresses" {
  description = "CIDR subnets assigned to the network"
  value       = libvirt_network.default.addresses
}