# Salidas para referenciar en el otro proyecto
output "s3_bucket_bpainemilla" {
  value = module.s3_backend.s3_bucket_id
}

output "dynamodb_table_bpainemilla" {
  value = aws_dynamodb_table.dynamodb_lock.name
}