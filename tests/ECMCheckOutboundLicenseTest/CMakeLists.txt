set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)
set(CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/../../modules
    ${CMAKE_CURRENT_SOURCE_DIR}/../../find-modules
)

include(ECMCheckOutboundLicense)

# check relative and absolute input paths
ecm_check_outbound_license(
LICENSES LGPL-2.1-only
TEST_NAME absolute-path-handling
FILES
    testdata/BSD-2-Clause.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/testdata/LGPL-2.1-or-later.cpp
)

# check test case generation without TEST_NAME statement
ecm_check_outbound_license(
LICENSES LGPL-2.1-only
FILES
    testdata/BSD-2-Clause.cpp
)

# check multi license case
ecm_check_outbound_license(
LICENSES LGPL-2.1-only GPL-3.0-only
TEST_NAME multiple-licenses
FILES
    testdata/BSD-2-Clause.cpp
)


# check for valid LGPL-2.1-only
ecm_check_outbound_license(
LICENSES LGPL-2.1-only
TEST_NAME valid-LGPL-2.1-only
FILES
    testdata/BSD-2-Clause.cpp
    testdata/LGPL-2.1-or-later.cpp
)

# check for valid LGPL-3.0-only
ecm_check_outbound_license(
LICENSES LGPL-3.0-only
TEST_NAME valid-LGPL-3.0-only
FILES
    testdata/BSD-2-Clause.cpp
    testdata/LGPL-2.1-or-later.cpp
    testdata/LGPL-3.0-only.cpp
)

# check for valid GPL-2.0-only
ecm_check_outbound_license(
LICENSES GPL-2.0-only
TEST_NAME valid-GPL-2.0-only
FILES
    testdata/BSD-2-Clause.cpp
    testdata/LGPL-2.1-or-later.cpp
    testdata/GPL-2.0-only.cpp
)

# check for valid GPL-3.0-only
ecm_check_outbound_license(
LICENSES GPL-3.0-only
TEST_NAME valid-GPL-3.0-only
FILES
    testdata/BSD-2-Clause.cpp
    testdata/LGPL-2.1-or-later.cpp
    testdata/LGPL-3.0-only.cpp
    testdata/GPL-3.0-only.cpp
)

# check for invalid GPL-3.0-only
ecm_check_outbound_license(
LICENSES LGPL-2.1-only
TEST_NAME invalid-LGPL-2.1-only
FILES
    testdata/LGPL-2.0-only.cpp
    testdata/GPL-3.0-only.cpp
WILL_FAIL
)

# check for invalid GPL-3.0-only
ecm_check_outbound_license(
LICENSES GPL-3.0-only
TEST_NAME invalid-GPL-3.0-only
FILES
    testdata/GPL-2.0-only.cpp
    testdata/GPL-3.0-only.cpp
WILL_FAIL
)
