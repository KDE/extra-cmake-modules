
#using a ui3 file with uic3
IF(KDE3)

  EXEC_PROGRAM(${KDE_UIC_EXECUTABLE} ARGS
    -nounload -tr tr2i18n
    -impl ${KDE_UIC_H_FILE}
    ${KDE_UIC_FILE}
    OUTPUT_VARIABLE _uic_CONTENTS
  )

# the kde4 branch
ELSE(KDE3)

  EXEC_PROGRAM(${KDE_UIC_EXECUTABLE} ARGS
    -tr tr2i18n
    -L ${KDE_UIC_PLUGIN_DIR}
    -impl ${KDE_UIC_H_FILE}
    ${KDE_UIC_FILE}
    OUTPUT_VARIABLE _uic_CONTENTS
  )

ENDIF(KDE3)


#replace tr218n("") with QString::null to avoid waring from KLocale
STRING(REGEX REPLACE "tr2i18n\\(\"\"\\)" "QString::null" _uic_CONTENTS "${_uic_CONTENTS}" )
STRING(REGEX REPLACE "tr2i18n\\(\"\", \"\"\\)" "QString::null" _uic_CONTENTS "${_uic_CONTENTS}" )

#replace image15_data with img15_filename to make enable_final work
STRING(REGEX REPLACE "image([0-9]+)_data" "img\\1_${KDE_UIC_BASENAME}" _uic_CONTENTS "${_uic_CONTENTS}")

FILE(WRITE ${KDE_UIC_CPP_FILE} "#include <kdialog.h>\n#include <klocale.h>\n\n")
FILE(APPEND ${KDE_UIC_CPP_FILE} "${_uic_CONTENTS}")

