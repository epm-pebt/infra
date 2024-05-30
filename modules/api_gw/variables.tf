variable "name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "description" {
  description = "The description of the API Gateway"
  type        = string
}

variable "backend_url" {
  description = "The URL of the backend the API Gateway will proxy to"
  type        = string
}
