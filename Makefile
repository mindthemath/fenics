build: 2019.1.0

latest:
	docker build -t fenics -f Dockerfile .

2019.1.0:
	docker build -t fenics -t fenics-2019.1.0 -f Dockerfile-2019.1.0 .

2019.1.0.post0:
	docker build -t fenics -t fenics-2019.1.0.post0 -f Dockerfile-2019.1.0.post0 .
