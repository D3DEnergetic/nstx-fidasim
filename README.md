# nstx-fidasim
NSTX routines for running FIDASIM on the Portal cluster

## .login setup
Some of these may not be strictly required but it works for the FIDASIM development team
```
module load gcc
module load intel/2019.u3
module load acml/5.3.1/ifort64
module load git/2.27.0
module load anaconda3/2021.05
module load idl

setenv FIDASIM_DIR /p/fida/FIDASIM-dev
setenv FC ifort
setenv CC gcc 
setenv CXX g++

setenv PATH {$FIDASIM_DIR}/lib:{$PATH}
setenv PATH {$FIDASIM_DIR}/deps:{$PATH}
setenv PATH {$FIDASIM_DIR}/lib/scripts:{$PATH}
setenv PATH {$FIDASIM_DIR}/deps/efit:{$PATH}
setenv PATH {$FIDASIM_DIR}/deps/hdf5/bin:{$PATH}
setenv IDL_PATH +{$FIDASIM_DIR}:{$IDL_PATH}
setenv IDL_PATH +{/p/fida/nstx-fidasim-dev/src}:{$IDL_PATH}
setenv PYTHONPATH {$FIDASIM_DIR}/lib/python

limit stacksize unlimited
```

## Example
```
IDL> inputs = nstx_inputs()                   ;get some inputs
IDL> inputs.result_dir = '/u/username/folder' ;change default path
IDL> nstx_prefida, inputs                     ;run prefida
```
