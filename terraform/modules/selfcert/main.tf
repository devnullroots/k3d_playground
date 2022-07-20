/*Firstly setup the CA authority key. Lots of warning on doing
this but it is a throw away environemnt. Normally these secrets would be in a keyvault 
and retrieved via terraform and the sensitive function to avoid leaking it
*/
resource "tls_private_key" "root_ca_key" {
    algorithm               = "RSA"
    rsa_bits                = 4096
}

#Create the self-signed root certificate. 
resource "tls_self_signed_cert" "root_ca" {
    private_key_pem         = tls_private_key.root_ca_key.private_key_pem

    subject {
      common_name           = var.certificate_authority["common_name"]
      organization          = var.certificate_authority["organization"]
      locality              = var.certificate_authority["locality"]
      country               = var.certificate_authority["country"]
      organizational_unit   = var.certificate_authority["unit"]
    }
    validity_period_hours   = var.certificate_authority["validity"]

    allowed_uses            = [
        "key_encipherment",
        "digital_signature",
        "crl_signing",
        "cert_signing",
    ]
    is_ca_certificate       = true

}
#Create the server pem keys
resource "tls_private_key" "server_keys" {
    for_each                 = var.server_certificates

    algorithm                = "RSA"
    rsa_bits                 = "2048" 
}

#Create the certificate requests

resource "tls_cert_request" "server_cert_reqs" {
    for_each                = var.server_certificates
    private_key_pem         = tls_private_key.server_keys[each.key].private_key_pem
    depends_on = [
      tls_private_key.server_keys
    ]
    subject {
      common_name           = each.value["common_name"]
      #Since all these are optional we want to null them if they are not provided
      organization          = try(each.value["organization"], null )
      locality              = try(each.value["locality"], null )
      country               = try(each.value["country"], null )
      organizational_unit   = try(each.value["unit"], null )
    }   
 
}

#Signing the certificates time
resource "tls_locally_signed_cert" "server_certs_signage" {
    for_each                = var.server_certificates

    ca_private_key_pem      = tls_private_key.root_ca_key.private_key_pem
    ca_cert_pem             = tls_self_signed_cert.root_ca.cert_pem
    cert_request_pem        = tls_cert_request.server_cert_reqs[each.key].cert_request_pem

    validity_period_hours   = try(each.value["validity"],8760)

    allowed_uses = [
        "key_encipherment",
        "digital_signature",
        "server_auth"
    ]
}

