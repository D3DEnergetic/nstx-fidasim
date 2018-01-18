# nstx-fidasim
NSTX routines for running FIDASIM

## .login setup
Some of these may not be strictly required but it works for me
```
module load intel/2013.1.3
module load git/1.8.0.2
module load pathscale
module load nstx
module load ntcc
module load anaconda2/4.2.0

setenv FIDASIM_DIR /p/fida/FIDASIM
setenv FC ifort
setenv CC icc
setenv CXX icpc 
setenv {$FIDASIM_DIR}/deps/hdf5/bin:{$FIDASIM_DIR}/lib:{$PATH}
setenv IDL_PATH +{$FIDASIM_DIR}:{$IDL_PATH}
setenv PYTHONPATH {$FIDASIM_DIR}/lib/python
limit stacksize unlimited
```

## Example
```
IDL> inputs = nstx_inputs()
IDL> nstx_prefida,inputs
```
