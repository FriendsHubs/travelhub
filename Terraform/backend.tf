terraform {
  backend "s3" {
    bucket         = "friendshub-terraform-backend"
    key            = "friendshub/statefile"
    region         = "eu-west-3"
    dynamodb_table = "friendshub-state-lock-table"

  }
}