shader_type sky;

uniform float speed : hint_range(0.01, 0.5) = 0.05;
uniform float dot_brightness : hint_range(0.0, 1.0) = 0.8;
uniform float dot_size : hint_range(1.0, 50.0) = 20.0;

void sky() {
    float time = TIME * speed;
    
    // Base dark colors
    vec3 color1 = vec3(0.0, 0.0, 0.0);
    vec3 color2 = vec3(0.0, 0.0, 0.0);
    vec3 color3 = vec3(0.0, 0.0, 0.0);
    
    float t1 = sin(time + EYEDIR.x * 2.0) * 0.5 + 0.5;
    float t2 = cos(time * 0.7 + EYEDIR.y * 3.0) * 0.5 + 0.5;
    
    vec3 sky_color = mix(mix(color1, color2, t1), color3, t2);
    
    float horizon = pow(1.0 - abs(EYEDIR.y), 3.0);
    sky_color = mix(sky_color * 0.2, sky_color, horizon);
    
    // Moving pointy dots
    vec2 uv = vec2(EYEDIR.x, EYEDIR.y) * 5.0;
    uv.x += time * 2.0;
    uv.y += time * 0.5;
    
    vec2 grid = fract(uv) - 0.5;
    float dist = length(grid);
    float dot = pow(max(0.0, 1.0 - dist * dot_size), 3.0);
    
    // Second layer offset
    vec2 uv2 = vec2(EYEDIR.x, EYEDIR.y) * 8.0;
    uv2.x += time * 1.5;
    uv2.y -= time * 0.8;
    
    vec2 grid2 = fract(uv2) - 0.5;
    float dist2 = length(grid2);
    float dot2 = pow(max(0.0, 1.0 - dist2 * dot_size), 3.0);
    
    sky_color += vec3((dot + dot2) * dot_brightness);
    
    COLOR = sky_color;
}