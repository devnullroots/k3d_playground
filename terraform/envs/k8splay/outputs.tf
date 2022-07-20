output "k3d_password" {
    value = nonsensitive(random_password.k3d_pass.result)
}
output "k3d_ip" {
    value = azurerm_public_ip.k3d_public_ip.ip_address
}