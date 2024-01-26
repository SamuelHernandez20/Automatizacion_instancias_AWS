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
### Creamos el grupo de seguridad: **LOAD_BALANCER**:

```
aws ec2 create-security-group \
    --group-name "LOADBALANCER-sg" \
    --description "Reglas para el Balanceador"
```

Creamos una regla de accesso **SSH**:
```
aws ec2 authorize-security-group-ingress \
    --group-name "LOADBALANCER-sg" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0
```
Creamos una regla de accesso **HTTP**:
```
aws ec2 authorize-security-group-ingress \
    --group-name "LOADBALANCER-sg" \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0
```
Creamos una regla de accesso **HTTPS**:

```
aws ec2 authorize-security-group-ingress \
    --group-name "LOADBALANCER-sg" \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0
```

### Creamos el grupo de seguridad: **FRONTEND**:

```
aws ec2 create-security-group \
    --group-name "FRONTEND-sg" \
    --description "Reglas para el Frontend"
```

Creamos una regla de accesso **SSH**:
```
aws ec2 authorize-security-group-ingress \
    --group-name "FRONTEND-sg" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0
```

Creamos una regla de accesso **HTTP**:

```
aws ec2 authorize-security-group-ingress \
    --group-name "FRONTEND-sg" \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0
```
### Creamos el grupo de seguridad: **NFS-sg**:

```
aws ec2 create-security-group \
 --group-name "NFS-sg" \
 --description "Reglas para el NFS"
```
Creamos una regla para el **NFS**:

```
aws ec2 authorize-security-group-ingress \
    --group-name "NFS-sg" \
    --protocol tcp \
    --port 2049 \
    --cidr 0.0.0.0/0

```
Creamos una regla de accesso **SSH**:

```
aws ec2 authorize-security-group-ingress \
    --group-name "NFS-sg" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

```
### Creamos el grupo de seguridad: **BACKEND-sg**

```
aws ec2 create-security-group \
    --group-name "BACKEND-sg" \
    --description "Reglas para el backend"
```
Creamos una regla de accesso **SSH**:

```
aws ec2 authorize-security-group-ingress \
    --group-name "BACKEND-sg" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0
```
Creamos una regla de accesso para **MySQL**:

```
aws ec2 authorize-security-group-ingress \
    --group-name "BACKEND-sg" \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0
```
 ## 2. Creación de las instancias:

 A continuación la creación automatizada de las instancias que voy a proceder a crear son las siguientes:
 
```
--------------------------------------------------------------------------------------------------->
Creación de las siguientes instancias:

 - Balanceador.
 - Frontal Web 1.
 - Frontal Web 2.
 - Servidor NFS.
 - Servidor de Base de Datos MySQL.
--------------------------------------------------------------------------------------------------->
```

Creamos una intancia EC2 para el **frontend 1**:

```
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $GRUPO_FRONTEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_FRONTEND_1}]" 
```

Creamos una intancia EC2 para el **frontend 2**:

```
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $GRUPO_FRONTEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_FRONTEND_2}]"
```

Creamos una intancia EC2 para el **backend**:

```
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $GRUPO_BACKEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_BACKEND}]"
```

Creamos una intancia EC2 para el **NFS**:

```
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $GRUPO_NFS \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_NFS}]"
```
Creamos una intancia EC2 para el **Balanceador**:

```
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $GRUPO_LOAD_BALANCER \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_LOAD_BALANCER}]" 
```

 ## 3. Creación de las direcciones ip elásticas:

Obtenemos el **ID** de las instancias a partir de su **nombre** para luego poder realizar la asociación con las **direcciones ip elásticas**:

```
INSTANCE_ID_FRONTEND_1=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_FRONTEND_1" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)
```

```
INSTANCE_ID_FRONTEND_2=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_FRONTEND_2" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)
```

```
INSTANCE_ID_BACKEND=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_BACKEND" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)
```

```
INSTANCE_ID_BACKEND=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_LOAD_BALANCER" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)
```

```
INSTANCE_ID_NFS=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_LOAD_BALANCER" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)
```

Creamos las **direcciones IP elásticas** para las instancias:

```
ELASTIC_IP_FRONTEND_1=$(aws ec2 allocate-address --query PublicIp --output text)
```
```
ELASTIC_IP_FRONTEND_2=$(aws ec2 allocate-address --query PublicIp --output text)
```
```
ELASTIC_IP_BACKEND=$(aws ec2 allocate-address --query PublicIp --output text)
```
```
ELASTIC_IP_BALANCER=$(aws ec2 allocate-address --query PublicIp --output text)
```
```
ELASTIC_IP_NFS=$(aws ec2 allocate-address --query PublicIp --output text)
```

**Asociamos** las **ip's elasticas** a cada una de las **instancias**:
```
aws ec2 associate-address --instance-id $INSTANCE_ID_FRONTEND_1 --public-ip $ELASTIC_IP_FRONTEND_1
```
```
aws ec2 associate-address --instance-id $INSTANCE_ID_FRONTEND_2 --public-ip $ELASTIC_IP_FRONTEND_2
```
```
aws ec2 associate-address --instance-id $INSTANCE_ID_BACKEND --public-ip $ELASTIC_IP_BACKEND
```
```
aws ec2 associate-address --instance-id $INSTANCE_ID_BALANCER --public-ip $ELASTIC_IP_BALANCER
```
```
aws ec2 associate-address --instance-id $INSTANCE_ID_NFS --public-ip $ELASTIC_IP_NFS
```




 
