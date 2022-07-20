module "sandbox_ca" {
    source                = "../../modules/selfcert"

    certificate_authority = var.certificate_authority
    server_certificates   = var.server_certificates
}