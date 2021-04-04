# cloud-run-nodejs-template

> TBD

## Setting up

1. Create a Google Cloud project:

```bash
gcloud projects create "my-cool-project-9981" --name="my cool project"

gcloud config set project "my-cool-project-9981"
```

2. Set up billing

```bash
# List billing accounts available
gcloud beta billing accounts list

# Link billing account
gcloud beta billing projects link my-cool-project-9981 --billing-account=000ECE-0E6BDE-77B963
```

3. Create a bucket to store the remote Terraform state and update `infra/backend.tf`:

```bash
gsutil mb gs://tfstate-my-cool-project-9981
```

```diff
terraform {
  required_version = ">= 0.13"

+   backend "gcs" {
+     bucket = "tfstate-my-cool-project-9981"
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

terraform plan -var project=my-cool-project-9981

terraform apply -var project=my-cool-project-9981
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

## License

MIT 2021
