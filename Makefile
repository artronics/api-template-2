include .env

clean-all: terraform-clean build-clean

build:
	@npm run build
	@npm run ci:test

build-clean:
	rm -rf node_modules
	rm -rf build

terraform-init:
	@docker run -it -v `pwd`:/app -w /app -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)\
 hashicorp/terraform init  -backend-config="key=anaquanda-frontend/test/state" ./terraform

terraform-plan:
	@docker run -it -v `pwd`:/app -w /app -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)\
 hashicorp/terraform plan -input=false -var="env=test" ./terraform

terraform-apply:
	@docker run -it -v `pwd`:/app -w /app -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)\
 hashicorp/terraform apply -input=false -auto-approve -var="env=test" ./terraform

terraform-clean:
	rm -rf .terraform

terraform: terraform-init terraform-plan terraform-apply

aws-upload:
	@docker run --rm -v `pwd`/build:/aws -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)\
 -e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) -it amazon/aws-cli s3 sync . s3://anaquanda.test.artronics.io

deploy-test: build terraform aws-upload
