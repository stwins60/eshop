resource "aws_ecr_repository" "eshop-repo" {
  name                 = "eshop-repository"
  image_tag_mutability = "IMMUTABLE"
}


