#!/bin/bash
FILE=/home/cargobuild/.cargo/registry/src/github.com-1ecc6299db9ec823/libc-0.2.40/src/unix/notbsd/linux/musl/b64/powerpc64.rs
today=`date '+%Y_%m_%d__%H_%M_%S'`

while true
do
	if [ -f $FILE ]; then
	    if grep -qi "FIONREAD" $FILE; then
	       echo "File $FILE already patched"
	    else
	       echo "File $FILE exists. Patching..."
	       cd ~/.cargo/registry/src/github*/libc-*; patch -p1 -b < ~/test_cargo/s7_cargo_libc_modrs.patch
	       cd ~/.cargo/registry/src/github*/libc-*; patch -p1 -b < ~/test_cargo/s7_cargo_libc_b32modrs.patch
	       cd ~/.cargo/registry/src/github*/libc-*; patch -p1 -b < ~/test_cargo/s7_cargo_libc_b64modrs.patch
	       cd ~/.cargo/registry/src/github*/libc-*; patch -p1 -b < ~/test_cargo/s7_cargo_libc_b64x86_64.patch
	       cd ~/.cargo/registry/src/github*/libc-*; patch -p1 -b < ~/test_cargo/s8_cargo_libc_b64powerpc64le.patch
	    fi
	    break
	else
	    sleep 1
	fi
done
