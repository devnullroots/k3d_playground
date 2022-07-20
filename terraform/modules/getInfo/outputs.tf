output "internet_provider_info" {
  value = {
    "asn"       = jsondecode(data.http.my_info.body)["asn"]
    "country"   = jsondecode(data.http.my_info.body)["country"]
    "ip"        = jsondecode(data.http.my_info.body)["ip"]
  }
}