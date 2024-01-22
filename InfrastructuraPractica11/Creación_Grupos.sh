#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
export AWS_PAGER=""

# Variables de configuración
source .env

# 1. Creamos el grupo de seguridad: FRONTEnD

aws ec2 create-security-group \
    --group-name "FRONTEND-sg" \
    --description "Reglas para el FRONTEND"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name "FRONTEND-sg" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTP
aws ec2 authorize-security-group-ingress \
    --group-name "FRONTEND-sg" \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTPS
aws ec2 authorize-security-group-ingress \
    --group-name "FRONTEND-sg" \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0

#---------------------------------------------------------------------

# 2. Creamos el grupo de seguridad: NFS-sg

aws ec2 create-security-group \
 --group-name "NFS-sg" \
 --description "Reglas para el NFS"

 # Creamos una regla para el NFS
aws ec2 authorize-security-group-ingress \
    --group-name "NFS-sg" \
    --protocol tcp \
    --port 2049 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name "NFS-sg" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

#---------------------------------------------------------------------

# 3. Creamos el grupo de seguridad: BACKEND-sg
aws ec2 create-security-group \
    --group-name "BACKEND-sg" \
    --description "Reglas para el backend"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name "BACKEND-sg" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso para MySQL
aws ec2 authorize-security-group-ingress \
    --group-name "BACKEND-sg" \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0

#---------------------------------------------------------------------
# 4. Creamos el grupo de seguridad: LOAD-BALANCER-sg

aws ec2 create-security-group \
    --group-name "LOAD_BALANCER-sg" \
    --description "Reglas para el LOAD-BALANCER"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name "LOAD_BALANCER-sg" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTP
aws ec2 authorize-security-group-ingress \
    --group-name "LOAD_BALANCER-sg" \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTPS
aws ec2 authorize-security-group-ingress \
    --group-name "LOAD_BALANCER-sg" \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0