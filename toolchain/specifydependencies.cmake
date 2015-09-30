file(READ "${TARGET_DIR}/CMakeFiles/${TARGET_NAME}.dir/link.txt" out)

string(FIND "${out}" "-o ${TARGET_NAME}" POS) #we trim the initial arguments, we want the ones in the end. we find the target
string(SUBSTRING "${out}" ${POS} -1 out) #we
string(REGEX MATCHALL " /.+\\.so" outout "${out}")
string(STRIP "${outout}" outout)
string(REPLACE " /" ";/" outout "${outout}")

set(extralibs)
foreach(lib IN LISTS outout) #now we filter Qt5 libraries, because Qt wants to take care about these itself
    if(NOT ${lib} MATCHES ".*/libQt5.*")
        if(extralibs)
            set(extralibs "${extralibs},${lib}")
        else()
            set(extralibs "${lib}")
        endif()
    endif()
endforeach()

file(READ "${INPUT_FILE}" CONTENTS)
string(REPLACE "##EXTRALIBS##" "${extralibs}" NEWCONTENTS "${CONTENTS}")
file(WRITE "${OUTPUT_FILE}" ${NEWCONTENTS})
