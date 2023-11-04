resource "aws_ssm_parameter" "vpc_id" {
  name= "/terraform/assign/vpc/my_vpc"
  type= "String"
  value= aws_vpc.my_vpc.id
}

