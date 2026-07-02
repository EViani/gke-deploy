# Infraestructura de GKE con Terraform
Este repositorio contiene los archivos necesarios para crear un cluster en GKE con Terraform
La creación del cluster se realiza en la rama `terraform`, mientras que la rama `main` contiene el código para crear y subir la imagen Docker a Google Container Registry y desplegarla en GKE.
Actions crean y eliminan el cluster en GKE, por lo que no es necesario tener un cluster creado para ejecutar las acciones de GitHub.

- Para almacenar el state se utiliza un bucket de GCS, por lo que es necesario crear un bucket en GCP antes de ejecutar Terraform. El nombre del bucket debe ser único a nivel global, por lo que se recomienda usar un nombre que incluya el ID del proyecto y un sufijo aleatorio.
- 
