# Automatización_instancias_AWS-CLI

En esta práctica se busca automatizar el proceso de creación de grupos, instancias y creación y asociación de direcciones ip elásticas con las instancias.
Para ello estaremos haciendo uso de la utilidad **aws-cli**.

A continuación muestro la estructura de los scripts de automatización:

```
└── fase-02
    ├── infraestructure
    │   ├── 00-terminate_all_instances.sh
    │   ├── 01-delete_all_security_groups.sh
    │   ├── 02-delete_all_elastic_ips.sh
    │   ├── 03-create_security_groups.sh
    │   ├── 04-create_instances.sh
    │   └── 05-create_elastic_ip.sh
    └── software
        ├── conf
        │   ├── 000-default-frontend.conf
        │   └── 000-default-loadbalancer.conf
        ├── config.sh
        ├── install_backend.sh

```
