# TODO:
Add these instructions
## Requirement:
* AWS CLI is already configured
* Terraform is installed (of course)
* SSH key already created

## Running 
```bash
terraform init 
terrafrom plan 
Terraform apply
```

## Refreshing local exec provisioner
To refresh the instance and append configh to SSH config
 ```bash 
 terraform apply -replace aws_instance.node_instance 
 ```
## Clean up
 ```bash
 terraform destroy
 ```

 NOTE:
 * Edit the variables files as per your requirement.