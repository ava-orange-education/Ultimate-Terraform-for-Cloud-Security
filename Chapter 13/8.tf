# Create a Virtual Machine Scale Set in Azure
resource "azurerm_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard_DS1_v2"
  instances           = 2
  upgrade_policy_mode = "Automatic"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name_prefix = "examplevm"
    admin_username       = "azureuser"
    admin_password       = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "example-netprofile"
    primary = true

    ip_configuration {
      name                          = "internal"
      subnet_id                     = var.subnet_id  # Must be defined elsewhere
      primary                       = true
      load_balancer_backend_address_pools_ids = var.lb_backend_ids  # Must be defined if using LB
    }
  }
}

# Configure Autoscaling Settings for the VM Scale Set
resource "azurerm_monitor_autoscale_setting" "example" {
  name                = "example-autoscale"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  target_resource_id  = azurerm_virtual_machine_scale_set.example.id

  profile {
    name = "defaultProfile"
    
    capacity {
      minimum = "2"
      maximum = "10"
      default = "2"
    }
    
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.example.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }
  
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.example.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }
  
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}
