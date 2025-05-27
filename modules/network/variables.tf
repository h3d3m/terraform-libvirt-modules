variable "name" {
  description = "Name of the libvirt network"
  type        = string
}

variable "mode" {
  description = "Network mode (e.g. nat, none, route, open, bridge)"
  type        = string
  default     = "nat"

  validation {
    condition     = contains(["nat", "none", "route", "open", "bridge"], var.mode)
    error_message = "Invalid libvirt network mode. Must be one of: nat, none, route, open, bridge."
  }
}

variable "domain" {
  description = "DNS domain for this network"
  type        = string
  default     = null
}

variable "addresses" {
  description = "List of CIDR subnets for this network"
  type        = list(string)
  default = []
}

variable "bridge" {
  description = "Custom bridge name (omit for auto-generated)"
  type        = string
  default     = null

  validation {
    condition = var.mode != "bridge" || (var.bridge != null && length(var.bridge) > 0)
    error_message = "The bridge name must be set with mode = \"bridge\""
  }
}

variable "mtu" {
  description = "MTU for the bridge (optional)"
  type        = number
  default     = null

  validation {
    condition     = var.mode != "bridge" || var.mtu == null
    error_message = "MTU value must be omitted with mode = \"bridge\""
  }
}

variable "autostart" {
  description = "Whether the network starts automatically"
  type        = bool
  default     = false
}

variable "dns" {
  description = "DNS settings (omit by leaving enabled=false)"
  type = object({
    enabled     = optional(bool, false)
    local_only  = optional(bool, false)
    forwarders  = optional(list(object({
      address = optional(string),
      domain = optional(string)
    })), [])
    hosts       = optional(list(object({
      hostname = string,
      ip = string
    })), [])
    srvs        = optional(list(object({
      service = string,
      protocol = string
    })), [])
  })
  default = {}
}

variable "dhcp" {
  description = "DNS settings"
  type        = object({
    enabled = optional(bool, false)
  })
  default     = {}
}

variable "routes" {
  description = "Static routes (cidr & gateway) to add"
  type = list(object({
    cidr    = string
    gateway = string
  }))
  default = []
}

variable "dnsmasq_options" {
  description = "Custom dnsmasq options via nested blocks"
  type = object({
    options = optional(list(object({
      option_name  = string
      option_value = optional(string)
    })), [])
  })
  default = {}
}