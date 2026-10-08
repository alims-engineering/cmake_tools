# ====== create_targets_recursively.cmake
# ====================================
#       explanation
# ====================================
# Recursively create targets based on the directory hierarchy.
#
# Naming of targets:
#   - ${TARGET_NAME}_${LOWER_CASE_TARGET_TYPE}
#   - ${TARGET_NAME}_${SUB_FOLDER_NAME}_${LOWER_CASE_TARGET_TYPE}
#   - ${TARGET_NAME}_${SUB_FOLDER_NAME}_${SUB_SUB_FOLDER_NAME}_${LOWER_CASE_TARGET_TYPE}
#   - ...
#
# Example:
#
# cpp_tools/
# ??? file/
# ?   ??? functions/
# ??? math/
#     ??? functions/
#
# TARGET_NAME = cpp_tools
# TARGET_TYPE = OBJECT
#
# Generates:
#
#   cpp_tools_object
#   cpp_tools_file_object
#   cpp_tools_file_functions_object
#   cpp_tools_math_object
#   cpp_tools_math_functions_object


# ====================================
#       parameters
# ====================================
# TARGET_NAME       : Root target name.
# TARGET_TYPE       : Target type.
#                     Supported values:
#                     INTERFACE, STATIC, OBJECT, SHARED.
#
# SEARCH_PATHS      : Paths or path patterns to search recursively.
# FILE_PATTERNS     : File patterns to include.
# IS_SILENT_MODE    : Disable print output.


# ====================================
#       parameter default value
# ====================================
# TARGET_TYPE       = OBJECT
# SEARCH_PATHS      = ${CMAKE_SOURCE_DIR}
# FILE_PATTERNS     = *.c, *.cpp
# IS_SILENT_MODE    = FALSE


# ====================================
#       return variables
# ====================================
# RETURN_VAR_PREFIX = CREATE_TARGETS_RECURSIVELY
#
# ${RETURN_VAR_PREFIX}_TARGET_NAME_LIST


