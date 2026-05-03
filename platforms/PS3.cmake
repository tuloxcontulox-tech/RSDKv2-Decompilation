# PS3 platform configuration using PSL1GHT SDK

add_executable(RetroEngine ${RETRO_FILES})

# Force SDL1 for PS3 as SDL2 is not well-supported or available in psl1ght
set(RETRO_SDL_VERSION 1 CACHE STRING "Select between SDL2 and SDL1, defaults to SDL2" FORCE)

# Build dependencies from source for PS3 if not found
set(COMPILE_OGG TRUE CACHE BOOL "" FORCE)
set(COMPILE_VORBIS TRUE CACHE BOOL "" FORCE)
set(DEP_PATH ps3)

target_compile_definitions(RetroEngine PRIVATE __PS3__)

# PS3 specific include directories and library paths
if(DEFINED ENV{PSL1GHT_SDK})
    set(PS3_SDK_INCLUDE $ENV{PSL1GHT_SDK}/ppu/include)
    set(PS3_SDK_LIB $ENV{PSL1GHT_SDK}/ppu/lib)

    target_include_directories(RetroEngine PRIVATE ${PS3_SDK_INCLUDE})
    target_link_directories(RetroEngine PRIVATE ${PS3_SDK_LIB})

    # Standard PS3 libraries for PSL1GHT SDL projects
    target_link_libraries(RetroEngine
        SDL
        rsx
        gcm_sys
        io
        net
        sysutil
        m
        lv2
    )

    # PS3 specific compiler flags
    target_compile_options(RetroEngine PRIVATE -O2 -Wall -mcpu=cell)
else()
    message(WARNING "PSL1GHT_SDK environment variable not set. PS3 build may fail.
    Please set PSL1GHT_SDK to your PS3 SDK path (e.g. C:/ps3dev/psl1ght).")
endif()

if(RETRO_USE_MOD_LOADER)
    set_target_properties(RetroEngine PROPERTIES
        CXX_STANDARD 17
        CXX_STANDARD_REQUIRED ON
    )
endif()
