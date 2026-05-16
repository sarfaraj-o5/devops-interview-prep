resource "azurerm_virtual_machine_extension" "install" {
  name               = "install-app"
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  publisher          = "Microsoft.Compute"
  type               = "CustomScriptExtension"
  settings = jsondecode({
    "commandToExecute" = "powershell.exe -ExecutionPolicy Unrestricted -File install.ps1"
  })
}

data "azurerm_key_vault_secret" "dbpass" {
  name         = "db-password"
  key_vault_id = data.azurerm_key_vault.example.id
}

output "db_password" {
  value     = data.azurerm_key_vault_secret.dbpass.value
  sensitive = true
}
