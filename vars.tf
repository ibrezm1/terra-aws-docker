variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PRIVATE_KEY_PATH" {
  default = "virginia-region-key-pair"
}

variable "PUBLIC_KEY_PATH" {
  default = "virginia-region-key-pair.pub"
}

variable "EC2_USER" {
  # need to change to the user in case of ubuntu user = "ubuntu"
  #default = "ec2-user" 
  default = "ubuntu" 
}
variable "AMI" {
    # Zone dependent AMI id collection from launch instances
    #ami           = "ami-0ed9277fb7eb570c9" # AMI - Amazon Linux 2
    #ami           = "ami-04505e74c0741db8d" # AMI - Ubuntu Server 20.04 LTS 
    # remember to change the user when changing AMI - else instance will not connect
  type = map

  default =  {
    amazonlinux2 = "ami-0ed9277fb7eb570c9"
    ubuntuserver = "ami-04505e74c0741db8d"
    redhat8 = "ami-0b0af3577fe5e3532"
  }
}