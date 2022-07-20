certificate_authority = {
    common_name = "gdp.allianz"
    country = "DE"
    locality = "Munich"
    organization = "Allianz"
    unit = "GDP"
    validity = 87600 # 10 years
  }
server_certificates ={
    server-1 = {
      common_name = "server1.gdp.allianz"
      country = "DE"
      locality = "Munich"
      organization = "Allianz"
      unit = "GDP"
      validity = 8760 #1 year
    }

    server-2 = {
      common_name = "server2.gdp.allianz"
    }
}