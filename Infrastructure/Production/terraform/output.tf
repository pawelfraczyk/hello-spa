output "AWS_custom_bucket_name" {
  value = aws_s3_bucket.custom_bucket.id
}
output "Ecr_repository_name" {
  value = aws_ecr_repository.ecr.repository_url
}