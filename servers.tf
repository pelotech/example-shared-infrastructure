# A look up for rancheros_ami by region
variable "rancheros_amis" {
  default = {
      "ap-south-1" = "ami-3576085a"
      "eu-west-2" = "ami-4806102c"
      "eu-west-1" = "ami-64b2a802"
      "ap-northeast-2" = "ami-9d03dcf3"
      "ap-northeast-1" = "ami-8bb1a7ec"
      "sa-east-1" = "ami-ae1b71c2"
      "ca-central-1" = "ami-4fa7182b"
      "ap-southeast-1" = "ami-4f921c2c"
      "ap-southeast-2" = "ami-d64c5fb5"
      "eu-central-1" = "ami-8c52f4e3"
      "us-east-1" = "ami-067c4a10"
      "us-east-2" = "ami-b74b6ad2"
      "us-west-1" = "ami-04351964"
      "us-west-2" = "ami-bed0c7c7"
  }
  type = "map"
}

# this creates a cloud-init script that registers the server
# as a rancher agent when it starts up
resource "template_file" "user_data" {
  template = <<EOF
#cloud-config
write_files:
  - path: /etc/rc.local
    permissions: "0755"
    owner: root
    content: |
      #!/bin/bash
      for i in {1..60}
      do
      docker info && break
      sleep 1
      done
      sudo docker run -d  --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.1 $${registration_url}
EOF

  vars {
    registration_url = "${rancher_registration_token.production_token.registration_url}"
  }
}


# AWS ec2 launch configuration for a production rancher agent
resource "aws_launch_configuration" "launch_configuration" {
  provider = "aws"
  name = "rancher agent"
  image_id = "${lookup(var.rancheros_amis, var.terraform_user_region)}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  user_data = "${template_file.user_data.rendered}"

  security_groups = [ "${var.security_group_id}"]
  associate_public_ip_address = true
}

# Creates an autoscaling group of 1 server that will be a rancher agent
resource "aws_autoscaling_group" "autoscaling" {
  availability_zones        = ["${var.availability_zones}"]
  name                      = "Production servers"
  max_size                  = "1"
  min_size                  = "1"
  health_check_grace_period = 3600
  health_check_type         = "ELB"
  desired_capacity          = "1"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.launch_configuration.name}"
  vpc_zone_identifier       = ["${var.subnets}"]
}