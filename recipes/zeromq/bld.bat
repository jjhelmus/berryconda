mkdir build
cd build

set "CFLAGS=%CFLAGS% /DUNITY_EXCLUDE_STDINT_H /DUNITY_POINTER_WIDTH=64"
set "CXXFLAGS=%CXXFLAGS% /DUNITY_EXCLUDE_STDINT_H /DUNITY_POINTER_WIDTH=64"

cmake -G "NMake Makefiles" -D ENABLE_DRAFTS=OFF -D WITH_PERF_TOOL=OFF -D ZMQ_BUILD_TESTS=ON -D ENABLE_CPACK=OFF -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ..
if errorlevel 1 exit 1
nmake install
if errorlevel 1 exit 1

:: Copy of dll and import library on windows (required by pyzmq)

copy /y %LIBRARY_BIN%\libzmq-mt-4*.dll /b %LIBRARY_BIN%\libzmq.dll
if errorlevel 1 exit 1
copy /y %LIBRARY_LIB%\libzmq-mt-4*.lib /b %LIBRARY_LIB%\libzmq.lib
if errorlevel 1 exit 1

.\bin\test_ancillaries
.\bin\test_atomics
.\bin\test_base85
.\bin\test_bind_after_connect_tcp
.\bin\test_bind_src_address
.\bin\test_capabilities
.\bin\test_conflate
.\bin\test_connect_resolve
.\bin\test_connect_rid
.\bin\test_ctx_destroy
.\bin\test_ctx_options
.\bin\test_diffserv
.\bin\test_disconnect_inproc
REM .\bin\test_filter_ipc
REM .\bin\test_fork
REM .\bin\test_getsockopt_memset
.\bin\test_heartbeats
.\bin\test_hwm
.\bin\test_hwm_pubsub
.\bin\test_immediate
.\bin\test_inproc_connect
.\bin\test_invalid_rep
.\bin\test_iov
REM .\bin\test_ipc_wildcard
.\bin\test_issue_566
.\bin\test_last_endpoint
.\bin\test_many_sockets
.\bin\test_metadata
REM .\bin\test_monitor
.\bin\test_msg_ffn
.\bin\test_msg_flags
.\bin\test_pair_inproc
REM .\bin\test_pair_ipc
.\bin\test_pair_tcp
.\bin\test_probe_router
REM .\bin\test_proxy
REM .\bin\test_proxy_single_socket
REM .\bin\test_proxy_terminate
.\bin\test_pub_invert_matching
.\bin\test_req_correlate
.\bin\test_req_relaxed
.\bin\test_reqrep_device
.\bin\test_reqrep_inproc
REM .\bin\test_reqrep_ipc
.\bin\test_reqrep_tcp
.\bin\test_router_handover
.\bin\test_router_mandatory
REM .\bin\test_router_mandatory_hwm
.\bin\test_security_null
.\bin\test_security_plain
.\bin\test_setsockopt
.\bin\test_sockopt_hwm
.\bin\test_sodium
.\bin\test_spec_dealer
.\bin\test_spec_pushpull
.\bin\test_spec_rep
.\bin\test_spec_req
.\bin\test_spec_router
.\bin\test_srcfd
.\bin\test_stream
.\bin\test_stream_disconnect
.\bin\test_stream_empty
REM .\bin\test_stream_exceeds_buffer
.\bin\test_stream_timeout
.\bin\test_sub_forward
.\bin\test_term_endpoint
.\bin\test_timeo
.\bin\test_unbind_inproc
.\bin\test_unbind_wildcard
REM .\bin\test_use_fd_ipc
.\bin\test_use_fd_tcp
.\bin\test_xpub_manual
.\bin\test_xpub_nodrop
.\bin\test_xpub_welcome_msg
REM .\bin\test_zmq_poll_fd

REM .\bin\test_security_curve
REM .\bin\test_shutdown_stress
REM .\bin\test_system
REM .\bin\test_thread_safe
