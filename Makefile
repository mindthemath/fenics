build: 2019.1.0

latest:
	docker build -t fenics -f Dockerfile .

2019.1.0:
	docker build -t fenics -t fenics-2019.1.0 -f Dockerfile-2019.1.0 .

2019.1.0.post0:
	docker build -t fenics -t fenics-2019.1.0.post0 -f Dockerfile-2019.1.0.post0 .

SHELL=bash
# docker buildx build --platform linux/amd64,linux/arm64
buster:
	# for TAG in $(shell echo 3.6.{9..13}-buster 3.{7..8}.{4..10}-buster {3.6.{14..15},3.{7..8}.{11..12},3.9.{6..9},3.10.{0..1}}-buster | sort); do
	for TAG in $(shell echo 3.{7..8}.{4..10}-buster {3.6.{14..15},3.{7..8}.{11..12},3.9.{6..9},3.10.{0..1}}-buster | sort); do \
		VER=2019.1.0;\
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

