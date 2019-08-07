start:
	@echo '[MAKE] Starting Vagrant environment'
	@vagrant up --no-provision
	@echo '[MAKE] Provisioning Vagrant environment with Ansible'
	@vagrant provision --provision-with k8s
	@echo '[MAKE] Vagrant environment ready'

nodes:
	@echo '[MAKE] Start join nodes'
	@vagrant provision --provision-with k8s-nodes
	@echo '[MAKE] Nodes successfully joined to cluster'

deploy:
	@echo '[MAKE] Start deploy '$(component)
	@vagrant provision --provision-with $(component)
	@echo '[MAKE] Deploy successfull'

clean:
	@vagrant destroy -f