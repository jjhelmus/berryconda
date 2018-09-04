#!/bin/bash


for USE_WIDEC in false true;
do
    WIDEC_OPT=""
    if [ "${USE_WIDEC}" = true ];
    then
        WIDEC_OPT="--enable-widec"
    fi

    sh ./configure \
	    --prefix=$PREFIX \
	    --without-debug \
	    --without-ada \
	    --without-manpages \
	    --with-shared \
	    --with-pkg-config \
	    --with-pkg-config-libdir=$PREFIX/lib/pkgconfig \
	    --disable-overwrite \
	    --enable-symlinks \
	    --enable-termcap \
	    --enable-pc-files \
	    --with-termlib \
	    $WIDEC_OPT
    make -j ${CPU_COUNT}
    make install
    make clean
    make distclean

    # Provide headers in `$PREFIX/include` and
    # symlink them in `$PREFIX/include/ncurses`
    # and in `$PREFIX/include/ncursesw`.
    HEADERS_DIR="${PREFIX}/include/ncurses"
    if [ "${USE_WIDEC}" = true ];
    then
        HEADERS_DIR="${PREFIX}/include/ncursesw"
    fi
    for HEADER in $(ls $HEADERS_DIR);
    do
        mv "${HEADERS_DIR}/${HEADER}" "${PREFIX}/include/${HEADER}"
        ln -s "${PREFIX}/include/${HEADER}" "${HEADERS_DIR}/${HEADER}"
    done
done
