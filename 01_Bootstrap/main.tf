# Configuración del proveedor
provider "aws" {
  region = var.aws_region
}

# 1. Módulo S3 para el estado de Terraform
# Despliega un bucket S3 privado y versionado
module "s3_backend" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name
  tags   = var.tags
  
  # Forzar destrucción del terraform sin necesidad de tener que eliminar manualmente en AWS ¡presta atención,esto se hace de manera ordenada!
  # ej: eliminar primero el terraform de 02_Infraestructura para luego eliminar el terraform 01_Bootstrap (esto para no tener problemas al elminar el terraform 02)
  # Quitar el '#' si desea activar la destrucción forzosa
  # force_destroy = true

  # Requerimientos de seguridad 
  # Requerimientos de seguridad (Bloqueo de acceso público)
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  
  versioning = {
    enabled = true
  }
}

# 2. Tabla DynamoDB para el bloqueo de estado
resource "aws_dynamodb_table" "dynamodb_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" # Clave requerida por Terraform para el bloqueo

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}
