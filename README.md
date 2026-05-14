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
  