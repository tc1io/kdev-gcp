variable "project_id" {
  description = "Project ID for the cluster setup"
  type        = string
}

variable "region" {
  description = "Target region for the cluster setup"
  type        = string
}

variable "name" {
  description = "Name of this cluster setup."
  type        = string
}

variable "cluster_master_authorized_networks_config" {
  type        = list(object({ cidr_blocks = list(object({ cidr_block = string, display_name = string })) }))
  description = "Allowed networks to access the Kubernetes master. It is a list of { cidr_block, display_name }."
  default = [
    {
      cidr_blocks = [
        #        {
        #          cidr_block   = "1.2.3.4/32"
        #          display_name = "Fred"
        #        },
      ]
    }
  ]
}

variable "number_of_nat_ips" {
  description = "If > 0 , a NAT gateway will be created for the cluster subnet with the number of specified IPs."
  type        = number
  default     = 1
}

variable "dns_zone_name" {
  description = "Name of the DNS zone for A-record creation"
  type        = string
}
variable "dns_domain" {
  description = "DNS base domain for A-record creation"
  type        = string
}
