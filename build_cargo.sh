# Usage:
# $ sudo docker run --name alpine_cargobuild  -it alpine:3.7
# $ sudo docker exec -it alpine_cargobuild  /bin/bash
# # inside the docker container
# modify /etc/apk/repositories to point to edge
# apk update
# apk upgrade
# Copy the contents of this directory to /root/test_cargo/.
# as root, execute /root/test_cargo/build_cargo.sh
# TODOS:

set -ex

user=cargobuild
sourcedir=/root/test_cargo

as_user() {
    su -c 'bash -c "'"${@}"'"' $user
}

mk_user() {
    adduser -D $user
}

fetch_cargo() {
    cd /home/$user; rm -rf /home/$user/test_cargo; cp -r $sourcedir /home/$user/.; chown -R cargobuild:cargobuild /home/$user/test_cargo;
    cd /home/$user; rm -rf .cargo;
    cd /home/$user; rm -rf /home/$user/cargo*; tar -xzf /home/$user/test_cargo/0.25.0.tar.gz; chown -R $user:$user /home/$user/cargo* 
    cd /home/$user; mv cargo-0.25.0 cargo; chown -R $user:$user /home/$user/cargo
}

install_deps() {
        apk add alpine-sdk bash cmake curl-dev libgit2-dev libssh2-dev libressl-dev python2 zlib-dev llvm4-libs libssl1.0 libcrypto1.0 
        apk add --allow-untrusted $sourcedir/rust-stdlib-1.24.1-r0.apk $sourcedir/rust-1.24.1-r0.apk $sourcedir/cargo-0.25.0-r1.apk
}

apply_patches() {
    as_user "
cd ~/cargo
pwd
cp ~/test_cargo/Cargo.lock . 
patch -p1 -b < ~/test_cargo/tests-ignore-wasm32_final_outputs.patch 
patch -p1 -b < ~/test_cargo/tests-ignore-ssh_something_happens.patch 
patch -p1 -b < ~/test_cargo/tests-ignore-rustdoc.patch 
patch -p1 -b < ~/test_cargo/tests-fix-build-auth-http_auth_offered.patch 
"
}

mk_cargo() {
    dir=$(pwd)
    as_user "
cd ~/cargo
cargo clean
~/test_cargo/patch_cargo.sh &
export LIBGIT2_SYS_USE_PKG_CONFIG=1; cargo build --locked --release --verbose -j1 >> build.log 2>&1
export LIBGIT2_SYS_USE_PKG_CONFIG=1; cargo test --no-run --locked --release --verbose -j1 >> buildtests.log 2>&1
"
}

main() {
#   mk_user
   install_deps
   fetch_cargo
   apply_patches
   mk_cargo
}

main
