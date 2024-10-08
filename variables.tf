variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "common_tags" {
  type = map(any)
  default = {
    Project   = "legendary-octo-journey"
    ManagedBy = "terraform"
    env       = "dev"
  }
}

variable "trusted_bucket_writers" {
  type    = list(string)
  default = ["01234567890"]
}
