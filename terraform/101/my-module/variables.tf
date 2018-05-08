variable "access_key" {
  type = "string"

  description = "AWS access key"
}

variable "secret_key" {
  type = "string"

  description = "AWS secret key"
}

variable "identity" {
  type = "string"

  description = "User identity"
}

variable "region" {
  type = "string"

  description = "AWS region"

  default = "us-east-1"
}

variable "images" {
  type = "map"

  description = "AMIs for each region"

  default = {
    us-east-1 = "image-1234"
    us-west-2 = "image-5678"
  }
}

variable "zones" {
  type = "list"

  description = "List of AWS zones"

  default = ["us-east-1a", "us-east-1b"]
}

variable "label" {
  type = "string"

  description = "resource label"

  default = "training"
}

variable "num_webs" {
  type = "string"

  description = "Number of web instances"

  default = "2"
}
