#!/bin/bash -e

mkdir -p $(dirname "$0")/../../cmake/Hunter
wget https://raw.githubusercontent.com/hunter-packages/gate/master/cmake/HunterGate.cmake -O $(dirname "$0")/../../cmake/Hunter/HunterGate.cmake
