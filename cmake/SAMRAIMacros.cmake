macro (samrai_add_tests)

  set(singleValueArgs NAME EXECUTABLE PARALLEL EXTRA_ARG)
  set(multiValueArgs INPUTS)
  set(base_name ${arg_NAME})

  cmake_parse_arguments(arg
      "${options}" "${singleValueArgs}" "${multiValueArgs}" ${ARGN} )

  foreach (test_file ${arg_INPUTS})

    set(command_args ${test_file} ${arg_EXTRA_ARG})

    get_filename_component(short_test_file ${test_file} NAME)
    set(test_name "${base_name}_test_${short_test_file}")
    message(STATUS "Test: ${test_name} with input ${command_args}")

    if(ENABLE_MPI)
      blt_add_test(NAME ${test_name}
        COMMAND ${arg_EXECUTABLE} ${command_args}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        NUM_MPI_TASKS 1)
    else()
      blt_add_test(NAME ${test_name}
        COMMAND ${arg_EXECUTABLE} ${command_args}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
    endif()  
 
    if(${arg_PARALLEL})
      set(test_name "${base_name}_test_${short_test_file}_2")
      blt_add_test(NAME ${test_name}
        COMMAND ${arg_EXECUTABLE} ${command_args}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        NUM_MPI_TASKS 2)

      set(test_name "${base_name}_test_${short_test_file}_4")
      blt_add_test(NAME ${test_name}
        COMMAND ${arg_EXECUTABLE} ${command_args}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        NUM_MPI_TASKS 4)
    endif()

    set_tests_properties(${test_name} PROPERTIES PASS_REGULAR_EXPRESSION "PASSED")

  endforeach ()
endmacro ()
