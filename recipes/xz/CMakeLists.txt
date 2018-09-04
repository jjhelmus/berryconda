cmake_minimum_required(VERSION 3.0)

project(
    xz 
    VERSION 5.2.1
    LANGUAGES C
)

include(FeatureSummary)

set (SOVERSION 7.1.2)
#option (BUILD_SHARED_LIBS "Build Shared Libraries" ON) 
#option (BUILD_TESTS "Build Tests" ON) 

if (MSVC)
    if (NOT DEFINED ARCH)
        string(TOLOWER ${MSVC_C_ARCHITECTURE_ID} ARCH)
    endif()

    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
    add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE)

    # use boost convention - you cant' get the VC compiler without VS
    if (NOT DEFINED MSVCVER)
        math(EXPR MSVCVER "(${MSVC_VERSION} / 10) - 60")
    endif()
    
    # add the runtime version and target architecture into the DLL name per MS
    # guidelines
    set(MSVC_SHARED_SUFFIX_BASE "-${PROJECT_VERSION_MAJOR}-vc${MSVCVER}-mt-${ARCH}")
    set(CMAKE_SHARED_LIBRARY_SUFFIX "${MSVC_SHARED_SUFFIX_BASE}.dll")

    set(VER_PRODUCTNAME_STR "XZ Utils <http://tukaani.org/xz>")
    set(VER_LEGALCOPYRIGHT_STR "Copyright (c) 2005-2015 Lasse Collin <lasse.collin@tukaani.org>")
    set(VER_STR "${PROJECT_VERSION}")
    set(VER_NUM "${PROJECT_VERSION_MAJOR},${PROJECT_VERSION_MINOR},${PROJECT_VERSION_PATCH},0")

    file(COPY 
            windows/msvc2013/config.h
            windows/msvc2013/unistd.h 
          DESTINATION ${CMAKE_BINARY_DIR}
        )
        
    configure_file(
        lib/getopt.in.h
        ${CMAKE_BINARY_DIR}/getopt.h
         @ONLY
        )
    
endif()

function(add_win32_rc target)
    get_target_property(VER_INTERNALNAME_STR ${target} OUTPUT_NAME)

    if (VER_INTERNALNAME_STR MATCHES "VER_INTERNALNAME_STR-NOTFOUND")
        set(VER_INTERNALNAME_STR "${target}")
    endif()
    get_target_property(VER_FILEDESCRIPTION_STR ${target} DESCRIPTION)

    get_target_property(type ${target} TYPE)
    if (${type} STREQUAL "EXECUTABLE")
        set(VER_FILETYPE "VFT_APP")
        set(VER_ORIGINALFILENAME_STR "${VER_INTERNALNAME_STR}${CMAKE_EXECUTABLE_SUFFIX}")
    elseif (${type} STREQUAL "SHARED_LIBRARY")
        set(VER_FILETYPE "VFT_DLL")
        set(VER_ORIGINALFILENAME_STR "${CMAKE_SHARED_LIBRARY_PREFIX}${VER_INTERNALNAME_STR}${CMAKE_SHARED_LIBRARY_SUFFIX}")
    endif()

    set(OUT_FNAME "${CMAKE_CURRENT_BINARY_DIR}/${VER_INTERNALNAME_STR}.rc")
    configure_file(
         ${CMAKE_SOURCE_DIR}/windows/version.rc.cmakein
         ${OUT_FNAME}
         @ONLY
     )         

    target_sources(${target} PRIVATE ${OUT_FNAME})

endfunction(add_win32_rc)


set(lzma_api
    src/liblzma/api/lzma/base.h
    src/liblzma/api/lzma/bcj.h
    src/liblzma/api/lzma/block.h
    src/liblzma/api/lzma/check.h
    src/liblzma/api/lzma/container.h
    src/liblzma/api/lzma/delta.h
    src/liblzma/api/lzma/filter.h
    src/liblzma/api/lzma/hardware.h
    src/liblzma/api/lzma/index.h
    src/liblzma/api/lzma/index_hash.h
    src/liblzma/api/lzma/lzma12.h
    src/liblzma/api/lzma/stream_flags.h
    src/liblzma/api/lzma/version.h
    src/liblzma/api/lzma/vli.h
    src/liblzma/api/lzma.h
)

