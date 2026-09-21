# ====== fetch_content_cpp_tools.cmake
# ====================================
#       explanation
# ====================================
# Download and import cpp_tools repository by using FetchContent.
# The target project will be added through FetchContent_MakeAvailable().

# ====================================
#       parameters
# ====================================
# GIT_TAG        : Git branch / tag / commit hash.
# IS_SILENT_MODE : Disable print output.

# ====================================
#       parameter default value
# ====================================
# GIT_TAG        = main
# IS_SILENT_MODE = FALSE

# ====================================
#       return variables
# ====================================
# RETURN_VAR_PREFIX = FETCH_CONTENT_CPP_TOOLS
# ${RETURN_VAR_PREFIX}_REPOSITORY_URL
# ${RETURN_VAR_PREFIX}_GIT_TAG
# ${RETURN_VAR_PREFIX}_SOURCE_DIR
# ${RETURN_VAR_PREFIX}_BINARY_DIR


function(fetch_content_cpp_tools)

    # ====================================
    #       pre-variables
    # ====================================
    set(
        this_function_name
        "FETCH_CONTENT_CPP_TOOLS"
    )


    # ====================================
    #       includes
    # ====================================
    include(FetchContent)


    # ====================================
    #       parameters
    # ====================================
    set(options)

    set(oneValueArgs
        GIT_TAG
        IS_SILENT_MODE
    )

    set(multiValueArgs)


    cmake_parse_arguments(
        ARG
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGV}
    )


    # ====================================
    #       parameter default value
    # ====================================
    if(NOT DEFINED ARG_GIT_TAG)
        set(ARG_GIT_TAG "main")
    endif()

    if(NOT DEFINED ARG_IS_SILENT_MODE)
        set(ARG_IS_SILENT_MODE FALSE)
    endif()


    # ====================================
    #       Logic
    # ====================================
    set(
        repository_url
        "https://github.com/alims-engineering/cpp_tools.git"
    )


    FetchContent_Declare(
        cpp_tools
        GIT_REPOSITORY "${repository_url}"
        GIT_TAG        "${ARG_GIT_TAG}"
    )

    FetchContent_MakeAvailable(cpp_tools)

    FetchContent_GetProperties(cpp_tools)


    # ====================================
    #       return variables
    # ====================================
    set(RETURN_VAR_PREFIX "${this_function_name}")

    set(
        ${RETURN_VAR_PREFIX}_REPOSITORY_URL
        "${repository_url}"
    )

    set(
        ${RETURN_VAR_PREFIX}_GIT_TAG
        "${ARG_GIT_TAG}"
    )

    set(
        ${RETURN_VAR_PREFIX}_SOURCE_DIR
        "${cpp_tools_SOURCE_DIR}"
    )

    set(
        ${RETURN_VAR_PREFIX}_BINARY_DIR
        "${cpp_tools_BINARY_DIR}"
    )


    # ====================================
    #       print return variables
    # ====================================
    if(NOT ARG_IS_SILENT_MODE)

        message(STATUS "")
        message(
            STATUS
            "[${RETURN_VAR_PREFIX} - print return variables]"
        )

        foreach(temp_print_return_var IN ITEMS
            "${RETURN_VAR_PREFIX}_REPOSITORY_URL"
            "${RETURN_VAR_PREFIX}_GIT_TAG"
            "${RETURN_VAR_PREFIX}_SOURCE_DIR"
            "${RETURN_VAR_PREFIX}_BINARY_DIR"
        )
            message(
                STATUS
                "${temp_print_return_var} = ${${temp_print_return_var}}"
            )
        endforeach()

    endif()


    # ====================================
    #       return variables
    # ====================================
    set(
        ${RETURN_VAR_PREFIX}_REPOSITORY_URL
        "${repository_url}"
        PARENT_SCOPE
    )

    set(
        ${RETURN_VAR_PREFIX}_GIT_TAG
        "${ARG_GIT_TAG}"
        PARENT_SCOPE
    )

    set(
        ${RETURN_VAR_PREFIX}_SOURCE_DIR
        "${cpp_tools_SOURCE_DIR}"
        PARENT_SCOPE
    )

    set(
        ${RETURN_VAR_PREFIX}_BINARY_DIR
        "${cpp_tools_BINARY_DIR}"
        PARENT_SCOPE
    )

endfunction()