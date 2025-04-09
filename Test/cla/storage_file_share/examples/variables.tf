variable "tags" {
  type        = map(string)
  description = "Additional default tags to add to the resources being deployed at this layer."
  default     = {}
}

variable "resource_group_name" {
  description = "Name for this Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region to create the resource in"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of virtual network containing subnet to attach route table to"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for virtual network"
  type        = string
}

variable "subnets" {
  description = "(Required) Map of subnets to create with their configurations"
  type = map(object(
    {
      virtual_network_name                          = string                       # (Required) The name of the Virtual Network where the subnet should be created.
      address_prefixes                              = list(string)                 # (Required) The address prefixes to use for the subnet.
      private_endpoint_network_policies             = optional(string, "Disabled") # (Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to `true` will **Enable** the policy and setting this to `false` will **Disable** the policy. Defaults to `false`.
      private_link_service_network_policies_enabled = optional(bool, false)        # (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to `true` will **Enable** the policy and setting this to `false` will **Disable** the policy. Defaults to `false`.
      service_endpoints                             = optional(set(string))        # (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage` and `Microsoft.Web`.
      service_endpoint_policy_ids                   = optional(set(string))        # (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.
      delegations = optional(list(
        object(
          {
            name = string # (Required) A name for this delegation.
            service_delegation = object({
              name    = string                 # (Required) The name of service to delegate to. Possible values include `Microsoft.ApiManagement/service`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/managedResolvers`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments` and `PaloAltoNetworks.Cloudngfw/firewalls`.
              actions = optional(list(string)) # (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action` and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.
            })
          }
        )
      ))
    }
  ))
}

variable "private_dns_zone_name" {
  description = "Resource ID of Private DNS Zone"
  type = string
}

variable "private_dns_zone_ids" {
  description = "Resource ID of Private DNS Zone"
  type = list(string)
}

variable "virtual_network_ids" {
  description = "Resource ID of Virtual Network"
  type = list(string)
}

variable "dnslinkname" {
  type = string
  description = "Name of resource linking Private DNS Zone and VNet"
}

variable "private_service_connection" {
  description = "Configuration for private endpoint"
  type = object({
    name                           = string
    private_connection_resource_id = string
    subresource_names              = list(string)
    is_manual_connection           = bool
  })
}