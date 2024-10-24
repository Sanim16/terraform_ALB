variable "vpc_name" {
  description = "The name of the vpc"
  default     = "dev-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "cidr block for the vpc"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "cidr block for the subnet"
  default     = "10.0.1.0/24"
}

variable "region" {
  default = "us-east-1"
}

variable "hosted_zone_id" {
  type        = string
  description = "The ID of the hosted zone to contain this record"
}
