.PHONY: all plan apply destroy

all: decrypt build

validate:
	packer validate discourse.json

build: validate
	packer build discourse.json

debug: validate
	packer build -debug discourse.json

build_and_abort: validate
	packer build -on-error=abort discourse.json

ci: decrypt validate

encrypt:
	travis encrypt-file --force ansible/group_vars/all ansible/group_vars/all.enc
	git commit -m "Update secrets" ansible/group_vars/all.enc

decrypt:
	@openssl aes-256-cbc -K $(encrypted_0952b8ba8ff0_key) -iv $(encrypted_0952b8ba8ff0_iv) -in ansible/group_vars/all.enc -out ansible/group_vars/all -d
