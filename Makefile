start:
	@echo '[MAKE] Starting Vagrant environment'
	@vagrant up --no-provision
	@echo '[MAKE] Provisioning Vagrant environment with Ansible'
	@vagrant provision --provision-with ansible
	@echo '[MAKE] Vagrant environment ready'

clean:
	@vagrant destroy -f