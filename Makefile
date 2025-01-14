current_dir = $(shell pwd)

init:
	melange keygen

build:
	melange build \
		$(package) \
		-r packages/ \
		-k melange.rsa.pub \
		-r https://packages.wolfi.dev/os \
		-k https://packages.wolfi.dev/os/wolfi-signing.rsa.pub \
		--signing-key melange.rsa \
		--git-repo-url=https://github.com/shyim/wolfi.php \
		--git-commit=$(shell git rev-parse HEAD) \
		--arch host

test:
	echo "https://packages.wolfi.dev/os" > repositories
	echo "/packages" >> repositories
	docker \
	run \
	--rm \
	-v $(current_dir)/packages:/packages \
	-v $(current_dir)/repositories:/etc/apk/repositories \
	-v $(current_dir)/melange.rsa.pub:/etc/apk/keys/melange.rsa.pub \
	--git-repo-url=https://github.com/shyim/wolfi.php \
	--git-commit=$(shell git rev-parse HEAD) \
	-p 8000:8000 \
	-it cgr.dev/chainguard/wolfi-base
