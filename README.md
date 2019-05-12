[![Build Status](https://travis-ci.com/mchiasson/gal.svg?branch=master)](https://travis-ci.com/mchiasson/gal)
[![LICENSE](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Donate to this project using Patreon](https://img.shields.io/badge/patreon-donate-green.svg)](https://www.patreon.com/mattchiasson)

# GAL
C99 compliant mid-level (G)raphic (A)bstraction (L)ayer inspired by Vulkan and Direct3D12


# Build dependencies

- [cmake 3.x](https://cmake.org/)
- [Python 3](https://python.org/)

## Linux

```sh
sudo apt update
sudo apt install cmake python3 build-essential
```

# How to build

```sh
cmake -S ./gal -B ./build-gal-Release -DCMAKE_BUILD_TYPE=Release
cmake --build ./build-gal-Release
```

