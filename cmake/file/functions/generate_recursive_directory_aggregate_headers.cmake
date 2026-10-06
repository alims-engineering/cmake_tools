# ====== GenerateRecursiveDirectoryAggregateHeaders.cmake
# ====================================
#		explanation
# ====================================
# Given a ROOT_DIR:
#   1. Automatically find all leaf directories.
#   2. Recursively generate aggregate headers from each leaf directory upward.
#   3. Generate <name>.hpp in the parent directory of each processed directory.
#   4. Remove duplicate includes.
#   5. Do not include headers across directory levels.
#
# The ROOT_DIR itself does not generate an aggregate header.
#
# Example:
#
# include/
# ??? cpp_tools/
#     ??? math/
#     ?   ??? functions/
#     ?   ?   ??? add.h
#     ?   ?   ??? sub.h
#     ?   ??? standard.h
#     ?
#     ??? container/
#         ??? functions/
#         ?   ??? next.h
#         ??? vector.h
#
# Input:
#
# ROOT_DIR = include/
#
# Output:
#
# cpp_tools/math/functions.hpp
# cpp_tools/math.hpp
# cpp_tools/container/functions.hpp
# cpp_tools/container.hpp
# cpp_tools.hpp
#
# include/
# ??? cpp_tools/
#     ??? math/
#     ?   ??? functions/
#     ?   ?   ??? add.h
#     ?   ?   ??? sub.h
#     ?   ??? standard.h
#     ??? container/
#         ??? functions/
#         ?   ??? next.h
#         ??? vector.h

# ====================================
#		parameters
# ====================================
# ROOT_DIR       : Root directory to recursively process.
# IS_SILENT_MODE : Disable print output.

# ====================================
#		parameter default value
# ====================================
# ROOT_DIR       = Required
# IS_SILENT_MODE = FALSE

# ====================================
#       return variables
# ====================================
# return_var_prefix = GENERATE_RECURSIVE_DIRECTORY_AGGREGATE_HEADERS
# ${return_var_prefix}_ROOT_DIR
# ${return_var_prefix}_GENERATED_HEADER_LIST


