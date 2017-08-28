.PHONY: all plan apply destroy

all: build

validate:
	packer validate discourse.json

build: validate
	packer build discourse.json

debug: validate
	packer build -debug discourse.json
