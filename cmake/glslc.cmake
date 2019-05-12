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

option(GAL_GLSLC_GENERATE_GLSL    "Generate GLSL Shaders"    ON)
option(GAL_GLSLC_GENERATE_GLSL_ES "Generate GLSL ES Shaders" ON)
option(GAL_GLSLC_GENERATE_MSL     "Generate MSL Shaders"     ON)
option(GAL_GLSLC_GENERATE_HLSL    "Generate HLSL Shaders"    ON)

function(glslc shaders)

    hunter_add_package(shaderc)
    hunter_add_package(spirv-cross)

    find_package(shaderc CONFIG REQUIRED)
    find_program(SPIRV_CROSS_EXECUTABLE spirv-cross)

    math(EXPR LAST_INDEX "${ARGC}-1")
    foreach(I RANGE 1 ${LAST_INDEX})

        get_filename_component(_GLSLC_DIRECTORY ${ARGV${I}} DIRECTORY)
        get_filename_component(_GLSLC_NAME_WE ${ARGV${I}} NAME_WE)
        get_filename_component(_GLSLC_TYPE ${ARGV${I}} EXT)
        string(REGEX REPLACE "^\\." "" _GLSLC_TYPE ${_GLSLC_TYPE})

        if(_GLSLC_TYPE STREQUAL vert)
            set(IS_VERTEX TRUE)
        elseif(_GLSLC_TYPE STREQUAL frag)
            set(IS_FGRAMENT TRUE)
        elseif(_GLSLC_TYPE STREQUAL tesc)
            set(IS_TESSELATION_CONTROL TRUE)
        elseif(_GLSLC_TYPE STREQUAL tese)
            set(IS_TESSELATION_EVALUATION TRUE)
        elseif(_GLSLC_TYPE STREQUAL geom)
            set(IS_GEOMETRY TRUE)
        elseif(_GLSLC_TYPE STREQUAL comp)
            set(IS_COMPUTE TRUE)
        else()
            message(FATAL_ERROR "Unknown shader type \"${_GLSLC_TYPE}\".  Supported types are \"vert\", \"frag\", \"tesc\", \"tese\", \"geom\" and \"comp\"")
        endif()

        set(_GLSLC_OUTPUT_BASE ${_GLSLC_DIRECTORY}/${_GLSLC_NAME_WE}_${_GLSLC_TYPE})
        set(_GLSLC_SPIRV_FILE ${_GLSLC_OUTPUT_BASE}.spv)

        add_custom_command(
            OUTPUT ${_GLSLC_SPIRV_FILE}
            COMMAND shaderc::glslc_exe
            ARGS -c ${CMAKE_SOURCE_DIR}/${ARGV${I}} -o ${_GLSLC_SPIRV_FILE}
            DEPENDS ${ARGV${I}}
            COMMENT "Generated ${_GLSLC_SPIRV_FILE}"
        )
        set_source_files_properties(${_GLSLC_SPIRV_FILE} PROPERTIES GENERATED TRUE)
        list(APPEND ${shaders} ${_GLSLC_SPIRV_FILE})

        macro(spirv_cross output)
            add_custom_command(
                OUTPUT ${output}
                COMMAND ${SPIRV_CROSS_EXECUTABLE}
                ARGS ${ARGV} --output ${output} ${_GLSLC_SPIRV_FILE}
                DEPENDS ${_GLSLC_SPIRV_FILE}
                COMMENT "Generated ${output}"
                )
            set_source_files_properties(${output} PROPERTIES GENERATED TRUE)
            list(APPEND ${shaders} ${output})
        endmacro()

        spirv_cross(${_GLSLC_OUTPUT_BASE}.json --reflect)

        if(GAL_GLSLC_GENERATE_GLSL_ES)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_100_es.glsl --version 100 --es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_300_es.glsl --version 300 --es --force-temporary)
        endif()

        if(GAL_GLSLC_GENERATE_GLSL)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_110.glsl --version 110 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_120.glsl --version 120 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_130.glsl --version 130 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_140.glsl --version 140 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_150.glsl --version 150 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_330.glsl --version 330 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_400.glsl --version 400 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_410.glsl --version 410 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_420.glsl --version 420 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_430.glsl --version 430 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_440.glsl --version 440 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_450.glsl --version 450 --no-es --force-temporary)
            spirv_cross(${_GLSLC_OUTPUT_BASE}_460.glsl --version 460 --no-es --force-temporary)
        endif()

        if (GAL_GLSLC_GENERATE_MSL)
            spirv_cross(${_GLSLC_OUTPUT_BASE}.metal --msl --force-temporary)
        endif()

        if (GAL_GLSLC_GENERATE_HLSL)
            spirv_cross(${_GLSLC_OUTPUT_BASE}.hlsl --hlsl --force-temporary)
        endif()

    endforeach()

    set(${shaders} ${${shaders}} PARENT_SCOPE)

endfunction()