set(lzma_src
    #src/liblzma/check/crc64_x86.S
    #src/liblzma/check/crc32_x86.S
    ${lzma_api}
    src/common/mythread.h
    src/common/sysdefs.h
    src/common/tuklib_common.h
    src/common/tuklib_config.h
    src/common/tuklib_cpucores.c
    src/common/tuklib_cpucores.h
    src/common/tuklib_exit.c
    src/common/tuklib_exit.h
    src/common/tuklib_gettext.h
    src/common/tuklib_integer.h
    src/common/tuklib_mbstr.h
    src/common/tuklib_mbstr_fw.c
    src/common/tuklib_mbstr_width.c
    src/common/tuklib_open_stdxxx.c
    src/common/tuklib_open_stdxxx.h
    src/common/tuklib_physmem.c
    src/common/tuklib_physmem.h
    src/common/tuklib_progname.c
    src/common/tuklib_progname.h
    src/liblzma/check/check.c
    src/liblzma/check/check.h
    src/liblzma/check/crc32_fast.c
    src/liblzma/check/crc32_table.c
    src/liblzma/check/crc32_table_le.h
    src/liblzma/check/crc64_fast.c
    src/liblzma/check/crc64_table.c
    src/liblzma/check/crc64_table_le.h
    src/liblzma/check/crc_macros.h
    src/liblzma/check/sha256.c
    src/liblzma/common/alone_decoder.c
    src/liblzma/common/alone_decoder.h
    src/liblzma/common/alone_encoder.c
    src/liblzma/common/auto_decoder.c
    src/liblzma/common/block_buffer_decoder.c
    src/liblzma/common/block_buffer_encoder.c
    src/liblzma/common/block_buffer_encoder.h
    src/liblzma/common/block_decoder.c
    src/liblzma/common/block_decoder.h
    src/liblzma/common/block_encoder.c
    src/liblzma/common/block_encoder.h
    src/liblzma/common/block_header_decoder.c
    src/liblzma/common/block_header_encoder.c
    src/liblzma/common/block_util.c
    src/liblzma/common/common.c
    src/liblzma/common/common.h
    src/liblzma/common/easy_buffer_encoder.c
    src/liblzma/common/easy_decoder_memusage.c
    src/liblzma/common/easy_encoder.c
    src/liblzma/common/easy_encoder_memusage.c
    src/liblzma/common/easy_preset.c
    src/liblzma/common/easy_preset.h
    src/liblzma/common/filter_buffer_decoder.c
    src/liblzma/common/filter_buffer_encoder.c
    src/liblzma/common/filter_common.c
    src/liblzma/common/filter_common.h
    src/liblzma/common/filter_decoder.c
    src/liblzma/common/filter_decoder.h
    src/liblzma/common/filter_encoder.c
    src/liblzma/common/filter_encoder.h
    src/liblzma/common/filter_flags_decoder.c
    src/liblzma/common/filter_flags_encoder.c
    src/liblzma/common/hardware_cputhreads.c
    src/liblzma/common/hardware_physmem.c
    src/liblzma/common/index.c
    src/liblzma/common/index.h
    src/liblzma/common/index_decoder.c
    src/liblzma/common/index_encoder.c
    src/liblzma/common/index_encoder.h
    src/liblzma/common/index_hash.c
    src/liblzma/common/memcmplen.h
    src/liblzma/common/outqueue.c
    src/liblzma/common/outqueue.h
    src/liblzma/common/stream_buffer_decoder.c
    src/liblzma/common/stream_buffer_encoder.c
    src/liblzma/common/stream_decoder.c
    src/liblzma/common/stream_decoder.h
    src/liblzma/common/stream_encoder.c
    src/liblzma/common/stream_encoder_mt.c
    src/liblzma/common/stream_flags_common.c
    src/liblzma/common/stream_flags_common.h
    src/liblzma/common/stream_flags_decoder.c
    src/liblzma/common/stream_flags_encoder.c
    src/liblzma/common/vli_decoder.c
    src/liblzma/common/vli_encoder.c
    src/liblzma/common/vli_size.c
    src/liblzma/delta/delta_common.c
    src/liblzma/delta/delta_common.h
    src/liblzma/delta/delta_decoder.c
    src/liblzma/delta/delta_decoder.h
    src/liblzma/delta/delta_encoder.c
    src/liblzma/delta/delta_encoder.h
    src/liblzma/delta/delta_private.h
    src/liblzma/lz/lz_decoder.c
    src/liblzma/lz/lz_decoder.h
    src/liblzma/lz/lz_encoder.c
    src/liblzma/lz/lz_encoder.h
    src/liblzma/lz/lz_encoder_hash.h
    src/liblzma/lz/lz_encoder_hash_table.h
    src/liblzma/lz/lz_encoder_mf.c
    src/liblzma/lzma/fastpos.h
    src/liblzma/lzma/fastpos_table.c
    src/liblzma/lzma/lzma2_decoder.c
    src/liblzma/lzma/lzma2_decoder.h
    src/liblzma/lzma/lzma2_encoder.c
    src/liblzma/lzma/lzma2_encoder.h
    src/liblzma/lzma/lzma_common.h
    src/liblzma/lzma/lzma_decoder.c
    src/liblzma/lzma/lzma_decoder.h
    src/liblzma/lzma/lzma_encoder.c
    src/liblzma/lzma/lzma_encoder.h
    src/liblzma/lzma/lzma_encoder_optimum_fast.c
    src/liblzma/lzma/lzma_encoder_optimum_normal.c
    src/liblzma/lzma/lzma_encoder_presets.c
    src/liblzma/lzma/lzma_encoder_private.h
    src/liblzma/rangecoder/price.h
    src/liblzma/rangecoder/price_table.c
    src/liblzma/rangecoder/range_common.h
    src/liblzma/rangecoder/range_decoder.h
    src/liblzma/rangecoder/range_encoder.h
    src/liblzma/simple/arm.c
    src/liblzma/simple/armthumb.c
    src/liblzma/simple/ia64.c
    src/liblzma/simple/powerpc.c
    src/liblzma/simple/simple_coder.c
    src/liblzma/simple/simple_coder.h
    src/liblzma/simple/simple_decoder.c
    src/liblzma/simple/simple_decoder.h
    src/liblzma/simple/simple_encoder.c
    src/liblzma/simple/simple_encoder.h
    src/liblzma/simple/simple_private.h
    src/liblzma/simple/sparc.c
    src/liblzma/simple/x86.c
    ${CMAKE_BINARY_DIR}/config.h
)

