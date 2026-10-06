# Template

| Field | Description |
|:---|:---|
| **Header**		| |
| **Parameters**	| |
| **Description**	| |
| **Precondition**	| |
| **Postcondition**	| |
| **Returns**		| |



# function
## fetch_content_cpp_tools

| Field | Description |
|:---|:---|	
| **Header** |	`fetch_content_cpp_tools([GIT_TAG <tag>] [IS_SILENT_MODE <boolean>])` |
| **Parameters** | `GIT_TAG` — Git branch, tag, or commit hash.<br>`IS_SILENT_MODE` — Disables output messages. |
| **Description** | Downloads and imports the `cpp_tools` repository using `FetchContent`. |
| **Precondition** | - `FetchContent` is available	<br> - `GIT_TAG` is valid if specified. |
| **Postcondition** | - `cpp_tools` is available	<br> - `FETCH_CONTENT_CPP_TOOLS_*` variables are exported. |
| **Returns** | Repository URL, Git tag, source directory, and binary directory. |
