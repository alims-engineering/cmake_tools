# ====== write_file_if_changed.cmake
# ====================================
#       explanation
# ====================================
# Write content to a file only when the content has changed.
#
# If the file does not exist, the content will be written directly.
# If the file exists and its content is identical to the provided content,
# the file will not be rewritten.

# ====================================
#       parameters
# ====================================
# filepath       : File path to write.
# content        : Content to write into the file.
# IS_SILENT_MODE : Disable print output.

# ====================================
#       parameter default value
# ====================================
# IS_SILENT_MODE = FALSE

# ====================================
#       return variables
# ====================================
# None.


function(write_file_if_changed filepath content)

	# ====================================
	#		pre-variables
	# ====================================
	set(this_function_name "WRITE_FILE_IF_CHANGED")


	# ====================================
	#		includes
	# ====================================
	# None.


	# ====================================
	#       function start prompt
	# ====================================
	if(NOT IS_SILENT_MODE)
		message(STATUS "")
		message(STATUS "[${this_function_name} - start]")
	endif()


	# ====================================
	#		parameters
	# ====================================
	# filepath and content are declared directly
	# in the function signature.
	#
	# IS_SILENT_MODE is read from the caller scope.


	# ====================================
	#		parameter default value
	# ====================================
	if(NOT DEFINED IS_SILENT_MODE)
		set(IS_SILENT_MODE FALSE)
	endif()


	# ====================================
	#		logic
	# ====================================
	if(EXISTS "${filepath}")

		file(READ "${filepath}" old_content)

		if(old_content STREQUAL content)
			return()
		endif()

	endif()

	file(WRITE "${filepath}" "${content}")

	if(NOT IS_SILENT_MODE)
		message(STATUS "[cmake_tools] Re-Wrote: ${filepath}")
	endif()


	# ====================================
	#       print return variables
	# ====================================
	# None.


	# ====================================
	#       return variables
	# ====================================
	# None.

endfunction()