#!/bin/bash
# try and make wheels
if [ $DOCKER_IMAGE ]; then
  docker run --rm -v `pwd`:/io $DOCKER_IMAGE /io/buildwheels.sh 
  if [ $? != 0 ]; then
      exit 1
  fi
  ls wheelhouse/
  if [ $? != 0 ]; then
      exit 1
  fi

# compile normally
else
  # setuptools < 18.0 has issues with Cython as a dependency
  pip install Cython
  if [ $? != 0 ]; then
      exit 1
  fi
  
  sed -i "s/pysam>=0.9.0/$PYSAM_VERSION/" setup.py
  if [ $? != 0 ]; then
      exit 1
  fi
  
  # old setuptools also has a bug for extras, but it still compiles
  pip install -v '.[htseq-qa]'
  if [ $? != 0 ]; then
      exit 1
  fi
fi
