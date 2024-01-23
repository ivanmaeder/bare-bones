FROM alpine:3.19.0 AS with_libraries

RUN apk update && \
    apk upgrade && \
    apk add bash bison build-base curl git make texinfo

###

FROM with_libraries AS with_source

WORKDIR /lib/src

RUN curl -L https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.gz | tar -xzv && \
    curl -L https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.gz | tar -xzv && \
    curl -L https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.gz | tar -xzv && \
    curl -L https://ftp.gnu.org/gnu/gdb/gdb-14.1.tar.gz | tar -xzv && \
    curl -L https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.gz | tar -xzv && \
    curl -L https://ftp.gnu.org/gnu/mpc/mpc-1.3.0.tar.gz | tar -xzv && \
    curl -L https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.tar.gz | tar -xzv && \
    curl -L https://github.com/westes/flex/files/981163/flex-2.6.4.tar.gz | tar -xzv

###

FROM with_source AS with_binutils

ENV PREFIX="$HOME/opt/cross" \
    TARGET=i686-elf

RUN mkdir build-binutils && \
    cd build-binutils && \
    ../binutils-2.41/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror && \
    make && \
    make install && \
    cd ..

###

# FROM with_binutils AS with_gdb
# 
# RUN mkdir build-gdb && \
#     cd build-gdb && \
#     ../gdb-14.1/configure --target=$TARGET --prefix="$PREFIX" --disable-werror && \
#     make all-gdb && \
#     make install-gdb && \
#     cd ..
# 

###

FROM with_binutils AS with_gcc

RUN cd gcc-13.2.0 && \
    ./contrib/download_prerequisites && \
    cd ..

RUN mkdir build-gcc && \
    cd build-gcc && \
    ../gcc-13.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers && \
    make all-gcc && \
    make all-target-libgcc && \
    make install-gcc && \
    make install-target-libgcc && \
    cd ..

ENV PATH="$PREFIX/bin:$PATH"

WORKDIR /tmp