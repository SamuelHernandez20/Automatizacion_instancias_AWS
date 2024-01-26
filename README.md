# Automatización_instancias_AWS-CLI

En esta práctica se busca automatizar el proceso de creación de grupos, instancias y creación y asociación de direcciones ip elásticas con las instancias.
Para ello estaremos haciendo uso de la utilidad **aws-cli**.

A continuación muestro la estructura de los scripts de automatización:

 # Estructura de Directorios:

```
    ├── InfraestructuraPráctica11
    │   ├── .env
    │   ├── Creacion_instancias.sh
    │   ├── Creación_Grupos.sh
    │   ├── Direcciones_elasticas.sh

```
 ## 1. Creación de los grupos de seguridad:

Deshabilitamos la paginación de la salida de los comandos de AWS CLI

```
export AWS_PAGER=""
```
# Variables de configuración
source .env

# 1. Creamos el grupo de seguridad: LOAD_BALANCER

aws ec2 create-security-group \
    --group-name "LOADBALANCER-sg" \
    --description "Reglas para el Balanceador"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name "LOADBALANCER-sg" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTP
aws ec2 authorize-security-group-ingress \
    --group-name "LOADBALANCER-sg" \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTPS
aws ec2 authorize-security-group-ingress \
    --group-name "LOADBALANCER-sg" \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0



# 2. Creamos el grupo de seguridad: FRONTEND

aws ec2 create-security-group \
    --group-name "FRONTEND-sg" \
    --description "Reglas para el Frontend"

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

# 3. Creamos el grupo de seguridad: NFS-sg

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



# 4. Creamos el grupo de seguridad: BACKEND-sg
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


 
