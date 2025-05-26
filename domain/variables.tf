variable "name" {
  description = "The name of the libvirt domain (VM)."
  type        = string
}

variable "description" {
  description = "An optional textual description for the domain."
  type        = string
  default     = null
}

variable "vcpu" {
  description = "Number of virtual CPUs to assign. Omit (null) to let libvirt default."
  type        = number
  default     = null
}

variable "memory" {
  description = "Amount of memory in MiB. Omit (null) to let libvirt default."
  type        = number
  default     = null
}

variable "running" {
  description = "Whether to start the domain immediately after create (true/false)."
  type        = bool
  default     = true
}

variable "cloudinit" {
  description = <<EOF
An optional cloudinit disk ID (for a libvirt_cloudinit_disk).  
Set to the `id` of your cloudinit resource, or null to disable.
EOF
  type        = string
  default     = null
}

variable "autostart" {
  description = "Whether the domain should autostart with the host."
  type        = bool
  default     = false
}

variable "arch" {
  description = "CPU architecture (e.g. x86_64, aarch64)."
  type        = string
  default     = null
}

variable "machine" {
  description = "The QEMU machine type (e.g. pc, q35)."
  type        = string
  default     = null
}

variable "emulator" {
  description = "Full path to the emulator binary."
  type        = string
  default     = null
}

variable "qemu_agent" {
  description = "Whether to enable the QEMU guest agent channel."
  type        = bool
  default     = false
}

variable "type" {
  description = "Domain type (e.g. hvm, qemu, kvm)."
  type        = string
  default     = null
}

variable "kernel" {
  description = "The path of the kernel to boot."
  type = string
  default = null
}

variable "initrd" {
  description = "The path of the initrd to boot."
  type = string
  default = null
}

variable "cmdline" {
  description = "Arguments to the kernel."
  type    = list(map(string))
  default = []
}

variable "firmware" {
  description = <<EOF
The UEFI rom images for exercising UEFI secure boot in a qemu environment. 
Users should usually specify one of the standard Open Virtual Machine Firmware (OVMF) images
available for their distributions. The file will be opened read-only.
EOF
  type = string
  default = null
}

variable "cpu" {
  description = "CPU tuning block. Omit or set mode to null to skip."
  type = object({
    mode = optional(string, null)
  })
  default = {}

  validation {
    condition     = contains(["custom", "host-model", "host-passthrough", "maximum"], var.cpu.mode)
    error_message = "Invalid libvirt domain cpu mode. Must be one of: custom, host-model, host-passthrough, maximum."
  }
}

variable "disk" {
  description = "List of disk definitions. You must set exactly one of volume_id, url, file or block_device per entry."
  type = list(map({
    volume_id    = optional(string) # a libvirt_volume.id
    url          = optional(string) # remote image URL
    file         = optional(string) # local file path
    block_device = optional(string) # host block device path
    scsi         = optional(bool, false)
    wwn          = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for d in var.disk : length([
        for v in [
          d.volume_id,
          d.url,
          d.file,
          d.block_device
        ] : v
        if v != null && v != ""
      ]) == 1
    ])
    error_message = <<EOF
Each disk entry must specify exactly one of:
  - volume_id
  - url
  - file
  - block_device

You provided: ${jsonencode(var.disk)}
EOF
  }
}

variable "network_interface" {
  description = "List of network‐interface blocks."
  type = list(object({
    network_name   = optional(string)
    network_id     = optional(string)
    mac            = optional(string)
    addresses      = optional(list(string))
    hostname       = optional(string)
    wait_for_lease = optional(bool, false)
    bridge         = optional(string)
    vepa           = optional(bool, false)
    macvtap        = optional(bool, false)
    passthrough    = optional(bool, false)
    private        = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for n in var.network_interface : length([
        for v in [
          n.bridge,
          n.vepa,
          n.macvtap,
          n.passthrough,
          n.private
        ] : v
        if v != null && v != ""
      ]) == 1
    ])
    error_message = <<EOF
Each network_interface entry must specify exactly one of:
  - bridge
  - vepa
  - macvtap
  - passthrough
  - private

You provided: ${jsonencode(var.network_interface)}
EOF
  }
}

variable "filesystem" {
  description = "List of filesystem passthroughs."
  type = list(object({
    accessmode = optional(string, "passthrough") # passthrough, mapped, etc
    source     = string
    target     = string
    readonly   = optional(bool, false)
  }))
  default = []
}

variable "boot_devices" {
  description = "List of block devices to try at boot (in order)."
  type        = list(string) # valid values: "hd", "cdrom", "network"
  default     = []
}

variable "tpm" {
  description = "Optional TPM passthrough or emulator block. Omit to disable."
  type = object({
    model                     = optional(string) # e.g. tpm-tis, tpm-crb
    backend_type              = optional(string) # emulator or passthrough
    backend_device_path       = optional(string) # when passthrough
    backend_encryption_secret = optional(string) # when emulator+encrypted
    backend_version           = optional(number) # numeric version
    backend_persistent_state  = optional(bool)   # emulator state dir
  })
  default = {}
}

variable "nvram" {
  description = "Block allows specifying the following attributes related to the nvram."
  type = object({
    file = optional(string, null),
    template = optional(string, null)
  })
  default = {}
}

variable "graphics" {
  description = "Block allows you to override the default graphics settings."
  type = object({
    type = optional(string, null)
    autoport = optional(bool, null)
    listen_type = optional(string, null)
    listen_address = optional(string, null)
    websocket = optional(number, null)
  })
  default = {}
}

variable "video" {
  description = "Block allows you to change from libvirt default cirrus to vga or others."
  type = string
  default = null
}

variable "console" {
  description = "block allows you to define a console for the domain."
  type = object({
    type = optional(string, null)
    target_port = optional(string, null)
    target_type = optional(string, null)
    source_path = optional(string, null)
    source_host = optional(string, null)
    source_service = optional(string, null)
  })
  default = {}

  validation {
    condition     = contains(["serial", "virtio"], var.console.target_type)
    error_message = "Invalid libvirt domain console target_type. Must be one of: serial, virtio."
  }
  validation {
    condition     = contains(["pty", "tcp"], var.console.type)
    error_message = "Invalid libvirt domain console type. Must be one of: pty, tcp."
  }
}
