variable "server_certificates" {
    type        = map
    description = "A map of server certificates to create"
  
}

variable  "certificate_authority" {
    type        = map
    description = "A map of certificate authority information"
}