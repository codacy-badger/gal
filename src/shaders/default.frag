#version 450

layout(location = 0) in vec2 v_texcoord0;
layout (location = 0) out vec4 fragColor;
layout (binding = 0) uniform sampler2D u_texture0;

void main()
{
    fragColor = texture(u_texture0, v_texcoord0);
}
