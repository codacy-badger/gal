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

include_guard()

if(POLICY CMP0076)
  cmake_policy(SET CMP0076 OLD)
endif()

function(glslc)

    cmake_parse_arguments(_GLSLC "GENERATE_GLSL;GENERATE_GLSL_ES;GENERATE_MSL;GENERATE_HLSL" "TARGET" "SHADER_FILES" ${ARGN})

    hunter_add_package(shaderc)
    hunter_add_package(spirv-cross)

    find_package(shaderc CONFIG REQUIRED)
    find_program(SPIRV_CROSS_EXECUTABLE spirv-cross)

    foreach(_GLSLC_SHADER_FILE IN LISTS _GLSLC_SHADER_FILES)

        get_filename_component(_GLSLC_DIRECTORY ${_GLSLC_SHADER_FILE} DIRECTORY)
        get_filename_component(_GLSLC_EXT ${_GLSLC_SHADER_FILE} EXT)
        get_filename_component(_GLSLC_NAME_WE ${_GLSLC_SHADER_FILE} NAME_WE)

        set(_GLSLC_SPV_OUTPUT ${_GLSLC_DIRECTORY}/${_GLSLC_NAME_WE}_spv${_GLSLC_EXT})

        add_custom_command(
            OUTPUT ${_GLSLC_SPV_OUTPUT}
            COMMAND shaderc::glslc_exe
            ARGS -c ${CMAKE_SOURCE_DIR}/${_GLSLC_SHADER_FILE} -o ${_GLSLC_SPV_OUTPUT}
            DEPENDS ${_GLSLC_SHADER_FILE}
            COMMENT "Generated ${_GLSLC_SPV_OUTPUT}"
        )
        set_source_files_properties(${_GLSLC_SPV_OUTPUT} PROPERTIES GENERATED TRUE)
        target_sources(${_GLSLC_TARGET} PUBLIC ${_GLSLC_SHADER_FILE} ${_GLSLC_SPV_OUTPUT})

        if(_GLSLC_GENERATE_GLSL_ES)
            macro(generate_glsl_es version)
                set(_GLSLC_GLSL_${version}_ES_OUTPUT ${_GLSLC_DIRECTORY}/${_GLSLC_NAME_WE}_glsl_${version}_es${_GLSLC_EXT})
                add_custom_command(
                    OUTPUT ${_GLSLC_GLSL_${version}_ES_OUTPUT}
                    COMMAND ${SPIRV_CROSS_EXECUTABLE}
                    ARGS --version ${version} --es --output ${_GLSLC_GLSL_${version}_ES_OUTPUT} ${_GLSLC_SPV_OUTPUT} --force-temporary
                    DEPENDS ${_GLSLC_SPV_OUTPUT}
                    COMMENT "Generated ${_GLSLC_GLSL_${version}_ES_OUTPUT}"
                    )
                set_source_files_properties(${_GLSLC_GLSL_${version}_ES_OUTPUT} PROPERTIES GENERATED TRUE)
                target_sources(${_GLSLC_TARGET} PUBLIC ${_GLSLC_GLSL_${version}_ES_OUTPUT})
            endmacro()
            generate_glsl_es(100)
            generate_glsl_es(300)
        endif()

        if(_GLSLC_GENERATE_GLSL)
            macro(generate_glsl version)
                set(_GLSLC_GLSL_${version}_OUTPUT ${_GLSLC_DIRECTORY}/${_GLSLC_NAME_WE}_glsl_${version}${_GLSLC_EXT})
                add_custom_command(
                    OUTPUT ${_GLSLC_GLSL_${version}_OUTPUT}
                    COMMAND ${SPIRV_CROSS_EXECUTABLE}
                    ARGS --version ${version} --no-es --output ${_GLSLC_GLSL_${version}_OUTPUT} ${_GLSLC_SPV_OUTPUT}
                    DEPENDS ${_GLSLC_SPV_OUTPUT}
                    COMMENT "Generated ${_GLSLC_GLSL_${version}_OUTPUT}"
                    )
                set_source_files_properties(${_GLSLC_GLSL_${version}_OUTPUT} PROPERTIES GENERATED TRUE)
                target_sources(${_GLSLC_TARGET} PUBLIC ${_GLSLC_GLSL_${version}_OUTPUT})
            endmacro()
            generate_glsl(110)
            generate_glsl(120)
            generate_glsl(130)
            generate_glsl(140)
            generate_glsl(150)
            generate_glsl(330)
            generate_glsl(400)
            generate_glsl(410)
            generate_glsl(420)
            generate_glsl(430)
            generate_glsl(440)
            generate_glsl(450)
            generate_glsl(460)
        endif()

        if (_GLSLC_GENERATE_MSL)
            set(_GLSLC_MSL_OUTPUT ${_GLSLC_DIRECTORY}/${_GLSLC_NAME_WE}_msl${_GLSLC_EXT})
            add_custom_command(
                OUTPUT ${_GLSLC_MSL_OUTPUT}
                COMMAND ${SPIRV_CROSS_EXECUTABLE}
                ARGS --msl --output ${_GLSLC_MSL_OUTPUT} ${_GLSLC_SPV_OUTPUT}
                DEPENDS ${_GLSLC_SPV_OUTPUT}
                COMMENT "Generated ${_GLSLC_MSL_OUTPUT}"
                )
            set_source_files_properties(${_GLSLC_MSL_OUTPUT} PROPERTIES GENERATED TRUE)
            target_sources(${_GLSLC_TARGET} PUBLIC ${_GLSLC_MSL_OUTPUT})
        endif()

        if (_GLSLC_GENERATE_HLSL)
            set(_GLSLC_HLSL_OUTPUT ${_GLSLC_DIRECTORY}/${_GLSLC_NAME_WE}_hlsl${_GLSLC_EXT})
            add_custom_command(
                OUTPUT ${_GLSLC_HLSL_OUTPUT}
                COMMAND ${SPIRV_CROSS_EXECUTABLE}
                ARGS --hlsl --output ${_GLSLC_HLSL_OUTPUT} ${_GLSLC_SPV_OUTPUT}
                DEPENDS ${_GLSLC_SPV_OUTPUT}
                COMMENT "Generated ${_GLSLC_HLSL_OUTPUT}"
                )
            set_source_files_properties(${_GLSLC_HLSL_OUTPUT} PROPERTIES GENERATED TRUE)
            target_sources(${_GLSLC_TARGET} PUBLIC ${_GLSLC_HLSL_OUTPUT})
        endif()

    endforeach()

endfunction()
