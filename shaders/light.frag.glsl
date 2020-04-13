# version 330 core
// Do not use any version older than 330!

/* This is the fragment shader for reading in a scene description, including
   lighting.  Uniform lights are specified from the main program, and used in
   the shader.  As well as the material parameters of the object.  */

// Inputs to the fragment shader are the outputs of the same name of the vertex shader.
// Note that the default output, gl_Position, is inaccessible!
in vec3 mynormal;
in vec4 myvertex;

// You will certainly need this matrix for your lighting calculations
uniform mat4 modelview;

// This first defined output of type vec4 will be the fragment color
out vec4 fragColor;

uniform vec3 color;

uniform float EPSILON = 0.0000000001;

const int numLights = 10;
uniform bool enablelighting;// are we lighting at all (global).
uniform vec4 lightposn[numLights];// positions of lights
uniform vec4 lightcolor[numLights];// colors of lights
uniform int numused;// number of lights used

// Now, set the material parameters.
// I use ambient, diffuse, specular, shininess.
// But, the ambient is just additive and doesn't multiply the lights.

uniform vec4 ambient;// done
uniform vec4 diffuse;// done
uniform vec4 specular;//
uniform vec4 emission;
uniform float shininess;

vec3 dehomogenize(vec4 pos) {
    return pos.xyz / pos.w;
}

bool is_zero(vec4 vec) {
    return all(lessThan(abs(vec), vec4(EPSILON)));
}

bool is_zero(vec3 vec) {
    return all(lessThan(abs(vec), vec3(EPSILON)));
}

bool is_directional(vec4 light_pos) {
    return abs(light_pos.w) < EPSILON;
}


float zmax(float theta) {
    return max(0, theta);
}

vec3 calculate_normalized_light_direction(vec4 light_position, vec3 vertex) {
    if (is_directional(light_position)) {
        return normalize(light_position.xyz);
    } else {
        vec3 light_position = dehomogenize(light_position);
        return normalize(light_position - vertex);
    }
}

vec4 compute_phong_lambert(vec3 normalized_light_direction, vec3 normal, vec4 diffuse, vec4 light_color,
            float shininess, vec4 specular, vec3 normalized_eye_direction) {
    float intensity_cos_theta = zmax(dot(normalized_light_direction, normal));
    vec4 lambertian = intensity_cos_theta * diffuse * light_color;

    vec3 half_vector = normalize(normalized_eye_direction + normalized_light_direction);
    vec4 phong = pow(zmax(dot(half_vector, normal)), shininess) * specular * light_color;

    return phong + lambertian;
}


void main (void) {
    vec3 vertex = dehomogenize(modelview * myvertex);
    vec3 normal = normalize(mat3(transpose(inverse(modelview))) * mynormal);

    // In OpenGL, eye is always located in the origin of the world, looking down (0, 0, -1).
    vec3 eye_position = vec3(0);
    vec3 normalized_eye_direction = normalize(eye_position - vertex);

    vec4 blinn_phong = ambient + emission;
    for (int i = 0; i < numused; i++) {
        vec3 normalized_light_direction = calculate_normalized_light_direction(lightposn[i], vertex);
        blinn_phong += compute_phong_lambert(normalized_light_direction, normal, diffuse, lightcolor[i], shininess, specular, normalized_eye_direction);
    }

    fragColor = blinn_phong;
}
