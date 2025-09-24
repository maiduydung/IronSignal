resource "random_id" "rand" {
  byte_length = 4
}

resource "azurerm_resource_group" "default" {
  name     = "IronSignal"
  location = "Southeast Asia"
}

resource "azurerm_storage_account" "funcapp_sa" {
  name                     = "isignalfuncsa${random_id.rand.hex}"
  resource_group_name      = azurerm_resource_group.default.name
  location                 = azurerm_resource_group.default.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "plan" {
  name                = "IronSignalAppPlan"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                       = "isignal-func-${random_id.rand.hex}"
  location                   = azurerm_resource_group.default.location
  resource_group_name        = azurerm_resource_group.default.name
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.funcapp_sa.name
  storage_account_access_key = azurerm_storage_account.funcapp_sa.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}
