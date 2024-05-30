variable "origin_domain_name" {
  description = "The DNS domain name of the S3 bucket or custom origin."
  type        = string
}

variable "origin_id" {
  description = "A unique identifier for the origin."
  type        = string
}

variable "default_root_object" {
  description = "The object that CloudFront returns when requests the root URL."
  type        = string
  default     = "index.html"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
