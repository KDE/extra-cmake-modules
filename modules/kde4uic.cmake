
#using a ui3 file with uic3
IF(KDE3_IMPL)

  EXEC_PROGRAM(${KDE_UIC_EXECUTABLE} ARGS
    -nounload -tr tr2i18n
    -impl ${KDE_UIC_H_FILE}
    ${KDE_UIC_FILE}
    OUTPUT_VARIABLE _uic_CONTENTS
  )
ENDIF(KDE3_IMPL)


IF(KDE3_HEADER)

  EXEC_PROGRAM(${KDE_UIC_EXECUTABLE} ARGS
    -nounload -tr tr2i18n
    ${KDE_UIC_FILE}
    OUTPUT_VARIABLE _uic_CONTENTS
  )
   SET(KDE_UIC_CPP_FILE ${KDE_UIC_H_FILE})
ENDIF(KDE3_HEADER)

# the kde4 branch
IF (KDE4_HEADER)

  EXEC_PROGRAM(${KDE_UIC_EXECUTABLE} ARGS
    -tr tr2i18n
    ${KDE_UIC_FILE}
    OUTPUT_VARIABLE _uic_CONTENTS
  )

   SET(KDE_UIC_CPP_FILE ${KDE_UIC_H_FILE})
ENDIF (KDE4_HEADER)


#replace tr218n("") with QString::null to avoid waring from KLocale
STRING(REGEX REPLACE "tr2i18n\\(\"\"\\)" "QString::null" _uic_CONTENTS "${_uic_CONTENTS}" )
STRING(REGEX REPLACE "tr2i18n\\(\"\", \"\"\\)" "QString::null" _uic_CONTENTS "${_uic_CONTENTS}" )
#replace image15_data with img15_filename to make enable_final work
STRING(REGEX REPLACE "image([0-9]+)_data" "img\\1_${KDE_UIC_BASENAME}" _uic_CONTENTS "${_uic_CONTENTS}")

# workaround which removes the stderr messages from uic, will be removed as soon as
# I switch to EXEC_PROCESS() in the calls above
STRING(REGEX REPLACE "\n[^\n]*uic3: [^\n]+" "" _uic_CONTENTS "${_uic_CONTENTS}" )
STRING(REGEX REPLACE "\n'[^\n]+' [^\n]+" "" _uic_CONTENTS "${_uic_CONTENTS}" )
STRING(REGEX REPLACE "\nWarning: [^\n]+" "" _uic_CONTENTS "${_uic_CONTENTS}" )


FILE(WRITE ${KDE_UIC_CPP_FILE} "#include <kdialog.h>\n#include <klocale.h>\n\n${_uic_CONTENTS}\n")

