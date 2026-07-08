# Infraestructura de GKE con Terraform
Este repositorio contiene los archivos necesarios para crear un cluster en GKE con Terraform
La creación del cluster se realiza en la rama `terraform`, mientras que la rama `main` contiene el código para crear y subir la imagen Docker a Google Container Registry y desplegarla en GKE.
Actions crean y eliminan el cluster en GKE, por lo que no es necesario tener un cluster creado para ejecutar las acciones de GitHub.

- Para almacenar el state se utiliza un bucket de GCS, por lo que es necesario crear un bucket en GCP antes de ejecutar Terraform. El nombre del bucket debe ser único a nivel global, por lo que se recomienda usar un nombre que incluya el ID del proyecto y un sufijo aleatorio. Para ello ejecutamos el siguiente comando:
~~~ bash
cd bucket
cp terraform.tfvars.example terraform.tfvars
# Complete con sus datos
# Recordar anotar el nombre del bucket creado, ya que será necesario para configurar el backend de Terraform. Dentro de la variable GPC_BUCKET_NAME, colocar el nombre del bucket creado.
tofu init
tofu plan
tofu apply
~~~

El action creara el cluster en GKE y los recursos necesarios para el despliegue de la imagen, por lo que no es necesario ejecutar `tofu apply` para crear el cluster, solo es necesario ejecutar `tofu apply` para crear el bucket de GCS. Y hacer un push en el directorio `infra/gke` para que el action cree el cluster en GKE y los recursos necesarios para el despliegue de la imagen.

No olvide los secrets necesarios:
- `GCP_PROJECT_ID`: ID del proyecto de GCP
- `GCP_BUCKET_ID:` Nombre del bucket de GCS creado para almacenar el state de Terraform
- `GCP_SERVICE_ACCOUNT`: Cuenta creada con los permisos WIF
- `GCP_WORKLOAD_IDENTITY_PROVIDER`: Nombre del proveedor de identidad de Workload Identity creado en GCP

## Destroy cluster
Para eliminar el cluster en GKE y los recursos necesarios para el despliegue de la imagen
Con Actions
~~~ bash
date > destroy/date.txt
git add destroy/date.txt
git commit -m "Destroy cluster"
git push 
~~~
Manualmente, ya que el state esta en GCS
~~~ bash
cd gke
tofu destroy -auto-approve
~~~

Eliminar el bucket de GCS creado para almacenar el state de Terraform, ya que este no es eliminado por el action.
~~~ bash
cd bucket
tofu destroy -auto-approve
~~~