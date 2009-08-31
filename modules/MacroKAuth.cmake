
execute_process(COMMAND "${KDE4_KDECONFIG_EXECUTABLE}" --path data --locate kauth/dbus_service.stub OUTPUT_VARIABLE KDE4_KAUTH_DBUS_SERVICE_STUB ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
message(STATUS "KAuth: DBus service stub file found at ${KDE4_KAUTH_DBUS_SERVICE_STUB}")
execute_process(COMMAND "${KDE4_KDECONFIG_EXECUTABLE}" --path data --locate kauth/dbus_policy.stub OUTPUT_VARIABLE KDE4_KAUTH_DBUS_POLICY_STUB ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
message(STATUS "KAuth: DBus policy stub file found at ${KDE4_KAUTH_DBUS_POLICY_STUB}")
execute_process(COMMAND "${KDE4_KDECONFIG_EXECUTABLE}" --path libexec --locate kauth-policy-gen OUTPUT_VARIABLE KDE4_KAUTH_POLICY_GEN ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)

set( KDE4_KAUTH_DBUS_POLICY_STUB ${DATA_INSTALL_DIR}/kauth/dbus_policy.stub)
set( KDE4_KAUTH_DBUS_SERVICE_STUB ${DATA_INSTALL_DIR}/kauth/dbus_service.stub)
set( KDE4_KAUTH_POLICY_GEN ${LIBEXEC_INSTALL_DIR}/kauth-policy-gen)

if(NOT KDE4_KAUTH_DBUS_SERVICE_STUB)
	message(FATAL_ERROR "DBus service stub file couldn't be found (required by kde4_auth_add_helper macro)")
endif(NOT KDE4_KAUTH_DBUS_SERVICE_STUB)

if(NOT KDE4_KAUTH_DBUS_POLICY_STUB)
	message(FATAL_ERROR "DBus policy stub file couldn't be found (required by kde4_auth_add_helper macro)")
endif(NOT KDE4_KAUTH_DBUS_POLICY_STUB)

if(NOT KDE4_KAUTH_POLICY_GEN)
	message(FATAL_ERROR "KAuth policy generator tool couldn't be found (required by kde4_auth_register_actions macro)")
endif(NOT KDE4_KAUTH_POLICY_GEN)

macro(kde4_auth_add_helper _HELPER_TARGET _HELPER_ID _HELPER_USER)
    
    set(HELPER_ID ${_HELPER_ID})
    set(HELPER_TARGET ${_HELPER_TARGET})
    set(HELPER_USER ${_HELPER_USER})
    
    kde4_add_executable(${HELPER_TARGET} ${ARGN})
    target_link_libraries(${HELPER_TARGET} ${KDE4_KDECORE_LIBS})
    install(TARGETS ${HELPER_TARGET} DESTINATION ${LIBEXEC_INSTALL_DIR})
    
    configure_file(${KDE4_KAUTH_DBUS_POLICY_STUB} ${CMAKE_CURRENT_BINARY_DIR}/${HELPER_ID}.conf)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${HELPER_ID}.conf DESTINATION /etc/dbus-1/system.d/)

    configure_file(${KDE4_KAUTH_DBUS_SERVICE_STUB} ${CMAKE_CURRENT_BINARY_DIR}/${HELPER_ID}.service)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${HELPER_ID}.service DESTINATION /usr/share/dbus-1/system-services )
    

endmacro(kde4_auth_add_helper)

macro(kde4_auth_register_actions HELPER_ID ACTIONS_FILE)

if(APPLE)
    install(CODE "execute_process(COMMAND ${KDE4_KAUTH_POLICY_GEN} ${ACTIONS_FILE} WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})")
elseif(UNIX)
    set(_output ${CMAKE_CURRENT_BINARY_DIR}/${HELPER_ID}.policy)
    get_filename_component(_input ${ACTIONS_FILE} ABSOLUTE)
    
    add_custom_command(OUTPUT ${_output} 
                       COMMAND ${KDE4_KAUTH_POLICY_GEN} ${_input} > ${_output} 
                       MAIN_DEPENDENCY ${_input}
                       WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                       COMMENT "Generating ${HELPER_ID}.policy")
    add_custom_target("actions for ${HELPER_ID}" ALL DEPENDS ${_output})

    if (POLKITQT_FOUND)
    install(FILES ${_output} DESTINATION ${POLICY_FILES_INSTALL_DIR})
    endif (POLKITQT_FOUND)
endif()

endmacro(kde4_auth_register_actions)
