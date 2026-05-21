# for recration
terraform taint resource
terraform apply -replace=aws_instance.web # in newer version

# upgrade terraform provider plugin 
terraform init -upgrade
terraform refresh to real world infra

# integration with jenkins
terraform fmt -check
terraform init
terraform validate
terraform plan -out=planfile

# manual approval
terraform apply planfile

# terraform apply fails
check .terrafom dir
run TF_LOG=DEBUG terraform apply
Iam permission
provider version mismatch

# lifecycle hooks
  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
    ignore_changes = [ tags ]
  }

# conditional
count = var.env == "prod" ? 3 : 1

terraform import aws_instance.web i-1234

terraform taint aws_instance.web

use tflint/chckov policies and Terratest(Go)

TOCTOU changes

terraform apply -debug

git -> build -> docker -> ecr -> eks -> alb

eks backend pods -> rds(pvt subnet)

eks/lambda -> dynamodb

git -> cicd -> ecr -> eks(pvt subnet) -> alb(pub sub) -> route53 -> user


