#!/bin/bash
#
# Build manylinux1 wheels for HTSeq. Based on the example at
# <https://github.com/pypa/python-manylinux-demo>
#
# It is best to run this in a fresh clone of the repository!
#
# Run this within the repository root:
#   docker run --rm -v $(pwd):/io quay.io/pypa/manylinux1_x86_64 /io/buildwheels.sh
#
# The wheels will be put into the wheelhouse/ subdirectory.
#
# For interactive tests:
#   docker run -it -v $(pwd):/io quay.io/pypa/manylinux1_x86_64 /bin/bash

set -xeuo pipefail

# For convenience, if this script is called from outside of a docker container,
# it starts a container and runs itself inside of it.
if ! grep -q docker /proc/1/cgroup; then
  # We are not inside a container
  exec docker run --rm -v $(pwd):/io quay.io/pypa/manylinux1_x86_64 /io/$0
fi

# Python 2.6 is not supported
rm -r /opt/python/cp26*

# Python 3.3 is not supported:
rm -r /opt/python/cp33*

# Install packages and test them
PYBINS="/opt/python/*/bin"
for PYBIN in ${PYBINS}; do
    ${PYBIN}/pip install twine
    ${PYBIN}/twine register
    if [ $? != 0 ]; then
        exit 1
    fi
done

