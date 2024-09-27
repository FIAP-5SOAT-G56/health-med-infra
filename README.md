# Health Med Infra
![aws](https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonwebservices&logoColor=white)
![redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![mysql](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![localstack](https://img.shields.io/badge/Localstack-3C3C3C?style=for-the-badge&logo=localstack&logoColor=white)


## Dependencies
- [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Make
  - [Windows](https://gnuwin32.sourceforge.net/packages/make.htm)
  - Linux:
  ```bash
  sudo apt update
  sudo apt install make

## Running Locally
```bash
# To build the image and run the containers
make up

# To get the logs
make logs

# To stop the containers
make down

# To access localstack container bash
make localstack

# To access redis-cli in redis container
make redis
```

## Provisioning AWS resources

### Export environment variables
Before all, you need set all secrets.json.example values to your environment variables:
```bash
export AWS_REGION=us-east-1

export AWS_ACCESS_KEY_ID=xxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxx
export PERSONAL_ACCESS_TOKEN=xxxxxx
export SENTRY_DSN_API=xxxxxx
export DB_HOSTNAME=xxxxxx
export DB_USERNAME=xxxxxx
export DB_PASSWORD=xxxxxx
export REDIS_HOSTNAME=xxxxxx
export SENDGRID_API_KEY=xxxxxx
export SENDGRID_EMAIL=xxxxxx

```
Or configure it in windows environments.


### Create a S3 bucket to store terraform state
```bash
aws s3api create-bucket --bucket fiap-health-med-tfstate --region us-east-1
```

### Create secrets in AWS Secrets Manager
```bash
cp secrets.json.example secrets.json
# Edit secrets.json with your secrets

aws secretsmanager create-secret --name fiap-health-med-secrets-api --secret-string file://secrets.json
```

### Run Terraform
```bash
# To init terraform
make tf-init

# To run terraform plan
make tf-plan

# To apply changes
make tf-apply
```

### To destroy all resources
```bash
# To destroy all terraform resources
make tf-destroy

# To delete secrets
aws secretsmanager delete-secret --secret-id fiap-health-med-secrets-api --force-delete-without-recovery

# To delete S3 bucket
aws s3api delete-bucket --bucket fiap-health-med-tfstate --region us-east-1
```
