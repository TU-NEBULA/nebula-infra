output "security_group_id" {
  value = aws_security_group.fastapi_sg.id  
}

output "fastapi_sg_id" {
  value = aws_security_group.fastapi_sg.id
}

output "springboot_sg_id" {
  value = aws_security_group.springboot_sg.id
}
