# HelloSpa

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 9.1.0.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag for a production build.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).

## Run staging & production stack

Prerequisites:
- Gitlab cluster
- Aws Account
- Terraform
- VirtualBox + Vagrant

Installation:
## Production
- Go to Infrastructure/Production and create S3 Bucket + DynamoDB table for remote state (prepare_remote_state.sh) - only once during first installation
- Use the same Bucket, DynamoDB Table & Region name inside 'provider.tf'
- Prepare terraform.tfvars based on terraform.tfvars.example in folder Infrastructure/Production
- Create AWS Route 53 Hosted Zone and delegate NS to your Domain Provider or Buy your own domain in AWS.
- 'terraform init' to set up infrastructure
- Add your AWS credentials (S3 + ECR Access) to Gitlab pipeline variables (TODO: create deploy user within Terraform apply)
- Use outputs in .gitlab-ci.yml to provide S3 Bucket name and ECR repository URL

## Staging
- Go to Infrastructure/Staging and provide your gitlab runner token & url in values.yaml
- Provide your AWS credentials in init_k8smaster.sh in task 7.
- Provide AWS ECR Url inside helm chart spa/values.yaml
- 'vagrant up' will spin up 3 hosts: k8smaster & 2 workers for Kubernetes

Usage:
- Branch deploy will build docker image, run tests and deploy via Helm into Kubernetes cluster thanks to gitlab runner working inside Kubernetes
- Branch master will build static page and deploy it to AWS S3 Bucket with Cloudfront. Page will be working with https thanks to certificate attached to the domain. Deploy stage has to be triggered manual in gitlab.

URL's:
- Staging: 172.20.1.100 , 172.20.1.101 , 172.20.1.102
- Production: Your domain provided in terraform