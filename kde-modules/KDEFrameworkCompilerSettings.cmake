include(KDECompilerSettings)

add_definitions(-DQT_NO_CAST_TO_ASCII
                -DQT_NO_CAST_FROM_ASCII
                -DQT_NO_URL_CAST_FROM_STRING
                -DQT_NO_CAST_FROM_BYTEARRAY
                -DQT_NO_SIGNALS_SLOTS_KEYWORDS
                -DQT_USE_FAST_OPERATOR_PLUS
                -DQT_USE_QSTRINGBUILDER
               )
if(NOT MSVC)
    # QT_STRICT_ITERATORS breaks MSVC: it tries to link to QTypedArrayData symbols
    # when using foreach. However these symbols don't actually exist
    # not having QT_STRICT_ITERATORS defined fixes this issue.
    # This is fixed by https://codereview.qt-project.org/#change,76311
    # TODO: set QT_STRICT_ITERATORS on all platforms once we depend on Qt 5.3
    add_definitions(-DQT_STRICT_ITERATORS)
endif()
