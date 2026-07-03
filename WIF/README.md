#  Workload Identity Federation (WIF) para GitHub Actions
Para permitir que GitHub Actions pueda desplegar en GCP sin necesidad de almacenar credenciales en el repositorio, podemos usar Workload Identity Federation (WIF). Para ello, debemos crear un Pool de Identidad de Trabajo y un Proveedor de Identidad dentro del Pool. Luego, debemos permitir que el repositorio de GitHub asuma la Cuenta de Servicio dedicada a Terraform.

# Crear service account para Terraform
Creamos una service account dedicada a Terraform, que será la que se utilizará para desplegar en GCP desde GitHub Actions. Esta cuenta de servicio tendrá los permisos necesarios para crear y administrar recursos en GCP.
Utilizaremos Terraform para crear la service account y asignarle los permisos necesarios. Para ello, debemos crear un archivo `main.tf` con el siguiente contenido:
~~~ bash
# Comprendase el uso de terraform o tofu como el mismo comando, ya que Opentofu es un fork de Terraform.
cp terraform.tfvars.example terraform.tfvars
# Complete con sus datos
tofu init

tofu plan

# Para aplicar los cambios y crear la service account, debemos ejecutar el siguiente comando:
# Debe aprobar los cambios antes de aplicar, por lo que debemos ejecutar el comando `tofu plan` antes de `tofu apply`.
tofu apply
# Si desea que se ejecute sin necesidad de aprobar los cambios, puede usar el flag `-auto-approve`:
tofu apply -auto-approve
~~~

### Workload Identity Federation(WIF)

Para permitir que GitHub Actions pueda desplegar en GCP sin necesidad de almacenar credenciales en el repositorio, podemos usar Workload Identity Federation (WIF). Para ello, debemos crear un Pool de Identidad de Trabajo y un Proveedor de Identidad dentro del Pool. Luego, debemos permitir que el repositorio de GitHub asuma la Cuenta de Servicio dedicada a Terraform.
> [!IMPORTANT]
> Reemplazar `TU_PROJECT_ID`, `SERVICE_ACCOUNT_ID`, `NUMER_FROM_STEP_2`, `REPO_OWNER` y `REPO_NAME` con los datos correspondientes a su proyecto y repositorio de GitHub. El `SERVICE_ACCOUNT_ID` es el ID de la cuenta de servicio creada para Terraform, y `NUMER_FROM_STEP_2` es el número de proyecto obtenido en el paso 2. `REPO_OWNER` es el nombre del usuario o la organización de GitHub, y `REPO_NAME` es el nombre del repositorio donde se ejecutarán las acciones de GitHub.


~~~ bash
# 1. Crear el Pool de Identidad de Trabajo
gcloud iam workload-identity-pools create "github-actions-pool" \
    --project="TU_PROJECT_ID" \
    --location="global" \
    --display-name="GitHub Actions Pool"

# 2. Obtener el número de proyecto (necesario para el Provider string)
gcloud projects describe "TU_PROJECT_ID" --format="value(projectNumber)"

# 3. Crear el Proveedor de Identidad dentro del Pool
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
    --project="TU_PROJECT_ID" \
    --location="global" \
    --workload-identity-pool="github-actions-pool" \
    --display-name="GitHub Provider" \
    --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
    --attribute-condition="assertion.repository == 'REPO_OWNER/REPO_NAME'" \
    --issuer-uri="https://token.actions.githubusercontent.com"

# 4. Permitir que el repositorio de GitHub asuma la Cuenta de Servicio dedicada a Terraform
# Reemplazar REPO_OWNER/REPO_NAME con los datos de GitHub
gcloud iam service-accounts add-iam-policy-binding "SERVICE_ACCOUNT_ID@TU_PROJECT_ID.iam.gserviceaccount.com" \
    --project="TU_PROJECT_ID" \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/projects/NUMER_FROM_STEP_2/locations/global/workloadIdentityPools/github-actions-pool/attribute.repository/REPO_OWNER/REPO_NAME"
~~~


> Tomar nota para los secrets necesarios para GitHub Actions:
>  GCP_PROJECT_ID: ID del proyecto de GCP
> GCP_WORKLOAD_IDENTITY_PROVIDER: projects/NUMER_FROM_STEP_2/locations/global/workloadIdentityPools/github-actions-pool/providers/github-provider
> GCP_SERVICE_ACCOUNT: SERVICE_ACCOUNT_ID@GCP_PROJECT_ID.iam.gserviceaccount.com