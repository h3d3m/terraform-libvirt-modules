variable "name" {
  type        = string
  description = "(Required) Name of the network"
}

variable "mode" {
  type        = string
  description = "(Optional) Network mode (nat, route, bridge)"
  default     = "nat"
}

variable "domain" {
  type        = string
  description = "(Optional) DNS domain name"
  default     = null
}

variable "addresses" {
  type        = list(string)
  description = "(Optional) List of IP addresses in CIDR format"
  default     = null
}

variable "autostart" {
  type        = bool
  description = "(Optional) Auto-start network on host boot"
  default     = null
}

variable "bridge" {
  type        = string
  description = "(Optional) Bridge device name"
  default     = null
}

variable "mtu" {
  type        = number
  description = "(Optional) MTU size"
  default     = null
}

variable "dhcp" {
  type = object({
    enabled = bool
  })
  description = "(Optional) DHCP configuration block"
  default     = null
}

variable "dns" {
  type = object({
    enabled    = bool
    local_only = bool
    forwarders = list(object({
      address = string
      domain  = string
    }))
    hosts = set(object({
      hostname = string
      ip       = string
    }))
    srvs = list(object({
      domain   = string
      port     = string
      priority = string
      protocol = string
      service  = string
      target   = string
      weight   = string
    }))
  })
  description = "(Optional) DNS configuration block"
  default     = null
}

variable "dnsmasq_options" {
  type = object({
    options = list(object({
      option_name  = string
      option_value = string
    }))
  })
  description = "(Optional) DNSmasq options configuration"
  default     = null
}

variable "routes" {
  type = list(object({
    cidr    = string
    gateway = string
  }))
  description = "(Optional) Static route definitions"
  default     = null
}

variable "xml" {
  type = object({
    xslt = string
  })
  description = "(Optional) XML XSLT transformation"
  default     = null
}
