resource "aws_instance" "web1" {

    ami           = var.AMI["ubuntuserver"] # or use amazonlinux2 for concourse
    instance_type = "t2.micro"

    # Instance shutdown behaviour 
    # Remember to disable in production 
    instance_initiated_shutdown_behavior = "terminate"

    # VPC
    subnet_id = aws_subnet.prod-subnet-public-1.id

    # Security Group
    vpc_security_group_ids = [aws_security_group.ssh-allowed.id]

    # the Public SSH key
    key_name = aws_key_pair.virginia-region-key-pair.id

    # startup script
    # shuts down in one hour 
    user_data = file("./scripts/startup.sh")

    # shutdown by lambda function based on ttl
    # https://gist.github.com/ibrezm1/1550bf2389db47f7acceb17ca6e2dc8d
    # https://medium.com/@kaustubhin/stop-ec2-instances-automatically-with-aws-lambda-function-python-98f801e77242?p=7dcee216308
    tags = {
        ttl = "120"
    }

    #move scripts folder to ec2 tmp
    provisioner "file" {
        source = "./scripts"
        destination = "/tmp"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/scripts/*.sh",
           # "sudo /tmp/scripts/install-docker.sh",
           # "sudo /tmp/scripts/install-concorse.sh",
            "sudo /tmp/scripts/install-slackstorm.sh",
        ]
    }

    connection {
        host = self.public_ip
        user = var.EC2_USER
        private_key = file(var.PRIVATE_KEY_PATH)
    }
}

resource "aws_key_pair" "virginia-region-key-pair" {
    key_name = "virginia-region-key-pair"
    public_key = file(var.PUBLIC_KEY_PATH)
}

data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web1.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web1.public_ip
}
