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
> [!IMPORTANT]
> Para intercatuar con el GKE ejecutar el comando `gcloud container clusters get-credentials <NOMBRE_CLUSTER> --region <REGION> --project <ID_PROYECTO>` para obtener las credenciales del cluster y poder interactuar con el cluster desde la CLI de kubectl.

### [Argocd](https://argo-cd.readthedocs.io/en/stable/) 
Para automatizar el despliegue de la imagen en GKE, se utiliza ArgosCD, para ello se debe crear un cluster en GKE y desplegar ArgosCD en el cluster. 

Instalar argocd para [CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation)

#### Intalar Argocd en el cluster 
Creamos el namespace
~~~ bash
kubectl create namespace argocd
~~~
Aplicamos el manifiesto, con los flags
~~~ bash
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
~~~
Una vez instalado forwardeamos el puerto
~~~ bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
~~~
#### Acceder a Argocd
Obtenemos el password
~~~ bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
~~~
Copiamos la salida, esta debemos usarla para configurar el argocd

Nos logueamos en CLI
~~~ bash
argocd login localhost:8080 --username admin --password CLAVE --insecure
~~~
Podemos acceder al GUI via [http://localhost8080](http://localhost8080) o con el puerto que definimos con el user `admin` y las password anterior

Via CLI agregamos el o los repositorio
~~~ bash
argocd app create NAME_APP --repo REPO_URL.git --path PATH_K8 --dest-server https://kubernetes.default.svc --dest-namespace default --sync-policy automated --revision BRANCH
~~~
