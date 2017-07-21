provider "aws" {
	access_key = "${var.terraform_user_access_key}"
	secret_key = "${var.terraform_user_secret_key}"
	region     = "${var.terraform_user_region}"
}
