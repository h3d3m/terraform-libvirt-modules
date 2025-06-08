variable "name" {
  description = "Name of the libvirt domain (VM)"
  type        = string
}

variable "memory" {
  description = "Memory allocation in MB for the domain"
  type        = number
  default     = 1024
}

variable "vcpu" {
  description = "Number of virtual CPUs to allocate"
  type        = number
  default     = 1
}

variable "arch" {
  description = "CPU architecture for the domain"
  type        = string
  default     = "x86_64"
  
  validation {
    condition = contains([
      "x86_64", "aarch64", "armv7l", "i686", "ppc64", "ppc64le", "s390x"
    ], var.architecture)
    error_message = "Architecture must be a supported value."
  }
}

variable "machine" {
  description = "Machine type for the domain"
  type        = string
  default     = null
}

variable "firmware" {
  description = "Firmware type (BIOS/UEFI)"
  type        = string
  default     = null
  
  validation {
    condition = var.firmware_type == null || contains([
      "/usr/share/OVMF/OVMF_CODE.fd",
      "/usr/share/edk2-ovmf/x64/OVMF_CODE.fd"
    ], var.firmware_type)
    error_message = "Firmware must be a valid UEFI firmware path or null for BIOS."
  }
}

variable "autostart" {
  description = "Automatically start the domain when libvirtd starts"
  type        = bool
  default     = false
}

variable "running" {
  description = "Whether the domain should be running"
  type        = bool
  default     = true
}

variable "qemu_agent" {
  description = "Enable QEMU guest agent for enhanced guest management"
  type        = bool
  default     = true
}

variable "cpu_mode" {
  description = "CPU mode for the domain"
  type        = string
  default     = "host-passthrough"
  
  validation {
    condition = var.cpu_mode == null || contains([
      "host-passthrough", "host-model", "custom"
    ], var.cpu_mode)
    error_message = "CPU mode must be host-passthrough, host-model, or custom."
  }
}

variable "boot_devices" {
  description = "List of boot devices in order of preference"
  type        = list(list(string))
  default     = [["hd"], ["network"]]
  
  validation {
    condition = alltrue([
      for device_list in var.boot_devices : alltrue([
        for device in device_list : contains([
          "hd", "network", "cdrom", "fd"
        ], device)
      ])
    ])
    error_message = "Boot devices must be hd, network, cdrom, or fd."
  }
}

variable "disks" {
  description = "List of disk configurations for the domain"
  type = list(object({
    volume_id    = optional(string)
    file         = optional(string)
    url          = optional(string)
    block_device = optional(string)
    scsi         = optional(bool, false)
    wwn          = optional(string)
  }))
  default = []
  
  validation {
    condition = alltrue([
      for disk in var.disks : (
        (disk.volume_id != null ? 1 : 0) +
        (disk.file != null ? 1 : 0) +
        (disk.url != null ? 1 : 0) +
        (disk.block_device != null ? 1 : 0)
      ) == 1
    ])
    error_message = "Each disk must specify exactly one of: volume_id, file, url, or block_device."
  }
}

variable "network_interfaces" {
  description = "List of network interface configurations"
  type = list(object({
    network_name   = optional(string)
    network_id     = optional(string)
    bridge         = optional(string)
    vepa           = optional(string)
    macvtap        = optional(string)
    passthrough    = optional(string)
    mac            = optional(string)
    hostname       = optional(string)
    wait_for_lease = optional(bool, true)
    addresses      = optional(list(string), [])
  }))
  default = []
}

variable "enable_graphics" {
  description = "Enable graphics console (VNC/Spice)"
  type        = bool
  default     = false
}

variable "graphics_type" {
  description = "Graphics type (vnc or spice)"
  type        = string
  default     = "vnc"
  
  validation {
    condition     = contains(["vnc", "spice"], var.graphics_type)
    error_message = "Graphics type must be vnc or spice."
  }
}

variable "graphics_listen_type" {
  description = "Graphics listen type"
  type        = string
  default     = "address"
}

variable "graphics_listen_address" {
  description = "Graphics listen address"
  type        = string
  default     = "0.0.0.0"
}

variable "graphics_autoport" {
  description = "Automatically allocate graphics port"
  type        = bool
  default     = true
}

variable "graphics_websocket_port" {
  description = "WebSocket port for graphics console"
  type        = number
  default     = null
}

variable "console_configs" {
  description = "List of console configurations"
  type = list(object({
    type           = string
    target_port    = string
    target_type    = optional(string)
    source_path    = optional(string)
    source_host    = optional(string)
    source_service = optional(string)
  }))
  default = [
    {
      type        = "pty"
      target_port = "0"
      target_type = "serial"
    }
  ]
}

variable "filesystems" {
  description = "List of filesystem mount configurations"
  type = list(object({
    source     = string
    target     = string
    readonly   = optional(bool, false)
    accessmode = optional(string, "mapped")
  }))
  default = []
}

variable "enable_tpm" {
  description = "Enable TPM (Trusted Platform Module) for enhanced security"
  type        = bool
  default     = false
}

variable "tpm_backend_type" {
  description = "TPM backend type"
  type        = string
  default     = "emulator"
}

variable "tpm_backend_version" {
  description = "TPM backend version"
  type        = string
  default     = "2.0"
}

variable "tpm_encryption_secret" {
  description = "TPM encryption secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "tpm_persistent_state" {
  description = "Enable TPM persistent state"
  type        = bool
  default     = true
}

variable "tpm_device_path" {
  description = "TPM device path"
  type        = string
  default     = null
}

variable "tpm_model" {
  description = "TPM model"
  type        = string
  default     = "tpm-tis"
}

variable "video_type" {
  description = "Video adapter type"
  type        = string
  default     = null
  
  validation {
    condition = var.video_type == null || contains([
      "vga", "cirrus", "vmvga", "xen", "vbox", "qxl", "virtio"
    ], var.video_type)
    error_message = "Video type must be a supported adapter."
  }
}

variable "nvram_template" {
  description = "NVRAM template for UEFI"
  type        = string
  default     = null
}

variable "nvram_file" {
  description = "NVRAM file path"
  type        = string
  default     = null
}

variable "cloudinit_id" {
  description = "Cloud-init disk ID"
  type        = string
  default     = null
}

variable "coreos_ignition_id" {
  description = "CoreOS Ignition configuration ID"
  type        = string
  default     = null
}

variable "xml_override" {
  description = "XSLT stylesheet for XML domain configuration override"
  type        = string
  default     = null
}

variable "create_before_destroy" {
  description = "Create replacement domain before destroying the original"
  type        = bool
  default     = true
}

variable "prevent_destroy" {
  description = "Prevent accidental destruction of the domain"
  type        = bool
  default     = false
}

variable "create_timeout" {
  description = "Timeout for domain creation"
  type        = string
  default     = "10m"
}

variable "metadata" {
  description = "Custom metadata for the domain"
  type        = string
  default     = null
}

variable "description" {
  description = "Human-readable description of the domain"
  type        = string
  default     = "Terraform-managed libvirt domain"
}
