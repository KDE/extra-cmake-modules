
#using a ui3 file with uic3
IF(KDE3_IMPL)

  EXECUTE_PROCESS(COMMAND ${KDE_UIC_EXECUTABLE}
    -nounload -tr tr2i18n
    -impl ${KDE_UIC_H_FILE}
    ${KDE_UIC_FILE}
    OUTPUT_VARIABLE _uic_CONTENTS
    ERROR_QUIET
  )
ENDIF(KDE3_IMPL)


IF(KDE3_HEADER)

  EXECUTE_PROCESS(COMMAND ${KDE_UIC_EXECUTABLE}
    -nounload -tr tr2i18n
    ${KDE_UIC_FILE}
    OUTPUT_VARIABLE _uic_CONTENTS
    ERROR_QUIET
  )
   SET(KDE_UIC_CPP_FILE ${KDE_UIC_H_FILE})
ENDIF(KDE3_HEADER)

# the kde4 branch
IF (KDE4_HEADER)

  EXECUTE_PROCESS(COMMAND ${KDE_UIC_EXECUTABLE}
    -tr tr2i18n
    ${KDE_UIC_FILE}
    OUTPUT_VARIABLE _uic_CONTENTS
    ERROR_QUIET
  )

   SET(KDE_UIC_CPP_FILE ${KDE_UIC_H_FILE})
ENDIF (KDE4_HEADER)


#replace tr218n("") with QString::null to avoid waring from KLocale
STRING(REGEX REPLACE "tr2i18n\\(\"\"\\)" "QString::null" _uic_CONTENTS "${_uic_CONTENTS}" )
STRING(REGEX REPLACE "tr2i18n\\(\"\", \"\"\\)" "QString::null" _uic_CONTENTS "${_uic_CONTENTS}" )
#replace image15_data with img15_filename to make enable_final work
STRING(REGEX REPLACE "image([0-9]+)_data" "img\\1_${KDE_UIC_BASENAME}" _uic_CONTENTS "${_uic_CONTENTS}")

FILE(WRITE ${KDE_UIC_CPP_FILE} "#include <kdialog.h>\n#include <klocale.h>\n\n${_uic_CONTENTS}\n")

