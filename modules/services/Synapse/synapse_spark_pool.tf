resource "azurerm_synapse_spark_pool" "synapseSparkPool001" {
  name                 = "${var.name}-SparkPool001"
  synapse_workspace_id = azurerm_synapse_workspace.synapseBatch001.id
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"

  auto_scale {
    max_node_count = 10
    min_node_count = 3
  }

  auto_pause {
    delay_in_minutes = 15
  }

  tags = var.tags
  depends_on = [
    azurerm_synapse_workspace.synapseBatch001
  ]
}
