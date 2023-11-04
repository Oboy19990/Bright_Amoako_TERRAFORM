output "aws_subnet" {
  value = aws_subnet.my_publicsubnet.id
}
output "aws_lb_target_group" {
  value = aws_lb_target_group.alb_target_group.arn

}
output "main" {
  value = aws_alb.main.dns_name
}

output "application_load_balancer_zone_id" {
  value = aws_alb.main.zone_id
}
output "aws_security_group" {
  value = aws_security_group.my-sgp
}
  
