ASSETS := $(shell yq e '.assets.[].src' manifest.yaml)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))

VERSION := $(shell yq e ".version" manifest.yaml)

S9PK_BUILD_ID := $(shell yq e ".id" manifest.yaml)
S9PK_PATH=$(shell find . -name $(S9PK_BUILD_ID).s9pk -print)

# delete the target of a rule if it has changed and its recipe exits with a nonzero exit status
.DELETE_ON_ERROR:

all: verify

verify: $(S9PK_BUILD_ID).s9pk $(S9PK_PATH)
		embassy-sdk verify s9pk $(S9PK_PATH)

clean:
	rm -f ./image.tar
	rm -f ./$(S9PK_BUILD_ID).s9pk
	
instructions.md: docs/instructions.md
	cp docs/instructions.md instructions.md
	
$(S9PK_BUILD_ID).s9pk: image.tar instructions.md $(ASSET_PATHS)
	embassy-sdk pack
		
image.tar: Dockerfile docker_entrypoint.sh
		DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/$(S9PK_BUILD_ID)/main:$(VERSION) --platform=linux/arm64 -o type=docker,dest=image.tar .