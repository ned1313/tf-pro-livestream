data "terraform_remote_state" "pets" {
  backend = "s3"
  config = {
    bucket = "CHANGE_ME"
    region = "us-east-2"
    key    = "remote-state/prod/terraform.tfstate"
  }
}

output "pet_name" {
  value = data.terraform_remote_state.pets.outputs.pet_name
}