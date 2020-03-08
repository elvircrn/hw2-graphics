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

const int numLights = 10;
uniform bool enablelighting;// are we lighting at all (global).
uniform vec4 lightposn[numLights];// positions of lights
uniform vec4 lightcolor[numLights];// colors of lights
uniform int numused;// number of lights used

// Now, set the material parameters.
// I use ambient, diffuse, specular, shininess. 
// But, the ambient is just additive and doesn't multiply the lights.  

uniform vec4 ambient;
uniform vec4 diffuse;
uniform vec4 specular;
uniform vec4 emission;
uniform float shininess;

vec3 dehomogenize(vec4 pos) {
    return vec3(pos.x / pos.w, pos.y / pos.w, pos.z / pos.w);
}


void main (void)
{
    vec4 mv_myvertex = modelview * myvertex;
    vec4 mv_hom_mynormal = modelview * vec4(mynormal, 1);

    vec4 finalcolor = vec4(0, 0, 0, 1);
    for (int i = 0; i < numused; i++) {
        vec4 mv_lightpos = modelview * lightposn[i];

        vec3 lightpos = dehomogenize(mv_lightpos);
        vec3 ver = dehomogenize(mv_myvertex);
        vec3 rel = lightpos - ver;
        vec3 dehom_norm = dehomogenize(mv_hom_mynormal);
        vec3 final = ver +  2 * dehom_norm - lightpos;

        float specular_cos_theta;
        specular_cos_theta = dot(ver, final) / (length(ver) * length(dehom_norm));
        float intensity_cos_theta;
        intensity_cos_theta = dot(dehom_norm, final) / (length(dehom_norm) * length(dehom_norm));

        finalcolor += intensity_cos_theta * lightcolor[i];


    }




    // YOUR CODE FOR HW 2 HERE
    // A key part is implementation of the fragment shader

    // Color all pixels black for now, remove this in your implementation!

    fragColor = finalcolor * 100.0;
}
