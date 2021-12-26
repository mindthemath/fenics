build: 2019.1.0

2019.1.0:
	docker build -t fenics -t fenics-2019.1.0 -f Dockerfile-2019.1.0 .

2019.1.0.post0:
	docker build -t fenics -t fenics-2019.1.0.post0 -f Dockerfile-2019.1.0.post0 .

SHELL=bash
# docker buildx build --platform linux/amd64,linux/arm64
# {3.6.{14..15},3.{7..8}.{11..12},3.9.{6..9},3.10.{0..1}}-{bullseye,buster} 3.{7..8}.{4..10}-buster 3.6.{9..13}-buster
all:
	# for TAG in $(shell echo 3.6.{9..13}-buster 3.{7..8}.{4..10}-buster {3.6.{14..15},3.{7..8}.{11..12},3.9.{6..9},3.10.{0..1}}-buster | sort); do
	for TAG in $(shell echo {3.{7..8}.{11..12},3.9.{6..9},3.10.{0..1}}-bullseye | sort); do \
		VER=2019.1.0.post0;\
		echo BUILDING $$VER-$$TAG; \
		docker pull mindthemath/fenics-arm64:$$VER-$$TAG; \
		docker build \
			-t mindthemath/fenics-arm64:$$VER-$$TAG \
			--build-arg PYTHON_TAG=$$TAG \
			-f Dockerfile-$$VER . && \
		docker push mindthemath/fenics-arm64:$$VER-$$TAG && \
		docker rmi mindthemath/fenics-arm64:$$VER-$$TAG || exit; \
		yes | docker system prune; \
	done

buster:
	docker build \
		-t docker.io/mindthemath/fenics-arm64:2019.2.0.dev0-3.9.7-buster \
		--build-arg PYTHON_TAG=3.9.7-buster .

latest:
	docker build \
		-t docker.io/mindthemath/fenics-arm64:2019.2.0.dev0-3.6.14-bullseye \
		--build-arg PYTHON_TAG=3.6.14-bullseye .
