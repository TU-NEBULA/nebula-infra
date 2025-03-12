output "fastapi_eip" {
  value = aws_eip.fastapi_eip.public_ip
}

output "celery_eip" {
  value = aws_eip.celery_eip.public_ip
}

output "chroma_eip" {
  value = aws_eip.chroma_eip.public_ip
}