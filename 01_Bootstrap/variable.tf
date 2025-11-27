variable "aws_region" {
  description = "Región de AWS para desplegar el backend."
  type        = string
}

variable "bucket_name" {
  description = "Nombre globalmente único para el bucket S3."
  type        = string
}

variable "dynamodb_table_name" {
  description = "Nombre para la tabla DynamoDB de bloqueo."
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes para los recursos."
  type        = map(string)
  default     = {}
}
