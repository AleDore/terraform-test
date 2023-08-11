resource "azurerm_storage_account" "test" {
  name                     = "testalestorageaccount"
  resource_group_name      = azurerm_resource_group.test_rg.name
  location                 = azurerm_resource_group.test_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
    rusttestId  = azurerm_storage_account.drusttest.id
  }
}

resource "azurerm_management_lock" "test_lock" {
  name       = "resource-storage"
  scope      = azurerm_storage_account.test.id
  lock_level = "CanNotDelete"
  notes      = "Locked because it's needed by a third-party"
}

resource "azurerm_storage_account" "drusttest" {
  name                     = "iodrusttest"
  resource_group_name      = "iodrusttest"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

module "test_module_storage" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v5.6.0"

  name                             = replace("${local.project}testmodule", "-", "")
  account_kind                     = "StorageV2"
  account_tier                     = "Standard"
  access_tier                      = "Hot"
  account_replication_type         = "GRS"
  resource_group_name              = azurerm_resource_group.test_rg.name
  location                         = azurerm_resource_group.test_rg.location
  advanced_threat_protection       = true
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = true

  blob_versioning_enabled              = true
  blob_container_delete_retention_days = 7
  blob_delete_retention_days           = 7
  blob_change_feed_enabled             = true
  blob_change_feed_retention_in_days   = 10
  blob_restore_policy_days             = 6

  tags = var.tags
}