#!/usr/bin/env python
from constructs import Construct
from cdktf import App, TerraformStack,TerraformVariable,Token
from imports.azurerm import AzurermProvider, VirtualNetwork

class MyStack(TerraformStack):
    def __init__(self, scope: Construct, ns: str):
        super().__init__(scope, ns)

        # define resources here
        #Variable for the module
        resource_group_name=TerraformVariable(self,id="resource_group_name")
        resource_group_location=TerraformVariable(self, id="resource_group_location")
        network_map=TerraformVariable(self,id="network",type="map",description="Network Map")
        project_name=TerraformVariable(self,id="project_name",type="string")
        
        AzurermProvider(self,'azurerm',features={})

        #Resources
        my_vpc=VirtualNetwork(self,
            'my-vpc',
            name = f"{Token().as_string(project_name.string_value)}-vpc",
            location = Token().as_string(resource_group_location.string_value),
            address_space=["10.0.10.0/16"],
            resource_group_name=Token().as_string(resource_group_name.string_value),
            tags = {
                "ENV": "PROD",
                "note": "just_kidding"
            }
        )

app = App()
MyStack(app, "network")

app.synth()
