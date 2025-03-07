data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "mlrg-m" {
  name     = "ml_rg-resources-maryam"
  location = "West Europe"
}

resource "azurerm_application_insights" "applicationinsight" {
  name                = "workspace-example-ai"
  location            = azurerm_resource_group.mlrg-m.location
  resource_group_name = azurerm_resource_group.mlrg-m.name
  application_type    = "web"
}

resource "azurerm_key_vault" "azurekeyvault" {
  name                = "workspaceexamplekeyvaultmaryam"
  location            = azurerm_resource_group.mlrg-m.location
  resource_group_name = azurerm_resource_group.mlrg-m.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_storage_account" "azurestorageaccount" {
  name                     = "workspacestorageaccountmaryam"
  location                 = azurerm_resource_group.mlrg-m.location
  resource_group_name      = azurerm_resource_group.mlrg-m.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_machine_learning_workspace" "example" {
  name                    = "example-workspacemaryam"
  location                = azurerm_resource_group.mlrg-m.location
  resource_group_name     = azurerm_resource_group.mlrg-m.name
  application_insights_id = azurerm_application_insights.applicationinsight.id
  key_vault_id            = azurerm_key_vault.azurekeyvault.id
  storage_account_id      = azurerm_storage_account.azurestorageaccount.id

  identity {
    type = "SystemAssigned"
  }
}