set(xz_src
	src/common/tuklib_open_stdxxx.c
	src/common/tuklib_open_stdxxx.h
	src/common/tuklib_progname.c
	src/common/tuklib_exit.c
	src/common/tuklib_mbstr_width.c
	src/common/tuklib_mbstr_fw.c
    src/xz/args.c
    src/xz/args.h
    src/xz/coder.c
    src/xz/coder.h
    src/xz/file_io.c
    src/xz/file_io.h
    src/xz/hardware.c
    src/xz/hardware.h
    src/xz/list.c
    src/xz/list.h
    src/xz/main.c
    src/xz/main.h
    src/xz/message.c
    src/xz/message.h
    src/xz/mytime.c
    src/xz/mytime.h
    src/xz/options.c
    src/xz/options.h
    src/xz/private.h
    src/xz/signals.c
    src/xz/signals.h
    src/xz/suffix.c
    src/xz/suffix.h
    src/xz/util.c
    src/xz/util.h
)

set (xzdec_src
    src/xzdec/xzdec.c
	src/common/tuklib_progname.c
	src/common/tuklib_exit.c 
	src/common/tuklib_progname.h
	src/common/tuklib_exit.h
 )

set (lzmainfo_src
    src/lzmainfo/lzmainfo.c
	src/common/tuklib_progname.c
	src/common/tuklib_exit.c 
	src/common/tuklib_progname.h
	src/common/tuklib_exit.h
)

set (get_opt_src
    lib/getopt.c
    lib/getopt1.c
    lib/getopt_int.h
    ${CMAKE_BINARY_DIR}/getopt.h
)

# TODO: generate file!
#lib/getopt.in.h

# lzma shared lib
add_library(lzma SHARED ${lzma_src})
 
set_property(TARGET lzma PROPERTY DESCRIPTION "LZMA data compression dynamic link library")

