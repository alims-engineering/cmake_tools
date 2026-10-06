# Template

| Field             | Description |
| :---------------- | :---------- |
| **Header**        |             |
| **Parameters**    |             |
| **Description**   |             |
| **Precondition**  |             |
| **Postcondition** |             |
| **Returns**       |             |

# function

## create_targets_recursively

| Field             | Description                                                                                                                                                                                                                |
| :---------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Header**        | `create_targets_recursively([TARGET_NAME <name>] [SEARCH_PATHS <paths>...] [FILE_PATTERNS <patterns>...] [IS_SILENT_MODE])`                                                                                                |
| **Parameters**    | `TARGET_NAME` — Root target name.<br>`SEARCH_PATHS` — Paths or path patterns to search recursively.<br>`FILE_PATTERNS` — File patterns to include.<br>`IS_SILENT_MODE` — Disables output messages.                         |
| **Description**   | Recursively creates one `OBJECT` target for each directory containing matching source files. Each target contains only the source files directly located in its corresponding directory.                                   |
| **Precondition**  | - `TARGET_NAME` is specified.<br>- `SEARCH_PATHS` resolves to valid directories or directory paths.<br>- `FILE_PATTERNS` contains valid CMake file patterns.<br>- Generated target names do not already exist.             |
| **Postcondition** | - An `OBJECT` target is created for each directory containing matching source files.<br>- Each target contains only the source files in its own directory.<br>- `CREATE_TARGETS_RECURSIVELY_TARGET_NAME_LIST` is exported. |
| **Returns**       | List of generated target names through `CREATE_TARGETS_RECURSIVELY_TARGET_NAME_LIST`.                                                                                                                                      |

## create_targets_recursively_cumulative

| Field             | Description                                                                                                                                                                                                                                                      |
| :---------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Header**        | `create_targets_recursively_cumulative([TARGET_NAME <name>] [SEARCH_PATHS <paths>...] [FILE_PATTERNS <patterns>...] [IS_SILENT_MODE])`                                                                                                                           |
| **Parameters**    | `TARGET_NAME` — Root target name.<br>`SEARCH_PATHS` — Paths or path patterns to search recursively.<br>`FILE_PATTERNS` — File patterns to include.<br>`IS_SILENT_MODE` — Disables output messages.                                                               |
| **Description**   | Recursively creates one `OBJECT` target for each directory containing matching source files. Each target contains the source files from its own directory and all descendant directories.                                                                        |
| **Precondition**  | - `TARGET_NAME` is specified.<br>- `SEARCH_PATHS` resolves to valid directories or directory paths.<br>- `FILE_PATTERNS` contains valid CMake file patterns.<br>- Generated target names do not already exist.                                                   |
| **Postcondition** | - An `OBJECT` target is created for each directory containing matching source files.<br>- Each target contains its own source files and all source files from descendant directories.<br>- `CREATE_TARGETS_RECURSIVELY_CUMULATIVE_TARGET_NAME_LIST` is exported. |
| **Returns**       | List of generated target names through `CREATE_TARGETS_RECURSIVELY_CUMULATIVE_TARGET_NAME_LIST`.                                                                                                                                                                 |

## fetch_content_cpp_tools

| Field             | Description                                                                                  |
| :---------------- | :------------------------------------------------------------------------------------------- |
| **Header**        | `fetch_content_cpp_tools([GIT_TAG <tag>] [IS_SILENT_MODE <boolean>])`                        |
| **Parameters**    | `GIT_TAG` — Git branch, tag, or commit hash.<br>`IS_SILENT_MODE` — Disables output messages. |
| **Description**   | Downloads and imports the `cpp_tools` repository using `FetchContent`.                       |
| **Precondition**  | - `FetchContent` is available<br>- `GIT_TAG` is valid if specified.                          |
| **Postcondition** | - `cpp_tools` is available<br>- `FETCH_CONTENT_CPP_TOOLS_*` variables are exported.          |
| **Returns**       | Repository URL, Git tag, source directory, and binary directory.                             |
