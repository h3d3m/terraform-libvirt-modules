resource "libvirt_domain" "default" {
  name        = var.name
  description = var.description # Optional
  vcpu        = var.vcpu        # Optional
  memory      = var.memory      # Optional
  running     = var.running     # Optional
  cloudinit   = var.cloudinit   # Optional
  autostart   = var.autostart   # Optional
  arch        = var.arch        # Optional
  machine     = var.machine     # Optional
  emulator    = var.emulator    # Optional
  qemu_agent  = var.qemu_agent  # Optional
  type        = var.type        # Optional
  kernel      = var.kernel      # Optional
  initrd      = var.initrd      # Optional
  cmdline     = var.cmdline     # Optional
  firmware    = var.firmware    # Optional

  cpu {                 # Optional
    mode = var.cpu.mode # Optional
  }

  dynamic "disk" { # Optional
    for_each = var.disk
    content {
      # One of volume_id, url, file, block_device
      volume_id    = disk.value.volume_id    # Optional
      url          = disk.value.url          # Optional
      file         = disk.value.file         # Optional
      block_device = disk.value.block_device # Optional
      scsi         = disk.value.scsi         # Optional
      wwn          = disk.value.wwn          # Optional
    }
  }

  dynamic "network_interface" { # Optional
    for_each = var.network_interface
    content {
      network_name   = network_interface.value.network_name   # Optional
      network_id     = network_interface.value.network_id     # Optional
      mac            = network_interface.value.mac            # Optional
      addresses      = network_interface.value.addresses      # Optional
      hostname       = network_interface.value.hostname       # Optional
      wait_for_lease = network_interface.value.wait_for_lease # Optional
      bridge         = network_interface.value.bridge         # Optional
      vepa           = network_interface.value.vepa           # Optional
      macvtap        = network_interface.value.macvtap        # Optional
      passthrough    = network_interface.value.passthrough    # Optional
      private        = network_interface.value.private        # Optional
    }
  }

  dynamic "filesystem" { # Optional
    for_each = var.filesystem
    content {
      accessmode = filesystem.value.accessmode # Optional
      source     = filesystem.value.source
      target     = filesystem.value.target
      readonly   = filesystem.value.readonly # Optional
    }
  }

  boot_device {
    dev = var.block_device.dev # Optional
  }

  tpm {
    model                     = var.tpm.model                     # Optional
    backend_type              = var.tpm.backend_type              # Optional
    # Additional attributes when backend_type is "passthrough"
    backend_device_path       = var.tpm.backend_device_path       # Optional
    # Additional attributes when backend_type is "emulator"
    backend_encryption_secret = var.tpm.backend_encryption_secret # Optional
    backend_version           = var.tpm.backend_version           # Optional
    backend_persistent_state  = var.tpm.backend_persistent_state  # Optional
  }

  nvram {
    file     = var.nvram.file     # Optional
    template = var.nvram.template # Optional
  }

  graphics {
    type           = var.graphics.type           # Optional
    autoport       = var.graphics.autoport       # Optional
    listen_type    = var.graphics.listen_type    # Optional
    listen_address = var.graphics.listen_address # Optional
    websocket      = var.graphics.websocket      # Optional
  }

  video {
    type = var.video.type # Optional
  }

  dynamic "console" {
    for_each = var.console
    content {
      type           = console.value.type
      target_port    = console.value.target_port
      target_type    = console.value.target_type    # Optional ("serial" or "virtio")
      # Additional attributes when type is "pty"
      source_path    = console.value.source_path    # Optional
      # Additional attributes when type is "tcp"
      source_host    = console.value.source_host    # Optional
      source_service = console.value.source_service # Optional
    }
  }
}