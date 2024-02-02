variable "name" {
  description = "Load balancer name"
  nullable    = false
  type        = string
}

variable "vpc" {
  type = object({
    id                 = string
    public_subnet_ids  = list(string)
    private_subnet_ids = list(string)
  })
  nullable    = false
  description = "Load balancer VPC for subnet info"
}

variable "default_certificate_arn" {
  type        = string
  nullable    = false
  description = "Certificate ARN for HTTPS traffic"
}

variable "manage_security_group_rules" {
  type        = bool
  default     = true
  nullable    = false
  description = "(Optional) Restrict inbound http & https traffic. Skips adding security_group_rules for http & https"
}

variable "private" {
  type        = bool
  nullable    = false
  default     = false
  description = "Deploy the load balancer on private VPC subnets (implies internal)"
}

variable "internal" {
  type        = bool
  nullable    = false
  default     = false
  description = "Creates an internal-only load balancer (implied if private)"
}

variable "logging" {
  type = object({
    bucket = string
  })
  default     = null
  description = "Enable load balancer logging to S3"
}

variable "blocked_paths" {
  type = list(string)
  default = [
    "*.php"
  ]
  nullable = false
}

variable "blocked_priority" {
  type     = number
  default  = 20
  nullable = false
}
