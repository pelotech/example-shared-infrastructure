variable "terraform_user_access_key" {}
variable "terraform_user_secret_key" {}
variable "terraform_user_region" {}
variable "rancher_url" {}
variable "subnets" { type = "list" }
variable "availability_zones" { type="list"}
variable "key_name" {}
variable "security_group_id" {}
