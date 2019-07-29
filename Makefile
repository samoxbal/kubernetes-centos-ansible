start:
	@echo '[MAKE] Starting Vagrant environment'
	@vagrant up --no-provision
	@echo '[MAKE] Provisioning Vagrant environment with Ansible'
	@vagrant provision --provision-with play-k8s
	@echo '[MAKE] Vagrant environment ready'

nodes:
	@echo '[MAKE] Start join nodes'
	@vagrant provision --provision-with play-k8s-nodes
	@echo '[MAKE] Nodes successfully joined to cluster'

ingress:
	@echo '[MAKE] Start deploy ingress'
	@vagrant provision --provision-with play-ingress-nginx
	@echo '[MAKE] Ingress nginx setup'

dashboard:
	@echo '[MAKE] Start deploy dashboard'
	@vagrant provision --provision-with play-k8s-dashboard
	@echo '[MAKE] Dashboard successfully setup'

clean:
	@vagrant destroy -f