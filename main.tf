############################################################################################
# Copyright 2020 Palo Alto Networks.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
############################################################################################


resource "random_id" "suffix" {
  byte_length = 2
}

resource "azurerm_storage_account" "bootstrap-storage-acct" {
  name                     = "bootstrapacct${random_id.suffix.dec}"
  resource_group_name      = var.azure_resource_group
  location                 = var.azure_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "bootstrap-storage-share" {
  name                 = "bootstrapshare${random_id.suffix.dec}"
  storage_account_name = azurerm_storage_account.bootstrap-storage-acct.name
}

# resource "azurerm_storage_share_directory" "bootstrap_dirs" {
#   for_each = toset(var.bootstrap_directories)

#   name                 = each.value
#   share_name           = azurerm_storage_share.bootstrap-storage-share.name
#   storage_account_name = azurerm_storage_account.bootstrap-storage-acct.name
# }

data "template_file" "render-init-cfg" {
  template = file("${path.module}/init-cfg.tmpl")
  vars = {
    "hostname"         = var.hostname,
    "panorama-server"  = var.panorama-server,
    "panorama-server2" = var.panorama-server2,
    "tplname"          = var.tplname,
    "dgname"           = var.dgname,
    "dns-primary"      = var.dns-primary,
    "dns-secondary"    = var.dns-secondary,
    "vm-auth-key"      = var.vm-auth-key,
    "op-command-modes" = var.op-command-modes
  }
}

resource "local_file" "write-init-cfg" {
  content  = data.template_file.render-init-cfg.rendered
  filename = "${path.root}/files/config/init-cfg.txt"
}

resource "null_resource" "file_uploads" {

  provisioner "local-exec" {
    command = "cd ${path.root}/files; az storage file upload-batch --account-name ${azurerm_storage_account.bootstrap-storage-acct.name} --account-key ${azurerm_storage_account.bootstrap-storage-acct.primary_access_key} --source . --destination ${azurerm_storage_share.bootstrap-storage-share.name}"
    interpreter = ["PowerShell", "-Command"]
  }
}

