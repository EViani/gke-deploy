# Infraestructura de GKE con Terraform
Este repositorio contiene los archivos necesarios para crear un cluster en GKE con Terraform

- Para almacenar el state se utiliza un bucket de GCS, por lo que es necesario crear un bucket en GCP antes de ejecutar Terraform. El nombre del bucket debe ser único a nivel global, por lo que se recomienda usar un nombre que incluya el ID del proyecto y un sufijo aleatorio.
