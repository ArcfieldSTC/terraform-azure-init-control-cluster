provider "azurerm" {
  features {
    api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }
    app_configuration {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }
    key_vault {
      purge_soft_delete_on_destroy                            = true
      purge_soft_deleted_certificates_on_destroy              = true
      purge_soft_deleted_hardware_security_modules_on_destroy = true
      purge_soft_deleted_keys_on_destroy                      = true
      purge_soft_deleted_secrets_on_destroy                   = true
      recover_soft_deleted_certificates                       = true
      recover_soft_deleted_key_vaults                         = true
      recover_soft_deleted_keys                               = true
      recover_soft_deleted_secrets                            = true
    }
    managed_disk {
      expand_without_downtime = true
    }
    subscription {
      prevent_cancellation_on_destroy = false
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = false
    }
    virtual_machine_scale_set {
      force_delete                  = false
      roll_instances_when_required  = true
      scale_to_zero_before_deletion = true
    }
  }
  use_oidc = true
}

run "test_module" {
    variables {
        name_prefix = "test-init-cc"
        primary_region = "USGov Virginia"
        default_tags = {
            Environment = "Init"
            CostType = "OH"
        }
        vnet_cidr = "192.168.0.0/24"
        flux_git_url = "https://github.com/ArcfieldSTC/gitops-system"
        kv_network_acls_default_action = "Allow"
        kv_network_acls_ip_rules = ["20.253.78.0/24", "20.80.156.0/24"]
        aks_enable_host_encryption = false
    }
    command = apply
    
    assert {
        condition = azurerm_resource_group.this.name == "test-init-cc-rg"
        error_message = "Invalid name for resource group"
    }
    assert {
        condition = azurerm_network_security_group.this.name == "test-init-cc-nsg"
        error_message = "Invalid name for NSG"
    }
    assert {
      condition = azurerm_virtual_network.this.name == "test-init-cc-vnet"
      error_message = "Invalid name for VNet"
    }
    assert {
      condition = azurerm_subnet.this.name == "test-init-cc-subnet"
      error_message = "Invalid name for Subnet"
    }
    assert {
      condition = azurerm_key_vault.this.name == "test-init-cc-kv"
      error_message = "Invalid name for Key Vault"
    }
}
