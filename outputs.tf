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


output "storage_account_name" {
  value       = azurerm_storage_account.bootstrap-storage-acct.name
  description = "Boostrap storage account"
}

output "access_key" {
  value       = azurerm_storage_account.bootstrap-storage-acct.primary_access_key
  description = "Bootstrap storage account access key"
}

output "share_name" {
  value       = azurerm_storage_share.bootstrap-storage-share.name
  description = "Bootstrap storage share name"
}
