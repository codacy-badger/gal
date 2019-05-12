#version 450

layout(location = 0) in vec2 a_position;
layout(location = 1) in vec2 a_texcoord0;
layout(location = 0) out vec2 v_texcoord0;

uniform Constants {
    vec4 viewRect;
} constants;


void main()
{
    v_texcoord0 = a_texcoord0;
    gl_Position = vec4(2.0 * a_position.x / constants.viewRect.z - 1.0,
                       1.0 - 2.0 * a_position.y / constants.viewRect.w,
                       0.0, 1.0);
}
