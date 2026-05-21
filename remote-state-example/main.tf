resource "random_pet" "pookie" {
  length = 3
  prefix = "princess"
}

output "pet_name" {
  value = random_pet.pookie.id
}