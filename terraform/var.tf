variable "image_name" {
  type    = string
  default = "debian-12.0.0"
}

variable "flavor_name" {
  type    = string
  default = "m1.medium"
}

variable "ssh_key_name" {
  default = "gridexx-latitude5420"
}

variable "security_groups" {
  default = ["web-http"]
}

variable "public_network_name" {
  default = "public2"
}

variable "keycloak_hostname" {
  type        = string
  description = "Keycloak hostname, e.g. keycloak.example.com"
}

variable "guacamole_hostname" {
  type        = string
  description = "Guacamole hostname, e.g. guacamole.example.com"
}