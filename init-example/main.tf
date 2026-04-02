module "local" {
  source = "./local"
}

resource "random_pet" "pookie" {
  length = 2
  prefix = "princess"
}

output "pet_name" {
  value = random_pet.pookie.id
}