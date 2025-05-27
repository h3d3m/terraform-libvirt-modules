variable "name" {
  description = "A unique name for the resource, required by libvirt."
  type        = string
}

variable "type" {
  description = "The type of the pool."
  type        = string

  validation {
    condition     = contains(["dir", "logical"], var.type)
    error_message = "Currently, \"dir\" and \"logical\" are supported."
  }
}

variable "path" {
  description = "The path of the pool"
  type        = string
  default     = "/var/lib/machines/pools/"
}