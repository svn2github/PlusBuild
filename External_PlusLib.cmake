
SET(PLUSBUILD_OpenIGTLink_ARGS)
IF (PLUSBUILD_USE_OpenIGTLink)
    SET(PLUSBUILD_OpenIGTLink_ARGS
            -DPLUS_USE_OpenIGTLink:BOOL=${PLUSBUILD_USE_OpenIGTLink}
            -DOpenIGTLink_DIR:PATH=${OpenIGTLink_DIR}
        )
ELSE()
    SET(PLUSBUILD_OpenIGTLink_ARGS
            -DPLUS_USE_OpenIGTLink:BOOL=${PLUSBUILD_USE_OpenIGTLink}
        )
ENDIF ()

SET(PLUSBUILD_Slicer_ARGS -DPLUS_USE_SLICER:BOOL=${PLUSBUILD_USE_3DSlicer} )
IF (PLUSBUILD_USE_3DSlicer)
    SET(PLUSBUILD_Slicer_ARGS ${PLUSBUILD_Slicer_ARGS}
            -DSLICER_BIN_DIRECTORY=${PLUSBUILD_SLICER_BIN_DIRECTORY}
        )
ENDIF()      

SET(PLUSBUILD_SVN_REVISION_ARGS)
IF ( NOT PLUS_SVN_REVISION STREQUAL "0" )
    SET(PLUSBUILD_SVN_REVISION_ARGS 
        SVN_REVISION -r "${PLUS_SVN_REVISION}"
        )
ENDIF() 

SET(PLUSBUILD_NDIOAPI_ARGS)
IF (PLUS_USE_CERTUS)
    SET(PLUSBUILD_NDIOAPI_ARGS 
        -DNDIOAPI_LIBRARY:PATH=${NDIOAPI_LIBRARY}
        -DNDIOAPI_BINARY_DIR:PATH=${NDIOAPI_BINARY_DIR}
        -DNDIOAPI_INCLUDE_DIR:PATH=${NDIOAPI_INCLUDE_DIR}
        )
ENDIF()    

SET(PLUSBUILD_ULTRASONIX_SDK_ARGS)
IF ( PLUS_USE_ULTRASONIX_VIDEO )
    SET(PLUSBUILD_ULTRASONIX_SDK_ARGS 
    -DULTRASONIX_SDK_DIR:PATH=${ULTRASONIX_SDK_DIR}
    )
ENDIF()    

# --------------------------------------------------------------------------
# PlusLib
SET (PLUS_PLUSLIB_DIR ${CMAKE_BINARY_DIR}/PlusLib CACHE INTERNAL "Path to store PlusLib contents.")
ExternalProject_Add(PlusLib
            SOURCE_DIR "${PLUS_PLUSLIB_DIR}" 
            BINARY_DIR "PlusLib-bin"
            #--Download step--------------
            SVN_USERNAME ${PLUSBUILD_ASSEMBLA_USERNAME}
            SVN_PASSWORD ${PLUSBUILD_ASSEMBLA_PASSWORD}
            SVN_REPOSITORY https://subversion.assembla.com/svn/plus/trunk/PlusLib
            ${PLUSBUILD_SVN_REVISION_ARGS}
            #--Configure step-------------
            CMAKE_ARGS 
                -DVTK_DIR:PATH=${VTK_DIR}
                -DITK_DIR:PATH=${ITK_DIR}
                -DSubversion_SVN_EXECUTABLE:FILEPATH=${Subversion_SVN_EXECUTABLE}
                ${PLUSBUILD_OpenIGTLink_ARGS}
                ${PLUSBUILD_Slicer_ARGS}
                ${PLUSBUILD_NDIOAPI_ARGS}
                ${PLUSBUILD_ULTRASONIX_SDK_ARGS}
                -DPLUS_EXECUTABLE_OUTPUT_PATH:STRING=${PLUS_EXECUTABLE_OUTPUT_PATH}
                -DPLUS_USE_ULTRASONIX_VIDEO:BOOL=${PLUS_USE_ULTRASONIX_VIDEO}
                -DPLUS_ULTRASONIX_SDK_MAJOR_VERSION=${PLUS_ULTRASONIX_SDK_MAJOR_VERSION}
                -DPLUS_ULTRASONIX_SDK_MINOR_VERSION=${PLUS_ULTRASONIX_SDK_MINOR_VERSION}
                -DPLUS_ULTRASONIX_SDK_PATCH_VERSION=${PLUS_ULTRASONIX_SDK_PATCH_VERSION}
                -DPLUS_USE_ICCAPTURING_VIDEO:BOOL=${PLUS_USE_ICCAPTURING_VIDEO}
                -DPLUS_USE_VFW_VIDEO:BOOL=${PLUS_USE_VFW_VIDEO}
                -DPLUS_USE_POLARIS:BOOL=${PLUS_USE_POLARIS}
                -DPLUS_USE_CERTUS:BOOL=${PLUS_USE_CERTUS}
                -DPLUS_USE_MICRONTRACKER:BOOL=${PLUS_USE_MICRONTRACKER}
                -DPLUS_USE_BRACHY_TRACKER:BOOL=${PLUS_USE_BRACHY_TRACKER}
                -DPLUS_USE_Ascension3DG:BOOL=${PLUS_USE_Ascension3DG}
                -DPLUS_USE_HEARTSIGNALBOX:BOOL=${PLUS_USE_HEARTSIGNALBOX}
                -DPLUS_USE_USBECGBOX:BOOL=${PLUS_USE_USBECGBOX}
                -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
                -DQT_BINARY_DIR:PATH=${QT_BINARY_DIR}
                -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
                -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
            #--Build step-----------------
            #--Install step-----------------
            INSTALL_COMMAND ""
            DEPENDS ${PlusLib_DEPENDENCIES}
            )
SET(PLUSLIB_DIR ${CMAKE_BINARY_DIR}/PlusLib-bin CACHE PATH "The directory containing PlusLib binaries" FORCE)                
