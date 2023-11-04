variable "instance_name" {
  default = "myec2"
}
variable "aws_region" {
  default = "us-east-1"
}
variable "aws_vpc" {
  default = "aws_vpc.id"
}



variable "aws_lb_listener" {
  default = "project"
}
variable "aws_security_group" {
  default = "my-sgp"

}