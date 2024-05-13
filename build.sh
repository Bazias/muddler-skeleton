#!/bin/bash
docker run --rm -it -v "$PWD":"/workdir" $(docker build -q -f "$PWD"/Dockerfile.build .) squish /workdir --debug
docker run --pull always --rm -it -u $(id -u):$(id -g) -v "$PWD":"/$PWD" -w "/$PWD" demonnic/muddler "$@"
