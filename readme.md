# cloud-run-nodejs-template

> A template for deploying Node.js applications on Google Cloud Run with Terraform.

## Prerequisites

- [Terraform CLI](https://www.terraform.io/downloads.html) v0.13+
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- [Google Cloud account](https://console.cloud.google.com/getting-started) with billing set up

## Set up deployment

Follow the steps below to set up your deployment for the first time.

1. Create a Google Cloud project:

```bash
# Create project
gcloud projects create "PROJECT_ID" --name="PROJECT NAME"

# Set proejct as default
gcloud config set project "PROJECT_ID"
```

2. Set up billing

```bash
# List billing accounts available
gcloud beta billing accounts list

# Link billing account
gcloud beta billing projects link "PROJECT_ID" --billing-account="BILLING_ACCOUNT_ID"
```

3. Create a bucket to store the remote Terraform state and update `infra/backend.tf`:

```bash
# Create bucket
gsutil mb gs://tfstate-PROJECT_ID
```

```diff
# infra/backend.tf

terraform {
  required_version = ">= 0.13"

+   backend "gcs" {
+     bucket = "tfstate-PROJECT_ID"
+   }

  required_providers {
    google = ">= 3.3"
  }
}
```

4. Apply the Terraform configuration for the first time:

```bash
cd infra

terraform init

terraform plan -var project=PROJECT_ID

terraform apply -var project=PROJECT_ID
```

5. [Create GitHub secrets](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository)

Create two GitHub secrets for your repository:

`PROJECT_ID`

Your Google Cloud project ID.

`SERVICE_ACCOUNT_KEY`

Key for the deployment service account. It was created by Terraform on the previous step. Run `terraform output deployment_sa_key` to display the value.

6. Commit modified files

```bash
git add .

git commit -m "update terraform config"

git push
```

7. Done 🎉

## Deploying the service

GitHub actions is configured to deploy a new image when a release is created.

[Go here](https://github.com/ruanmartinelli/cloud-run-nodejs-template/releases/new) to create a new release and trigger a deployment.

## License

MIT 2021
