variable "identity_management_type" {
  type    = string
  default = "CONNECT_MANAGED"  # Default identity management
}

variable "inbound_calls_enabled" {
  type    = bool
  default = true
}

variable "outbound_calls_enabled" {
  type    = bool
  default = true
}

variable "instance_alias" {
  type    = string
  default = "regions-bank-test"
}
