# gke-deploy
Pasos para crear un cluster en GKE con Terraform, creación y subida de imagen Docker a Google Container Registry y despliegue de la imagen en GKE.

## Requisitos
- Cuenta en [Google Cloud Platform](https://cloud.google.com/)
  - Con proyecto y billing habilitado
  - APIs habilitadas:
    - Kubernetes Engine API
    - Cloud Resource Manager API
- CLI [gcloud](https://cloud.google.com/sdk/docs/install)
- Terraform instalado | [Opentofu](https://opentofu.org/)
- [Docker](https://www.docker.com/get-docker) instalado

## Ramas
- `main`: Rama principal, contiene el código estable y funcional. Crea y sube las imagenes
- `terraform`: Rama para desplegar el cluster en GKE y los recursos necesarios para el despliegue de la imagen.

## Configuración
### Login
#### GCP
##### Una sola conficuración
```bash
# Login a GCP
gcloud auth login
gcloud config set project [ID_DEL_PROYECTO]

```
##### Varias configuraciones
Si deseamos almacenar varias configuraciones de GCP, podemos crear un alias para cada proyecto y así poder cambiar entre ellos fácilmente.
```bash
# Crea una nueva configuration y cambia a esta
gcloud config configurations create [NOMBRE_CONFIGURACION]

gcloud auth login

gcloud config set project [ID_DEL_PROYECTO]

gcloud config configurations list
#cambiar entre configutarions
gcloud config configurations activate [NOMBRE_CONFIGURACION]
```

#### Terraform
~~~ bash
# Login to aplicación (para Terraform)
# Este comando sobre escribe el applicaction-default, por lo que si tenemos varias configuraciones de GCP, debemos cambiar a la configuración deseada antes de ejecutar este comando. 
gcloud auth application-default login
gcloud auth application-default set-quota-project <TU_PROJECT_ID>
~~~

### Workload Identity Federation (WIF) 
Crear service account, y WIF para Terraform, para que pueda desplegar en GCP desde GitHub Actions sin necesidad de almacenar credenciales en el repositorio. [Workload Identity Federation](./WIF/README.md)

### Infraestructura de GKE con Terraform
Pasar a rama `terraform` y ejecutar los siguientes comandos para crear el cluster en GKE y los recursos necesarios para el despliegue de la imagen. [Infraestructura de GKE con Terraform](./infra/README.md)
~~~ bash
git switch terraform
# Comprendase el uso de terraform o tofu como el mismo comando, ya que Opentofu es un fork de Terraform.
~~~