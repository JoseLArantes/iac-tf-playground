# IAM Roles Module Variables

variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = ""
}

variable "assume_role_policy" {
  description = "JSON string of the assume role policy document"
  type        = string
}

variable "managed_policy_arns" {
  description = "List of ARNs of managed policies to attach to the role"
  type        = list(string)
  default     = []
}

variable "custom_policy_json" {
  description = "JSON string of a custom inline policy to attach to the role"
  type        = string
  default     = ""
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile for this role"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the IAM resources"
  type        = map(string)
  default     = {}
}

