help:		## Print Help Message
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

clean:
	@rm -rf .terraform*

dev-apply:	clean ## Create VPC in DEV ENV
	@terraform init -backend-config env-dev/state.tfvars
	@terraform apply -auto-approve -var-file .\env-dev\db.tfvars


dev-destroy:	clean ## Destroy VPC in DEV ENV
	@terraform init -backend-config env-dev/state.tfvars
	@terraform destroy -auto-approve -var-file .\env-dev\db.tfvars

