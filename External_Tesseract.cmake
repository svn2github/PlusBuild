SET(tesseract_DEPENDENCIES leptonica)
SET(leptonica_DEPENDENCIES vtk) #for vtkzlib
SET(tesseract_ROOT_DIR ${CMAKE_BINARY_DIR}/tesseract-super)

# --------------------------------------------------------------------------
# leptonica
SET (PLUS_leptonica_src_DIR ${tesseract_ROOT_DIR}/leptonica CACHE INTERNAL "Path to store leptonica contents.")
SET (PLUS_leptonica_prefix_DIR ${tesseract_ROOT_DIR}/leptonica-prefix CACHE INTERNAL "Path to store leptonica prefix data.")
SET (PLUS_leptonica_DIR "${tesseract_ROOT_DIR}/leptonica-bin" CACHE INTERNAL "Path to store leptonica binaries")
ExternalProject_Add( leptonica
    PREFIX ${PLUS_leptonica_prefix_DIR}
    "${PLUSBUILD_EXTERNAL_PROJECT_CUSTOM_COMMANDS}"
    SOURCE_DIR "${PLUS_leptonica_src_DIR}"
    BINARY_DIR "${PLUS_leptonica_DIR}"
    #--Download step--------------
    GIT_REPOSITORY "${GIT_PROTOCOL}://github.com/PLUSToolkit/leptonica.git"
    GIT_TAG ec18129f502acef9f8ae21aee269cf699394b54b
    #--Configure step-------------
    CMAKE_ARGS 
        ${ep_common_args}
        -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
        -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
        -DCMAKE_PREFIX_PATH:STRING=${CMAKE_PREFIX_PATH}
        -DVTK_DIR:PATH=${PLUS_VTK_DIR} #get vtkzlib and vtkpng from vtk
    #--Build step-----------------
    #--Install step-----------------
    INSTALL_COMMAND "" #don't install
    #--Dependencies-----------------
    DEPENDS ${leptonica_DEPENDENCIES}
    )

# --------------------------------------------------------------------------
# tessdata
SET (PLUS_tessdata_src_DIR ${tesseract_ROOT_DIR}/tessdata CACHE INTERNAL "Path to store tesseract language data contents.")
SET (PLUS_tessdata_prefix_DIR ${tesseract_ROOT_DIR}/tessdata-prefix CACHE INTERNAL "Path to store tesseract language prefix data.")
ExternalProject_Add( tessdata
    "${PLUSBUILD_EXTERNAL_PROJECT_CUSTOM_COMMANDS}"
    PREFIX ${PLUS_tessdata_prefix_DIR}
    SOURCE_DIR "${PLUS_tessdata_src_DIR}"
    BINARY_DIR "${PLUS_tessdata_src_DIR}"
    #--Download step--------------
    GIT_REPOSITORY "${GIT_PROTOCOL}://github.com/PLUSToolkit/tessdata.git"
    GIT_TAG master
    #--Configure step-------------
    CONFIGURE_COMMAND ""
    #--Build step-----------------
    BUILD_COMMAND ""
    #--Install step-----------------
    #--Dependencies-----------------
    INSTALL_COMMAND ""
    DEPENDS ""
    )
SET( tesseract_DEPENDENCIES ${tesseract_DEPENDENCIES} tessdata )
IF( WIN32 )
  MESSAGE(STATUS "Setting TESSDATA_PREFIX environment variable to enable loading of OCR languages.")
  execute_process(COMMAND setx TESSDATA_PREFIX ${PLUS_tessdata_src_DIR})
ENDIF( WIN32 )
# TODO: else linux, export env var? I don't know if CMake can do that...

# --------------------------------------------------------------------------
# tesseract-ocr-cmake
SET (PLUS_tesseract_src_DIR ${tesseract_ROOT_DIR}/tesseract CACHE INTERNAL "Path to store tesseract contents.")
SET (PLUS_tesseract_prefix_DIR ${tesseract_ROOT_DIR}/tesseract-prefix CACHE INTERNAL "Path to store tesseract prefix data.")
SET (PLUS_tesseract_DIR "${tesseract_ROOT_DIR}/tesseract-bin" CACHE INTERNAL "Path to store tesseract binaries")
ExternalProject_Add( tesseract
    PREFIX ${PLUS_tesseract_prefix_DIR}
    "${PLUSBUILD_EXTERNAL_PROJECT_CUSTOM_COMMANDS}"
    SOURCE_DIR "${PLUS_tesseract_src_DIR}"
    BINARY_DIR "${PLUS_tesseract_DIR}"
    #--Download step--------------
    GIT_REPOSITORY "${GIT_PROTOCOL}://github.com/PLUSToolkit/tesseract-ocr-cmake.git"
    GIT_TAG cd300ab908ed39c739c1047805df22a4d3cae7f8
    #--Configure step-------------
    CMAKE_ARGS 
        ${ep_common_args}
        -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
        -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
        -DCMAKE_PREFIX_PATH:STRING=${CMAKE_PREFIX_PATH}
        -DCMAKE_INSTALL_PREFIX:PATH=${PLUS_tesseract_DIR}
        -DLeptonica_DIR:PATH=${PLUS_leptonica_DIR}
    #--Build step-----------------
    #--Install step-----------------
    #--Dependencies-----------------
    DEPENDS ${tesseract_DEPENDENCIES}
    )