function(create_targets_recursively)

    # ====================================
    #       pre-variables
    # ====================================
    set(this_function_name "CREATE_TARGETS_RECURSIVELY")


    # ====================================
    #       parameters
    # ====================================
    set(options
        IS_SILENT_MODE
    )

    set(oneValueArgs
        TARGET_NAME
        TARGET_TYPE
    )

    set(multiValueArgs
        SEARCH_PATHS
        FILE_PATTERNS
    )

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
    if(NOT DEFINED ARG_TARGET_TYPE)

        set(
            ARG_TARGET_TYPE
            "OBJECT"
        )

    endif()


    if(NOT DEFINED ARG_SEARCH_PATHS)

        set(
            ARG_SEARCH_PATHS
            "${CMAKE_SOURCE_DIR}"
        )

    endif()


    if(NOT DEFINED ARG_FILE_PATTERNS)

        set(
            ARG_FILE_PATTERNS
            "*.c"
            "*.cpp"
        )

    endif()


    if(NOT DEFINED ARG_IS_SILENT_MODE)

        set(
            ARG_IS_SILENT_MODE
            FALSE
        )

    endif()


    # ====================================
    #       validate target name
    # ====================================
    if("${ARG_TARGET_NAME}" STREQUAL "")

        message(
            FATAL_ERROR
            "[${this_function_name}] TARGET_NAME is required."
        )

    endif()


    # ====================================
    #       normalize target type
    # ====================================
    string(
        TOUPPER
        "${ARG_TARGET_TYPE}"
        ARG_TARGET_TYPE
    )


    # ====================================
    #       validate target type
    # ====================================
    if(
        NOT ARG_TARGET_TYPE STREQUAL "INTERFACE"
        AND NOT ARG_TARGET_TYPE STREQUAL "STATIC"
        AND NOT ARG_TARGET_TYPE STREQUAL "OBJECT"
        AND NOT ARG_TARGET_TYPE STREQUAL "SHARED"
    )

        message(
            FATAL_ERROR
            "[${this_function_name}] Invalid TARGET_TYPE: ${ARG_TARGET_TYPE}. Supported values: INTERFACE, STATIC, OBJECT, SHARED."
        )

    endif()


    # ====================================
    #       lower-case target type
    # ====================================
    string(
        TOLOWER
        "${ARG_TARGET_TYPE}"
        target_type_suffix
    )


    # ====================================
    #       function start prompt
    # ====================================
    if(NOT ARG_IS_SILENT_MODE)

        message(STATUS "")
        message(
            STATUS
            "[${this_function_name} - start]"
        )

    endif()


    # ====================================
    #       Logic
    # ====================================
    set(target_name_list)


    foreach(search_path ${ARG_SEARCH_PATHS})


        # ------------------------------------
        #       expand search path
        # ------------------------------------
        file(
            GLOB
            search_roots
            CONFIGURE_DEPENDS
            LIST_DIRECTORIES true
            "${search_path}"
        )


        foreach(search_root ${search_roots})


            if(NOT IS_DIRECTORY "${search_root}")

                continue()

            endif()


            # ------------------------------------
            #       collect directories
            # ------------------------------------
            set(
                directories
                "${search_root}"
            )


            file(
                GLOB_RECURSE
                sub_directories
                CONFIGURE_DEPENDS
                LIST_DIRECTORIES true
                "${search_root}/*"
            )


            foreach(sub_directory ${sub_directories})

                if(IS_DIRECTORY "${sub_directory}")

                    list(
                        APPEND
                        directories
                        "${sub_directory}"
                    )

                endif()

            endforeach()


            # ------------------------------------
            #       create targets
            # ------------------------------------
            foreach(directory ${directories})


                # ------------------------------------
                #       collect source files
                # ------------------------------------
                set(sources)


                foreach(file_pattern ${ARG_FILE_PATTERNS})


                    # Find source files directly inside
                    # the current directory.
                    file(
                        GLOB
                        matched_sources
                        CONFIGURE_DEPENDS
                        "${directory}/${file_pattern}"
                    )


                    list(
                        APPEND
                        sources
                        ${matched_sources}
                    )

                endforeach()


                if(NOT sources)

                    continue()

                endif()


                # ------------------------------------
                #       generate target name
                # ------------------------------------
                if(directory STREQUAL search_root)


                    set(
                        current_target_name
                        "${ARG_TARGET_NAME}_${target_type_suffix}"
                    )


                else()


                    file(
                        RELATIVE_PATH
                        relative_directory
                        "${search_root}"
                        "${directory}"
                    )


                    string(
                        REPLACE
                        "/"
                        "_"
                        relative_target_name
                        "${relative_directory}"
                    )


                    # Handle Windows path separator.
                    string(
                        REPLACE
                        "\\"
                        "_"
                        relative_target_name
                        "${relative_target_name}"
                    )


                    set(
                        current_target_name
                        "${ARG_TARGET_NAME}_${relative_target_name}_${target_type_suffix}"
                    )

                endif()


                # ------------------------------------
                #       prevent duplicate targets
                # ------------------------------------
                if(TARGET "${current_target_name}")

                    message(
                        FATAL_ERROR
                        "[${this_function_name}] Target '${current_target_name}' already exists."
                    )

                endif()


                # ------------------------------------
                #       create target
                # ------------------------------------
                add_library(
                    "${current_target_name}"
                    ${ARG_TARGET_TYPE}
                    ${sources}
                )


                # ------------------------------------
                #       set linker language
                # ------------------------------------
                if(NOT ARG_TARGET_TYPE STREQUAL "INTERFACE")

                    set_property(
                        TARGET
                        "${current_target_name}"
                        PROPERTY
                        LINKER_LANGUAGE
                        CXX
                    )

                endif()


                # ------------------------------------
                #       append target name
                # ------------------------------------
                list(
                    APPEND
                    target_name_list
                    "${current_target_name}"
                )


                # ------------------------------------
                #       print target
                # ------------------------------------
                if(NOT ARG_IS_SILENT_MODE)

                    message(
                        STATUS
                        "Created target: ${current_target_name}"
                    )

                endif()


            endforeach()


        endforeach()


    endforeach()


    # ====================================
    #       print return variables
    # ====================================
    if(NOT ARG_IS_SILENT_MODE)

        message(STATUS "")
        message(
            STATUS
            "[${this_function_name} - print return variables]"
        )


        # Var for print return variables.
        set(
            ${this_function_name}_TARGET_NAME_LIST
            "${target_name_list}"
        )


        foreach(
            temp_print_return_var
            IN ITEMS
            "${this_function_name}_TARGET_NAME_LIST"
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
        ${this_function_name}_TARGET_NAME_LIST
        "${target_name_list}"
        PARENT_SCOPE
    )

endfunction()
