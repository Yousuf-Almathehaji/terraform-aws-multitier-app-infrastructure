variable "region" {
  default = "us-east-1"
}
variable "availability_zones" {
  type = list
  default = ["us-east-1a","us-east-1c"]
}
variable "instance-ami" {
  type = string
  default = "ami-0332d564d76dbd8d6"
}
variable "type-instance" {
  type = string
  default = "t3.micro"
}
# variable "ids" {
#   default = [
#   ]
# }
locals {
  prvnet-ids=[
  aws_subnet.private1.id,
  aws_subnet.private2.id
  ]
}
locals {
  dbnet-ids=[
    aws_subnet.db-private1.id,
    aws_subnet.db-private2.id
  ]
}
locals {
  pubnet-ids=[
  aws_subnet.public1.id,
  aws_subnet.public2.id
  ]
}

variable "db-username" {
  type = string
  default = "admin"
}
variable "db-password" {
  
}