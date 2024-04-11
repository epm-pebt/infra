# Ecobytes Infra

This repo creates the infra needed to deploy the application

## Design

All files are in the root path of repo

```bash

config/
docs
environment
main.tf
modules/
provider.tf
state/
terraform.tf
variables.tf
```

The main idea is to use the same `tf` files for different environments dev, stg or prod, the flexibility is using the <env>.tfvars where all specific information can be stored, the attribute of resources for each environment. 

In `config` folder there are the files for each enviroment targeting all this main values such as instance_type or tags information.


```bash
cat config/dev.tfvars

#----- EC2 instance properties  --------------------------------
ami = "ami-053b0d53c279acc90"
instance_type = "t2.micro"
instance_name = "webserver"
```

> **Warning**  
> For each environment you need to create a file inside config/ regarding the name of 
> environment stg or prod e.g., `prod.tfvars`

In environment folder you can have specific configurations for each environment so this configuration can be created inside this folder in a traditional way. 

```
enviroment
├── dev
│   ├── dev.tfvars
│   ├── main.tf
│   ├── provider.tf
│   └── variables.tf
└── prod
    ├── main.tf
    ├── prod.tfvars
    ├── provider.tf
    └── variables.tf
```



    
## Tech Stack

**Client:** Terraform, aws-cli

## Run Locally

Follow the following steps to access to AWS account and run Terraform locally in this [link](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
or this [link](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) 

Clone the project

```bash
  git clone https://github.com/epm-pebt/infra.git
```

Go to the project directory

```bash
  cd infra
```

Initialize the terraform working directory 

```bash
  terraform init 
```

Check if the terraform workspace dev is created. 

```bash
  terraform workspace list
  * default
  dev
```

Select the terraform workspace (this is just for using different terraform state)

```bash
  terraform workspace list
  default
  * dev
```

Check the terraform code is right and export the "tfplan" 

```bash
  terraform plan -var-file="config/dev.tfvars" -out "tfplan"
```

Apply the code to the infra

```bash
  terraform apply "tfplan"
```
