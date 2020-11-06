terraform {
  backend "s3" {
    bucket         = "danieltefera08-plinth-testing"
    key            = "test-environment"
    region         = "us-east-1"
    dynamodb_table = "terraform_locks"
  }
}
