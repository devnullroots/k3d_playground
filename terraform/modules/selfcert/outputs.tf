output "certificate_authority_private_key" {
    value = tls_self_signed_cert.root_ca.private_key_pem
}

output "certificate_authority_certificate" {
    value = tls_self_signed_cert.root_ca.cert_pem
}


output "server_certificates" {
    #Time to bleed from the eyes
    value = {for k,v in var.server_certificates : k => 
        {"certificate" = tls_locally_signed_cert.server_certs_signage[k].cert_pem ,
         "csr"         = tls_cert_request.server_cert_reqs[k].cert_request_pem,
         "private_key" = nonsensitive(tls_private_key.server_keys[k].private_key_pem)
        } }
}