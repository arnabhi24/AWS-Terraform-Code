terraform {
  backend "s3" {
    bucket         = "my-terraform-states-test-ecs"
    key            = "ecs/infra/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