set_target_properties(lzma PROPERTIES 
          SOVERSION ${PROJECT_VERSION}
          VERSION ${PROJECT_VERSION_MAJOR}
)

target_compile_definitions(lzma
    PRIVATE DLL_EXPORT HAVE_CONFIG_H
)

target_include_directories(lzma
    PRIVATE 
        src/common 
        src/liblzma
        src/liblzma/common 
        src/liblzma/lzma 
        src/liblzma/lz 
        src/liblzma/check 
        src/liblzma/rangecoder 
        src/liblzma/simple 
        src/liblzma/delta
        src/liblzma/api
        ${CMAKE_BINARY_DIR}
    PUBLIC src/liblzma/api
)

add_win32_rc(lzma)

# lzma static lib
add_library(lzma-static STATIC ${lzma_src})
 
target_compile_definitions(lzma
    PRIVATE DLL_EXPORT HAVE_CONFIG_H
)

target_include_directories(lzma-static
    PRIVATE 
        src/common 
        src/liblzma
        src/liblzma/common 
        src/liblzma/lzma 
        src/liblzma/lz 
        src/liblzma/check 
        src/liblzma/rangecoder 
        src/liblzma/simple 
        src/liblzma/delta
        src/liblzma/api
        ${CMAKE_BINARY_DIR}
    PUBLIC src/liblzma/api
)

target_compile_definitions(lzma-static
    PRIVATE LZMA_API_STATIC HAVE_CONFIG_H
)

add_executable(xz-static ${xz_src} ${get_opt_src})

target_compile_definitions(xz-static
    PRIVATE LZMA_API_STATIC HAVE_CONFIG_H
)
target_link_libraries(xz-static lzma-static)

target_include_directories(xz-static
    PRIVATE 
        src/common 
        lib
        ${CMAKE_BINARY_DIR}
)

add_executable(xz ${xz_src} ${get_opt_src})

set_property(TARGET xz PROPERTY DESCRIPTION "xz data compression tool for .xz and .lzma files")

target_compile_definitions(xz
    PRIVATE HAVE_CONFIG_H
)
target_link_libraries(xz lzma)

target_include_directories(xz
    PRIVATE 
        src/common 
        lib
        ${CMAKE_BINARY_DIR}
)

add_win32_rc(xz)

# xzdec tool
add_executable(xzdec ${xzdec_src} ${get_opt_src})

set_property(TARGET xzdec PROPERTY DESCRIPTION "xzdec decompression tool for .xz files")

target_compile_definitions(xzdec
    PRIVATE HAVE_CONFIG_H
)
target_link_libraries(xzdec lzma)

target_include_directories(xzdec
    PRIVATE 
        src/common 
        lib
        ${CMAKE_BINARY_DIR}
)

add_win32_rc(xzdec)

# lzmadec tool
add_executable(lzmadec ${xzdec_src} ${get_opt_src})

set_property(TARGET lzmadec PROPERTY DESCRIPTION "lzmadec decompression tool for .lzma files")

target_compile_definitions(lzmadec
    PRIVATE HAVE_CONFIG_H LZMADEC
)
target_link_libraries(lzmadec lzma)

target_include_directories(lzmadec
    PRIVATE 
        src/common 
        lib
        ${CMAKE_BINARY_DIR}
)

add_win32_rc(lzmadec)

# lzmainfo tool
add_executable(lzmainfo ${lzmainfo_src} ${get_opt_src})

set_property(TARGET lzmainfo PROPERTY DESCRIPTION "lzmainfo shows information about .lzma files")

target_compile_definitions(lzmainfo
    PRIVATE HAVE_CONFIG_H
)
target_link_libraries(lzmainfo lzma)

target_include_directories(lzmainfo
    PRIVATE 
        src/common 
        lib
        ${CMAKE_BINARY_DIR}
)

add_win32_rc(lzmainfo)

install(TARGETS lzma lzma-static xz xz-static xzdec lzmadec lzmainfo EXPORT xz
    RUNTIME DESTINATION "bin"
    ARCHIVE DESTINATION "lib"
    LIBRARY DESTINATION "lib"
    )

install(DIRECTORY src/liblzma/api/ DESTINATION include
    FILES_MATCHING PATTERN "*.h"
)

feature_summary(WHAT ALL)
