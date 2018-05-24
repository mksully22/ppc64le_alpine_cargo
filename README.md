# Compiling Cargo for Alpine

This repository contains the source, patches, scripts, and bootstrap packages (Cargo and Rustc) need to compile cargo on Alpine.

## Instructions
1. Create a docker container with Alpine 

    sudo docker run --name alpine_cargobuild  -it alpine:3.7
    
2. Enter alpine_cargobuild container

    sudo docker exec -it alpine_cargobuild  /bin/sh
    
3. Inside the alpine_cargobuild docker container:

   a. Modify /etc/apk/repositories to point to edge
   
   b. apk update; apk upgrade
   
   c. Copy the contents of this project to /root/test_cargo  directory
   
   d. as root, /root/test_cargo/build_cargo.sh
