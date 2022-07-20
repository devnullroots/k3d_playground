terraform {
    required_providers {
        azurerm = {
            source      = "hashicorp/azurerm"
            version     = "=3.14.0"
        }
        tls = {
            source      = "hashicorp/tls"
            version     = "2.2.0"
        }
        random = {
            source      = "hashicorp/random"
        }
        template ={
            source      = "hashicorp/template"
        }
    }
    required_version = "1.2.5"
}

provider "azurerm" {
    features {
      
    }
    skip_provider_registration = true
}