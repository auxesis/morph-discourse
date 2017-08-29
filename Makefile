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
	@tar cvzf secrets.tar.gz ansible/group_vars/all ansible/roles/discourse/files/sslmate.conf ansible/roles/discourse/files/dhparam.pem ansible/roles/discourse/files/morph.io.key
	@travis encrypt-file --force secrets.tar.gz secrets.tar.gz.enc
	@git commit -m "Update secrets" secrets.tar.gz.enc

decrypt:
	@openssl aes-256-cbc -K $(encrypted_0952b8ba8ff0_key) -iv $(encrypted_0952b8ba8ff0_iv) -in secrets.tar.gz.enc -out secrets.tar.gz -d
	@tar zxvf secrets.tar.gz
