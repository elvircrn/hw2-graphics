cmake_minimum_required(VERSION 3.15)

project(graphics)

set(CMAKE_CXX_STANDARD 20)

find_package(GLEW REQUIRED)
find_package(GLUT REQUIRED)
find_package(GLU REQUIRED)
find_package(OpenGL REQUIRED)
find_package(X11 REQUIRED)

add_compile_options(-g -DGL_GLEXT_PROTOTYPES)

add_link_options(-lfreeimage -lGL -lGLEW -lglut)

file(GLOB source_files "*.cpp" "*.h" "src/*.cpp" "include/*.h" "UCSD/*.cpp")

include_directories(include glm-0.9.7.1 UCSD)

add_executable(graphics ${source_files})

set(SHADER_COPY_DIR $<TARGET_FILE_DIR:graphics>/shaders)
set(BASE_COPY_DIR $<TARGET_FILE_DIR:graphics>)

add_custom_command(
        TARGET graphics POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/shaders ${SHADER_COPY_DIR}
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/teapot.obj ${BASE_COPY_DIR}
)
