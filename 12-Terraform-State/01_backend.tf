terraform {
  # Backend local (actif par défaut — aucune configuration cloud requise)
  backend "local" {
    path = "terraform.tfstate"
  }
}

# ---------------------------------------------------------------------------
# Backend S3 avec LocalStack (optionnel — décommenter pour tester)
#
# Prérequis :
#   1. LocalStack lancé : docker run -d -p 4566:4566 localstack/localstack
#   2. Créer le bucket et la table DynamoDB via awslocal :
#        awslocal s3 mb s3://tf-aws-backend
#        awslocal dynamodb create-table \
#          --table-name tf-dev-state-lock \
#          --attribute-definitions AttributeName=LockID,AttributeType=S \
#          --key-schema AttributeName=LockID,KeyType=HASH \
#          --billing-mode PAY_PER_REQUEST
#   3. Commenter le bloc "local" ci-dessus et décommenter le bloc "s3" ci-dessous
#   4. Relancer : terraform init -reconfigure
#
# terraform {
#   backend "s3" {
#     bucket         = "tf-aws-backend"
#     key            = "tf/dev/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "tf-dev-state-lock"
#
#     # Options LocalStack
#     access_key                  = "test"
#     secret_key                  = "test"
#     skip_credentials_validation = true
#     skip_metadata_api_check     = true
#     force_path_style            = true
#     endpoint                    = "http://localhost:4566"
#   }
# }
# ---------------------------------------------------------------------------
