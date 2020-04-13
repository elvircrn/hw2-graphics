// Transform.cpp: implementation of the Transform class.

// Note: when you construct a matrix using mat4() or mat3(), it will be COLUMN-MAJOR
// Keep this in mind in readfile.cpp and display.cpp
// See FAQ for more details or if you're having problems.

#include "Transform.h"

// Helper rotation function.  Please implement this.  
mat3 Transform::rotate(float degrees, const vec3 &axis) {
  // YOUR CODE FOR HW1 HERE
  float radians = glm::radians(degrees);
  mat3 axisCross = glm::transpose(mat3{
      {0, -axis[2], axis[1]},
      {axis[2], 0, -axis[0]},
      {-axis[1], axis[0], 0}});
  mat3 I(1);

  return (I + (float) glm::sin(radians) * axisCross)
      + (1.0f - (float) glm::cos(radians)) * (axisCross * axisCross);
}

// Transforms the camera left around the "crystal ball" interface
void Transform::left(float degrees, vec3 &eye, vec3 &up) {
  eye = rotate(degrees, up) * eye;
}

// Transforms the camera up around the "crystal ball" interface
void Transform::up(float degrees, vec3 &eye, vec3 &up) {
  vec3 rotationAxis = glm::normalize(glm::cross(up, eye));
  up = rotate(degrees, rotationAxis) * up;
  eye = rotate(degrees, rotationAxis) * eye;
}

// Your implementation of the glm::lookAt matrixg
mat4 Transform::lookAt(const vec3 &eye, const vec3 &center, const vec3 &up) {
  const glm::vec3 &centerEye = eye - center;
  auto z = glm::normalize(centerEye);
  auto x = glm::normalize(glm::cross(up, z));
  auto y = glm::normalize(glm::cross(z, x));
  return glm::transpose(mat4{{x.x, y.x, z.x, -glm::dot(eye, x)},
                             {x.y, y.y, z.y, -glm::dot(eye, y)},
                             {x.z, y.z, z.z, -glm::dot(eye, z)},
                             {0, 0, 0, 1}});
}

mat4 Transform::perspective(float fovy, float aspect, float zNear, float zFar) {
  // YOUR CODE FOR HW2 HERE - done
  // New, to implement the perspective transform as well.

  float rad_fovy = glm::radians(fovy);
  float focal = 1.0f / glm::tan(rad_fovy / 2.0f);
  // Based on https://www.mathematik.uni-marburg.de/~thormae/lectures/graphics1/graphics_6_1_eng_web.html#19
  return glm::transpose(mat4{
      {focal / aspect, 0, 0, 0},
      {0, focal, 0, 0},
      {0, 0, (zFar + zNear) / (zNear - zFar), (2 * zFar * zNear) / (zNear - zFar)},
      {0, 0, -1, 0}
  });
}

mat4 Transform::scale(const float &sx, const float &sy, const float &sz) {
  mat4 ret;
  // YOUR CODE FOR HW2 HERE - done
  // Implement scaling 
  return mat4{
      {sx, 0, 0, 0},
      {0, sy, 0, 0},
      {0, 0, sz, 0},
      {0, 0, 0, 1}
  };
}

mat4 Transform::translate(const float &tx, const float &ty, const float &tz) {
  return glm::transpose(mat4{
      {1, 0, 0, tx},
      {0, 1, 0, ty},
      {0, 0, 1, tz},
      {0, 0, 0, 1}
  });
}

// To normalize the up direction and construct a coordinate frame.  
// As discussed in the lecture.  May be relevant to create a properly 
// orthogonal and normalized up. 
// This function is provided as a helper, in case you want to use it. 
// Using this function (in readfile.cpp or display.cpp) is optional.  

vec3 Transform::upvector(const vec3 &up, const vec3 & zvec)
{
  vec3 x = glm::cross(up,zvec);
  vec3 y = glm::cross(zvec,x);
  vec3 ret = glm::normalize(y);
  return ret;
}

Transform::Transform() {

}

Transform::~Transform() {

}
