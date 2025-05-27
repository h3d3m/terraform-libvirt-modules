variable "name" {
  description = "A unique name for the resource, required by libvirt."
  type        = string
}

variable "pool" {
  description = "The pool where the resource will be created."
  type        = string
  default     = "default"
}

variable "user_data" {
  description = "cloud-init user data."
  type        = string
  default     = ""
}

variable "meta_data" {
  description = "cloud-init meta data."
  type        = string
  default     = ""
}

variable "network_config" {
  description = "cloud-init network-config data."
  type        = string
  default     = ""
}