# 🧀 The Cheese Factory | AWS Infrastructure

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Status](https://img.shields.io/badge/status-stable-green?style=for-the-badge)

> **Infraestructura como Código (IaC)** para el despliegue automatizado, seguro y escalable de la aplicación distribuida "The Cheese Factory".

## 📋 Descripción del Proyecto

Este repositorio contiene la definición declarativa de la infraestructura necesaria para ejecutar la aplicación web "The Cheese Factory" en Amazon Web Services (AWS).

El proyecto demuestra competencias avanzadas en **DevOps**, implementando una arquitectura de 3 capas, gestión de estado remoto con bloqueo (State Locking), y principios de seguridad de **Mínimo Privilegio**.

### 🏗️ Arquitectura de Alto Nivel

El tráfico fluye desde internet hacia un balanceador de carga público, el cual distribuye las peticiones hacia contenedores aislados en redes privadas.

```mermaid
graph TD
    User((Internet)) --> ALB[Application Load Balancer]
    subgraph VPC [VPC Personalizada]
        subgraph Public_Subnets [Subredes Públicas]
            ALB
        end
        subgraph Private_Subnets [Subredes Privadas]
            EC2_1[EC2 Container A]
            EC2_2[EC2 Container B]
            EC2_3[EC2 Container C]
        end
    end
    ALB --> EC2_1
    ALB --> EC2_2
    ALB --> EC2_3
    Terraform -->|State Lock| DynamoDB
    Terraform -->|State Storage| S3_Bucket

🚀 Características Técnicas
Este despliegue cumple con estándares de industria:
'
CaracterísticaImplementaciónRed SeguraVPC Personalizada con separación estricta entre subredes Públicas (ALB) y Privadas (App).Alta DisponibilidadDistribución en 3 Zonas de Disponibilidad (AZs) con Load Balancing automático.Gestión de EstadoBackend remoto en S3 con bloqueo de concurrencia vía DynamoDB (evita corrupción de estado).Seguridad (SG)ALB: Solo puerto 80 desde 0.0.0.0/0.  EC2: Solo tráfico HTTP proveniente del Security Group del ALB.ModularidadUso de módulos oficiales verificados (terraform-aws-modules).Lógica CondicionalAdaptabilidad de entorno: prod (t3.small) vs dev (t2.micro).📂 Estructura del RepositorioEl proyecto sigue una estrategia de Monorepo dividido por ciclo de vida:Bash.
├── 01_Bootstrap/          # [Fase 1] Infraestructura para el Backend (S3 + DynamoDB)
│   ├── main.tf
│   └── ...
├── 02_Infraestructura/    # [Fase 2] Infraestructura Principal (VPC, ALB, EC2)
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars   # (No versionado, ver .example)
│   └── ...
└── README.md
🛠️ Requisitos PreviosEste proyecto ha sido desarrollado y validado en el siguiente entorno:SO: Ubuntu 22.04 LTS / 24.04 LTS (VMware Workstation)Terraform CLI: >= 1.5.0AWS CLI: Configurado con credenciales válidas (aws configure)⚙️ Configuración (Variables)El comportamiento de la infraestructura se controla mediante terraform.tfvars. Copia el archivo de ejemplo para comenzar:Bashcp 02_Infraestructura/terraform.tfvars.example 02_Infraestructura/terraform.tfvars
Tabla de Variables PrincipalesVariableDescripciónValor Ejemploaws_regionRegión de despliegue AWSus-east-1environmentDefine el tier (dev o prod)devinstance_type(Opcional) Sobrescribe el tipo de instanciat2.micromy_ipTu IP pública para administración SSH190.x.x.x/32docker_imagesLista de imágenes a desplegar["errm/cheese:cheddar", ...]⚡ Guía de DespliegueSigue este orden estricto para levantar la infraestructura correctamente.Fase 1: Bootstrap (Backend S3)Primero debemos crear el lugar donde Terraform guardará su memoria.Bashcd 01_Bootstrap
terraform init
terraform apply -auto-approve
Nota: Al finalizar, toma nota del nombre del bucket y la tabla DynamoDB generados. Deberás configurarlos en el backend.tf de la siguiente fase si no están automatizados.Fase 2: Infraestructura Principal (The Cheese Factory)Despliegue de la red y la aplicación.Bashcd ../02_Infraestructura

# 1. Inicializar (descarga módulos y conecta con S3)
terraform init

# 2. Planificar (Previsualización de cambios)
terraform plan

# 3. Aplicar (Despliegue real en AWS)
terraform apply -auto-approve
✅ Verificación y PruebasUna vez finalizado el apply, Terraform mostrará un output llamado resumen_final o alb_dns_name.Copia el DNS del Load Balancer (ej. cheese-lb-12345.us-east-1.elb.amazonaws.com).Pégalo en tu navegador.Refresca la página varias veces (F5): Deberás ver cómo el Load Balancer alterna entre los diferentes tipos de quesos (contenedores) servidos por las distintas instancias.🗑️ Destrucción de RecursosPara evitar costos en AWS, destruye la infraestructura en orden inverso:Bash# 1. Destruir Aplicación
cd 02_Infraestructura
terraform destroy -auto-approve

# 2. Destruir Backend (Opcional, si quieres borrar el bucket)
cd ../01_Bootstrap
# Nota: El bucket debe estar vacío antes de borrarlo
terraform destroy -auto-approve
Desarrollado por: [Tu Nombre/Usuario] | Duoc UC
