#!/usr/bin/env bash

if [ "$1" == "" ]; then
  echo "Usage: ./Flint.sh [flag]"
  echo "Flags:"
  echo "  --build: Build the project."
  echo "  --run: Build and run the project."
  echo "  --fmt: Format the code."
  exit 0
fi

FORMAT="0"
BUILD="0"
RUN="0"

while [ "$1" != "" ]; do
  if [ "$1" == "--build" ]; then
    BUILD="1"
    shift
    continue
  elif [ "$1" == "--run" ]; then
    RUN="1"
    shift
    continue
  elif [ "$1" == "--fmt" ]; then
    FORMAT="1"
    shift
    continue
  else
    echo "Invalid flag."
    exit 1
  fi
done

if [ $FORMAT == "1" ]; then
  opam exec -- dune fmt
fi

if [ $BUILD == "1" ]; then
  opam exec -- dune build
  if [ $? -ne 0 ]; then
    echo "Error building the project."
    exit 1
  fi
fi

if [ $RUN == "1" ]; then
  opam exec -- dune exec Flint
  if [ $? -ne 0 ]; then
    echo "Error running the project."
    exit 1
  fi
fi
