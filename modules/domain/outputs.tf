output "id" {
  description = "The ID of the libvirt domain"
  value       = libvirt_domain.this.id
}

output "name" {
  description = "The name of the libvirt domain"
  value       = libvirt_domain.this.name
}

output "network_interfaces" {
  description = "Network interface configurations and assigned IPs"
  value = [
    for ni in libvirt_domain.this.network_interface : {
      mac       = ni.mac
      addresses = ni.addresses
      hostname  = ni.hostname
    }
  ]
}

output "memory" {
  description = "Allocated memory in MB"
  value       = libvirt_domain.this.memory
}

output "vcpu" {
  description = "Number of allocated virtual CPUs"
  value       = libvirt_domain.this.vcpu
}

output "arch" {
  description = "CPU architecture of the domain"
  value       = libvirt_domain.this.arch
}

output "running" {
  description = "Whether the domain is currently running"
  value       = libvirt_domain.this.running
}

output "autostart" {
  description = "Whether autostart is enabled for the domain"
  value       = libvirt_domain.this.autostart
}

output "graphics" {
  description = "Graphics connection information"
  value = length(libvirt_domain.this.graphics) > 0 ? {
    type    = libvirt_domain.this.graphics[0].type
    address = libvirt_domain.this.graphics[0].listen_address
    port    = libvirt_domain.this.graphics[0].autoport
  } : null
}

output "disk" {
  description = "Information about attached disks"
  value = [
    for disk in libvirt_domain.this.disk : {
      volume_id = disk.volume_id
      file      = disk.file
      scsi      = disk.scsi
      wwn       = disk.wwn
    }
  ]
}

output "console" {
  description = "Console access configuration"
  value = [
    for console in libvirt_domain.this.console : {
      type        = console.type
      target_port = console.target_port
      source_path = console.source_path
    }
  ]
}

output "emulator" {
  description = "Path to the emulator binary"
  value       = libvirt_domain.this.emulator
}

output "machine" {
  description = "Machine type of the domain"
  value       = libvirt_domain.this.machine
}

output "xml" {
  description = "Complete XML configuration of the domain (for debugging)"
  value       = data.libvirt_domain.this.xml
  sensitive   = false
}
