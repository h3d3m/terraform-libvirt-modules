resource "libvirt_domain" "this" {
  name            = var.name
  memory          = var.memory
  vcpu            = var.vcpu  
  arch            = var.arch
  machine         = var.machine
  firmware        = var.firmware
  autostart       = var.autostart
  running         = var.running
  qemu_agent      = var.qemu_agent
  cloudinit       = var.cloudinit
  coreos_ignition = var.coreos_ignition
  
  dynamic "boot_device" {
    for_each = var.boot_devices
    content {
      dev = bootdevice.value
    }
  }
  
  dynamic "cpu" {
    for_each = var.cpu_mode != null ? [1] : []
    content {
      mode = var.cpu_mode
    }
  }
  
  dynamic "disk" {
    for_each = var.disks
    content {
      volume_id    = lookup(disk.value, "volume_id", null)
      file         = lookup(disk.value, "file", null)
      url          = lookup(disk.value, "url", null)
      block_device = lookup(disk.value, "block_device", null)
      scsi         = lookup(disk.value, "scsi", false)
      wwn          = lookup(disk.value, "wwn", null)
    }
  }
  
  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      network_name   = lookup(network_interface.value, "network_name", null)
      network_id     = lookup(network_interface.value, "network_id", null)
      bridge         = lookup(network_interface.value, "bridge", null)
      vepa           = lookup(network_interface.value, "vepa", null)
      macvtap        = lookup(network_interface.value, "macvtap", null)
      passthrough    = lookup(network_interface.value, "passthrough", null)
      mac            = lookup(network_interface.value, "mac", null)
      hostname       = lookup(network_interface.value, "hostname", null)
      wait_for_lease = lookup(network_interface.value, "wait_for_lease", true)
      addresses      = lookup(network_interface.value, "addresses", [])
    }
  }
  
  dynamic "graphics" {
    for_each = var.enable_graphics ? [1] : []
    content {
      type          = var.graphics_type
      listen_type   = var.graphics_listen_type
      listen_address = var.graphics_listen_address
      autoport      = var.graphics_autoport
      websocket     = var.graphics_websocket_port
    }
  }
  
  dynamic "console" {
    for_each = var.console
    content {
      type           = console.value.type
      target_port    = console.value.target_port
      target_type    = lookup(console.value, "target_type", null)
      source_path    = lookup(console.value, "source_path", null)
      source_host    = lookup(console.value, "source_host", null)
      source_service = lookup(console.value, "source_service", null)
    }
  }
  
  dynamic "filesystem" {
    for_each = var.filesystems
    content {
      source      = filesystem.value.source
      target      = filesystem.value.target
      readonly    = lookup(filesystem.value, "readonly", false)
      accessmode  = lookup(filesystem.value, "accessmode", "mapped")
    }
  }
  
  dynamic "tpm" {
    for_each = var.enable_tpm ? [1] : []
    content {
      backend_type             = var.tpm_backend_type
      backend_version          = var.tpm_backend_version
      backend_encryption_secret = var.tpm_encryption_secret
      backend_persistent_state = var.tpm_persistent_state
      backend_device_path      = var.tpm_device_path
      model                   = var.tpm_model
    }
  }
  
  dynamic "video" {
    for_each = var.video_type != null ? [1] : []
    content {
      type = var.video_type
    }
  }
  
  dynamic "nvram" {
    for_each = var.nvram_template != null ? [1] : []
    content {
      file     = var.nvram_file
      template = var.nvram_template
    }
  }
  
  dynamic "xml" {
    for_each = var.xml_override != null ? [1] : []
    content {
      xslt = var.xml_override
    }
  }
  
  timeouts {
    create = var.create_timeout
  }
}
