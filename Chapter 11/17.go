control "azure-blob-https" do
  title "Ensure HTTPS is enabled for Azure Blob Storage"
  describe azurerm_storage_account(resource_group: 'example-group', name: 'exampleaccount') do
    it { should have_https_traffic_only }
  end
end
