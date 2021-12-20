# fenics installation

Compiles and installs the python bindings for `dolfin` and `mshr`.

Primarily for use as a base image (reflecting the desired python version).

Batteries: `petsc`, `slepc`, `boost`, `blas`, `lapack`, `fortran`, `eigen3`
Also includes: `numpy` and `scipy`


```sh
make
```

```sh
docker run --rm -ti fenics bash
```

There is also the option to build the latest release

```sh
make 2019.1.0.post0
```


## patches
Some patches needed to be applied to successfully compile.

On `bullseye`, `petsc` causes problems which are fixed by using `2019.1.0.post0`.
There is an unused patch for `petsc` and `slepsc` which is included "just in case" it becomes useful at a future date.


# TODO
- [ ] github actions to publish images automatically (cross-platform)
- [ ] build (with env vars?) for different base-python images (or separate dockerfiles)
- [ ] slim down images (can we remove the source directories after installation if we combine the python and C++ steps?) (can we use the `slim` version of the images?)
- [ ] combine Dockerfiles (make env variables for dolfin version + python version), use makefile to control different options
- [ ] cover all python versions shown by following output (list built from [docker hub](https://hub.docker.com/_/python?tab=tags)):

```sh
echo {3.6.{14..15},3.{7..8}.{11..12},3.9.{6..9},3.10.{0..1}}-{bullseye,buster}
echo 3.{7..8}.{4..10}-buster
echo 3.6.{9..13}-buster
```

# contributions
Are welcome; see [TODO](#todo).
