output "security_group_id" {
  value = aws_security_group.fastapi_sg.id  
}

output "ssh_sg_id" {
  value = aws_security_group.ssh_sg.id
}

output "fastapi_sg_id" {
  value = aws_security_group.fastapi_sg.id
}

output "celery_sg_id" {
  value = aws_security_group.celery_sg.id
}

output "chroma_sg_id" {
  value = aws_security_group.chroma_sg.id
}

output "springboot_sg_id" {
  value = aws_security_group.springboot_sg.id
}

