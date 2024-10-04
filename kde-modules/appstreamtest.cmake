file(GLOB install_done "${INSTALL_FILES}")
if (install_done)
    file(READ "${INSTALL_FILES}" out)
    string(REPLACE "\n" ";" out "${out}")
else()
    message("Not installed yet, skipping")
    set(out "")
endif()

set(metadatafiles)
foreach(file IN LISTS out)
    if(NOT (file MATCHES ".+\\.appdata.xml" OR file MATCHES ".+\\.metainfo.xml"))
        continue()
    endif()

    if(EXISTS ${file})
        list(APPEND metadatafiles ${file})
    else()
        message(WARNING "Could not find ${file}")
    endif()
endforeach()

if(metadatafiles)
    set(appstreamcliout "")
    execute_process(COMMAND ${APPSTREAMCLI} validate --no-net ${metadatafiles}
        ERROR_VARIABLE appstreamcliout
        OUTPUT_VARIABLE appstreamcliout
        RESULT_VARIABLE result
    )

    if(result EQUAL 0)
        set(msgType STATUS)
    else()
        set(msgType FATAL_ERROR)
    endif()
    message(${msgType} ${appstreamcliout})
endif()
