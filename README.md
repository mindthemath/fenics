# fenics installation

Comes with `dolfin` / `fenics` / `mshr`.
Batteries: `petsc`, `slepc`, `boost`, `blas`, `lapack`, `fortran`, `eigen3`
Also includes: `numpy` and `scipy`

Primarily for use as a base image (reflecting the desired python version)

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

