#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
export AWS_PAGER=""

# Variables de configuración
source .env

# Obtenemos el Id de la instancia a partir de su nombre
INSTANCE_ID_FRONTEND_1=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_FRONTEND_1" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

INSTANCE_ID_FRONTEND_2=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_FRONTEND_2" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

INSTANCE_ID_BACKEND=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_BACKEND" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

INSTANCE_ID_BACKEND=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_LOAD_BALANCER" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

INSTANCE_ID_NFS=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_LOAD_BALANCER" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)


# Creamos las direcciones IP elásticas:
ELASTIC_IP_FRONTEND_1=$(aws ec2 allocate-address --query PublicIp --output text)
ELASTIC_IP_FRONTEND_2=$(aws ec2 allocate-address --query PublicIp --output text)
ELASTIC_IP_BACKEND=$(aws ec2 allocate-address --query PublicIp --output text)
ELASTIC_IP_BALANCER=$(aws ec2 allocate-address --query PublicIp --output text)
ELASTIC_IP_NFS=$(aws ec2 allocate-address --query PublicIp --output text)

# Asociamos la ip's elasticas a cada una de las instancias:

aws ec2 associate-address --instance-id $INSTANCE_ID --public-ip $ELASTIC_IP_FRONTEND_1
aws ec2 associate-address --instance-id $INSTANCE_ID --public-ip $ELASTIC_IP_FRONTEND_2
aws ec2 associate-address --instance-id $INSTANCE_ID --public-ip $ELASTIC_IP_BACKEND
aws ec2 associate-address --instance-id $INSTANCE_ID --public-ip $ELASTIC_IP_BALANCER
aws ec2 associate-address --instance-id $INSTANCE_ID --public-ip $ELASTIC_IP_NFS