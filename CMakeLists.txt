cmake_minimum_required(VERSION 3.21)
project(cmake_tools NONE)


# ====================================
#   Param
# ====================================

option(
    CMAKE_TOOLS_QUIET
    "Suppress cmake_tools module loading messages"
    OFF
)


# ====================================
#   variable
# ====================================

set(CMAKE_TOOLS_ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}")
set(CMAKE_TOOLS_CMAKE_DIR "${CMAKE_TOOLS_ROOT_DIR}/cmake")


# ====================================
#   Logic - Module Discovery & Loading
# ====================================

# Recursively discover all .cmake files
file(GLOB_RECURSE CMAKE_TOOLS_SRC
    "${CMAKE_TOOLS_CMAKE_DIR}/*.cmake"
)

# Exclude specific directories and files from loading
set(EXCLUDE_PATTERNS
#    ".*/test/.*"
    ".*/tests/.*"
    ".*/deprecated/.*"
    ".*/internal/.*"
    ".*/example/.*"
    ".*/cmake_tools\\.cmake$"
    ".*/cmake_tools_init\\.cmake$"
    ".*/cmake_tools_version\\.cmake$"
)

# Apply exclusion rules
foreach(pattern ${EXCLUDE_PATTERNS})
    list(FILTER CMAKE_TOOLS_SRC EXCLUDE REGEX ${pattern})
endforeach()

# Sort modules by path to ensure a deterministic loading order
list(SORT CMAKE_TOOLS_SRC)


# Load each discovered module
foreach(src ${CMAKE_TOOLS_SRC})
    include(${src})

    if(NOT CMAKE_TOOLS_QUIET)
        message(STATUS "[cmake_tools] Loaded: ${src}")
    endif()
endforeach()

# Report the total number of loaded modules
list(LENGTH CMAKE_TOOLS_SRC CMAKE_TOOLS_SRC_LENGTH)

if(NOT CMAKE_TOOLS_QUIET)
    message(STATUS
        "[cmake_tools] Total modules loaded: ${CMAKE_TOOLS_SRC_LENGTH}"
    )
endif()