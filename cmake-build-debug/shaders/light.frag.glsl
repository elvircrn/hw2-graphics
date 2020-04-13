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
    return max(0, cos(theta));
}

void main (void) {
    vec4 finalcolor = vec4(0);
    vec3 vertex = dehomogenize(modelview * myvertex);
    vec3 normal = normalize(mat3(transpose(inverse(modelview))) * mynormal);
    vec3 eye = normalize(-vertex);

    for (int i = 0; i < numused; i++) {
        vec3 light = lightposn[i].xyz;
        if (!is_directional(lightposn[i])) {
            light = dehomogenize(lightposn[i]);
        }
        light = normalize(light);


        vec3 rel = normalize(light - vertex);// from vertex to light pos

        float specular_cos_theta, intensity_cos_theta;
        vec3 _half = normalize(eye + normalize(light - vertex));
        intensity_cos_theta = zmax(dot(_half, normal));

        vec4 lambertian = intensity_cos_theta * diffuse * lightcolor[i];


        vec4 phong = pow(zmax(dot(_half, eye)), shininess) * specular * lightcolor[i];

        finalcolor += lambertian;
    }

//    finalcolor += ambient + emission;


    // YOUR CODE FOR HW 2 HERE
    // A key part is implementation of the fragment shader

    // Color all pixels black for now, remove this in your implementation!

    fragColor = finalcolor;
}
