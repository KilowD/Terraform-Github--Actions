terraform {
  required_providers {
    azurerm   = {
      source  = "hashicorp/azurerm"
      version = "~> 3.19.1" //2.65
    }
  }
}

# specify the backend to use 

terraform {
  backend "azurerm" {
    resource_group_name             = "pams"
    storage_account_name            = "storage4learn4terraform"
    container_name                  = "tfstatefile" 
    key                             = "dev.terraform.tfstate"
  }
}


# Authenticate Azure
# the feature block allows the behaviour of each resource to be configured individually
provider "azurerm" {
   subscription_id  = "${var.subscription_id}"
   client_id        = "${var.client_id}"
   client_secret    = "${var.client_secret}"
   tenant_id        = "${var.tenant_id}"
   
   features {
        resource_group {
                prevent_deletion_if_contains_resources = true
             }
        virtual_machine {
                delete_os_disk_on_deletion     = true
                graceful_shutdown              = false
                skip_shutdown_and_force_delete = false
            }     
   }
}

# on the left put  the variables exactly the  way they are defined in their modules
# the values come from the variables and the tfvars in this main 
module "rg" {
    source                 = "../modules/rg"
    base_name              = var.base_name 
    location               = var.location 
  }

module "vm" {
    source                = "../modules/vm"
    prefix                = var.prefix
    location              = module.rg.rg_location
    base_name             = module.rg.rg_name
}