# Apt Assignment

## Deliverables
* Terraform code in root directory
* FastAPI Server embedded in cloud-init script in `scripts/user_data.sh`
* One-click solution for deploy and destroy in Github Actions workflows

## Project Directory
```
├── alb.tf
├── asg.tf
├── outputs.tf
├── provider.tf
├── scripts
│   ├── tf-backend-setup.sh
│   └── user_data.sh
├── terraform.tfvars
├── variables.tf
└── vpc.tf
```

## Deployment
NOTE TO THE TEAM: The credentials taken as input will be visible in runner logs. Please use temp logs to test.

* Put the credentials in AWS Access Key and AWS Secret Access Key with relevant region
* Run the workflow
* Check the output URL in the last step logs.Something like `aws_alb` 
<img width="635" height="102" alt="image" src="https://github.com/user-attachments/assets/3b2dc95b-cdf5-4ce3-aad6-57bcf2914fa2" />

## Destruction

* Put the credentials in AWS Access Key and AWS Secret Access Key with relevant region
* Run the workflow
<img width="806" height="142" alt="image" src="https://github.com/user-attachments/assets/3bfe882a-d243-432c-9645-a60932b569a2" />

## Required Screenshots
* ALB:
  <img width="1305" height="481" alt="image" src="https://github.com/user-attachments/assets/143e9d47-5573-44c9-9441-0fc8ededc72d" />
* EC2:
  <img width="1314" height="119" alt="image" src="https://github.com/user-attachments/assets/ce709e6e-07bd-4a27-9025-700e1a79dbaf" />
* Target Group:
  <img width="1266" height="657" alt="image" src="https://github.com/user-attachments/assets/448b3d06-f434-4c0d-8c65-aa9fc50ae27f" />
* API Test:
  <img width="720" height="153" alt="image" src="https://github.com/user-attachments/assets/23f63972-2e50-45e4-99c3-7cfb25783d49" />



