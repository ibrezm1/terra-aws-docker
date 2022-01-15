provider "aws" {
 default_tags {
   tags = {
     environment = "test"
     Owner       = "TFProviders"
     Project     = "Test"
   }
 }
    region = var.AWS_REGION
}