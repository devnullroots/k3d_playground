
output "certificate_authority_private_key" {
    value = nonsensitive(module.sandbox_ca.certificate_authority_private_key)
}

output "certificate_authority_certificate" {
    value = module.sandbox_ca.certificate_authority_certificate
}


output "server_certificates" {
    value = module.sandbox_ca.server_certificates
}