function(generate_recursive_directory_aggregate_headers)

	# ====================================
	#		pre-variables
	# ====================================
	set(this_function_screaming_snake_case_name "GENERATE_RECURSIVE_DIRECTORY_AGGREGATE_HEADERS")
	set(return_var_prefix ${this_function_screaming_snake_case_name})


	# ====================================
	#		includes
	# ====================================


	# ====================================
	#       function start prompt
	# ====================================
	if(NOT IS_SILENT_MODE)
		message(STATUS "")
		message(STATUS "[${this_function_screaming_snake_case_name} - start]")
	endif()


	# ====================================
	#		parameters
	# ====================================
	set(options IS_SILENT_MODE)
	set(oneValueArgs ROOT_DIR)
	set(multiValueArgs)

	cmake_parse_arguments(
		ARG
		"${options}"
		"${oneValueArgs}"
		"${multiValueArgs}"
		${ARGV}
	)


	# ====================================
	#		parameter default value
	# ====================================
	if(NOT DEFINED ARG_IS_SILENT_MODE)
		set(ARG_IS_SILENT_MODE FALSE)
	endif()

	if(NOT DEFINED ARG_ROOT_DIR)
		message(FATAL_ERROR
			"[${this_function_screaming_snake_case_name}] ROOT_DIR is required."
		)
	endif()

	get_filename_component(root_dir "${ARG_ROOT_DIR}" ABSOLUTE)

	if(NOT IS_DIRECTORY "${root_dir}")
		message(FATAL_ERROR
			"[${this_function_screaming_snake_case_name}] ROOT_DIR does not exist: ${root_dir}"
		)
	endif()


	# ====================================
	#       pre-variables
	# ====================================
	set(generated_header_list)


	# ====================================
	#       recursive function
	# ====================================
	function(_generate_directory_aggregate_header current_directory)

		# ====================================
		#       find child directories
		# ====================================
		file(GLOB child_paths LIST_DIRECTORIES TRUE "${current_directory}/*")

		set(child_directories)

		foreach(child_path IN LISTS child_paths)
			if(IS_DIRECTORY "${child_path}")
				list(APPEND child_directories "${child_path}")
			endif()
		endforeach()


		# ====================================
		#       recursively process children
		# ====================================
		foreach(child_directory IN LISTS child_directories)
			_generate_directory_aggregate_header("${child_directory}")
		endforeach()


		# ====================================
		#       directory information
		# ====================================
		get_filename_component(directory_name "${current_directory}" NAME)
		get_filename_component(parent_directory "${current_directory}" DIRECTORY)

		set(aggregate_header "${parent_directory}/${directory_name}.hpp")


		# ====================================
		#       find direct header files
		# ====================================
		file(GLOB direct_header_files
			LIST_DIRECTORIES FALSE
			"${current_directory}/*.h"
			"${current_directory}/*.hh"
			"${current_directory}/*.hpp"
			"${current_directory}/*.hxx"
		)


		# ====================================
		#       remove generated aggregate
		# ====================================
		list(REMOVE_ITEM direct_header_files "${aggregate_header}")


		# ====================================
		#       generate include list
		# ====================================
		set(include_lines)


		# ------------------------------------
		#       direct header files
		# ------------------------------------
		foreach(header_file IN LISTS direct_header_files)

			get_filename_component(header_name "${header_file}" NAME)

			list(
				APPEND
				include_lines
				"#include \"${directory_name}/${header_name}\""
			)

		endforeach()


		# ------------------------------------
		#       child aggregate headers
		# ------------------------------------
		foreach(child_directory IN LISTS child_directories)

			get_filename_component(child_directory_name "${child_directory}" NAME)

			list(
				APPEND
				include_lines
				"#include \"${directory_name}/${child_directory_name}.hpp\""
			)

		endforeach()


		# ====================================
		#       remove duplicate includes
		# ====================================
		list(REMOVE_DUPLICATES include_lines)
		list(SORT include_lines)


		# ====================================
		#       generate aggregate header
		# ====================================
		file(WRITE "${aggregate_header}" "#pragma once\n\n")

		foreach(include_line IN LISTS include_lines)
			file(APPEND "${aggregate_header}" "${include_line}\n")
		endforeach()


		# ====================================
		#       record generated header
		# ====================================
		list(APPEND generated_header_list "${aggregate_header}")
		set(generated_header_list "${generated_header_list}" PARENT_SCOPE)


		# ====================================
		#       print generated header
		# ====================================
		if(NOT ARG_IS_SILENT_MODE)
			message(STATUS "Generated: ${aggregate_header}")
		endif()

	endfunction()


	# ====================================
	#       execute
	# ====================================
	file(GLOB root_child_paths LIST_DIRECTORIES TRUE "${root_dir}/*")

	foreach(root_child_path IN LISTS root_child_paths)

		if(IS_DIRECTORY "${root_child_path}")
			_generate_directory_aggregate_header("${root_child_path}")
		endif()

	endforeach()


	# ====================================
	#       print return variables
	# ====================================
	if(NOT ARG_IS_SILENT_MODE)

		message(STATUS "")
		message(STATUS "[${return_var_prefix} - print return variables]")

		set(${return_var_prefix}_ROOT_DIR "${root_dir}")
		set(${return_var_prefix}_GENERATED_HEADER_LIST "${generated_header_list}")

		foreach(temp_print_return_var IN ITEMS
			"${return_var_prefix}_ROOT_DIR"
			"${return_var_prefix}_GENERATED_HEADER_LIST"
		)
			message(STATUS "${temp_print_return_var} = ${${temp_print_return_var}}")
		endforeach()

	endif()


	# ====================================
	#       return variables
	# ====================================
	set(${return_var_prefix}_ROOT_DIR "${root_dir}" PARENT_SCOPE)
	set(${return_var_prefix}_GENERATED_HEADER_LIST "${generated_header_list}" PARENT_SCOPE)


endfunction()