# Copyright (c) 2019 Mathieu-André Chiasson
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

hunter_config(SPIRV-Headers
    VERSION v1.4.1-p0
    URL https://github.com/mchiasson/SPIRV-Headers/archive/v1.4.1-p0.tar.gz
    SHA1 942ba385d1f71da73dab5f5467b53b770f954ad5
    CMAKE_ARGS SPIRV_HEADERS_ENABLE_EXAMPLES=OFF
)

hunter_config(SPIRV-Tools
    VERSION v2019.2-p1
    URL https://github.com/mchiasson/SPIRV-Tools/archive/v2019.2-p1.tar.gz
    SHA1 e7f2f93a95618d094c653aa11f317b533ac66e6b
    KEEP_PACKAGE_SOURCES
    CMAKE_ARGS SPIRV_SKIP_TESTS=ON SPIRV_WERROR=OFF
)

hunter_config(glslang
    VERSION v7.11.3188-p3
    URL https://github.com/mchiasson/glslang/archive/v7.11.3188-p3.tar.gz
    SHA1 d515bf21e7a9207e21549314fbcb27c712ee8058
    KEEP_PACKAGE_SOURCES
    CMAKE_ARGS ENABLE_HLSL=ON BUILD_TESTING=OFF
)

hunter_config(shaderc
    VERSION v2008.0-p0
    URL https://github.com/mchiasson/shaderc/archive/v2008.0-p0.tar.gz
    SHA1 6de6a505fc7549b5cf4fa5a05eda744a4addd4c3
    KEEP_PACKAGE_SOURCES
    CMAKE_ARGS SHADERC_SKIP_TESTS=ON
)
