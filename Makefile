include .env

apigee_token:=$(shell docker run -e APIGEE_USER=${APIGEE_USER} -e APIGEE_PASSWORD=${APIGEE_PASSWORD} --rm artronics/apigee-token-action:latest | cut -d':' -f 5)

clean-all: terraform-clean build-clean

build:
	@npm run build
	@npm run ci:test

build-clean:
	rm -rf node_modules
	rm -rf build

terraform-init:
	@docker run -it -v `pwd`:/app -w /app -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)\
 artronics/nhsd-apim-apigee-terraform:latest init -backend-config="key=api-template/prefixed/${PREFIX}/tfstate.json" ./terraform

terraform-plan:
	@docker run -it -v `pwd`:/app -w /app -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)\
 artronics/nhsd-apim-apigee-terraform:latest plan -input=false \
 -var="env=user_${USER}" -var="apigee_user=${APIGEE_USER}" -var="apigee_access_token=$(apigee_token)" ./terraform

terraform-apply:
	@docker run -it -v `pwd`:/app -w /app -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)\
 artronics/nhsd-apim-apigee-terraform:latest apply -input=false -auto-approve -var="env=user_${USER}" -var="apigee_user=${APIGEE_USER}" -var="apigee_access_token=$(apigee_token)" ./terraform

terraform-clean:
	rm -rf .terraform

terraform: terraform-init terraform-plan terraform-apply

deploy-test: build terraform
