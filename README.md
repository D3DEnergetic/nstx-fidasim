# nstx-fidasim
NSTX routines for running FIDASIM

## .login setup
Some of these may not be strictly required but it works for me
```
module load intel
module load git/1.8.0.2
module load pathscale
module load nstx
module load netcdf
module load perl
module load ntcc
module load nstx/python-2.7
module load python/scipy

setenv FIDASIM_DIR /p/fida/FIDASIM
setenv FC ifort
setenv CC icc
setenv CXX icpc
setenv PATH {$FIDASIM_DIR}/lib:{$PATH}
setenv HDF5_INCLUDE {$FIDASIM_DIR}/deps/hdf5/include
setenv HDF5_LIB {$FIDASIM_DIR}/deps/hdf5/lib
setenv LD_LIBRARY_PATH {$HDF5_LIB}:{$HDF5_INCLUDE}:{$LD_LIBRARY_PATH}
setenv IDL_PATH +{$FIDASIM_DIR}:{$IDL_PATH}
limit stacksize unlimited
```

## Example
```
IDL> inputs = nstx_inputs()
IDL> nstx_prefida,inputs
```
