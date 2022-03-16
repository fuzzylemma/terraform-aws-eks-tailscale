runit:
	terraform init
	terraform apply --auto-approve
	#aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

killit:
	terraform destroy --auto-approve
