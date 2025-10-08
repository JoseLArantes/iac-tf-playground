variable "bucket_name" {
  description = "S34 bucket name"
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}
variable "environment" {
  description = "Environment name (dev, principal)"
  type        = string
  default     = ""
}
