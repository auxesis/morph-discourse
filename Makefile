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

ci: decrypt build_and_abort

encrypt:
	@travis encrypt-file --force ansible/group_vars/all ansible/group_vars/all.enc
	@travis encrypt-file --force ansible/roles/discourse/files/sslmate.conf ansible/roles/discourse/files/sslmate.conf.enc
	@travis encrypt-file --force ansible/roles/discourse/dhparam.pem ansible/roles/discourse/dhparam.pem.enc
	@travis encrypt-file --force ansible/roles/discourse/files/morph.io.key ansible/roles/discourse/files/morph.io.key.enc
	git commit -m "Update secrets" ansible/group_vars/all.enc ansible/roles/discourse/files/sslmate.conf.enc ansible/roles/discourse/dhparam.pem.enc ansible/roles/discourse/files/morph.io.key.enc

decrypt:
	@openssl aes-256-cbc -K $(encrypted_0952b8ba8ff0_key) -iv $(encrypted_0952b8ba8ff0_iv) -in ansible/group_vars/all.enc -out ansible/group_vars/all -d
	@openssl aes-256-cbc -K $(encrypted_0952b8ba8ff0_key) -iv $(encrypted_0952b8ba8ff0_iv) -in ansible/roles/discourse/files/sslmate.conf.enc -out ansible/roles/discourse/files/sslmate.conf -d
	@openssl aes-256-cbc -K $(encrypted_0952b8ba8ff0_key) -iv $(encrypted_0952b8ba8ff0_iv) -in ansible/roles/discourse/dhparam.pem.enc -out ansible/roles/discourse/dhparam.pem -d
	@openssl aes-256-cbc -K $(encrypted_0952b8ba8ff0_key) -iv $(encrypted_0952b8ba8ff0_iv) -in ansible/roles/discourse/files/morph.io.key.enc -out ansible/roles/discourse/files/morph.io.key -d
