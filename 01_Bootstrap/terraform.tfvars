# Ingrese aquí valores únicos para su backend
aws_region = "us-east-1"

# NOTA: El nombre del bucket S3 debe ser globalmente único.
bucket_name = "mi-tfstate-backend-bp3quesos-2025"

dynamodb_table_name = "mi-tfstate-lock-bp3quesos"

tags = {
  Project     = "Terraform-Backend"
  ManagedBy   = "Terraform"
}
