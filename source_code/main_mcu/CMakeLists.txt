# CMakelists.txt from tanche
# 

cmake_minimum_required(VERSION 4.0)
project(main_mcu LANGUAGES C ASM)
set(OUTPUT main_mcu.elf)

set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_C_STANDARD 11)

set(Platform "miniBLE_V2" CACHE STRING "Select the target platforme")
set(PlatformList "miniBLE;miniBLE_V2;Emulator")
set_property(CACHE Platform PROPERTY STRINGS ${PlatformList})
if(NOT ${Platform} IN_LIST PlatformList)
  message(FATAL_ERROR "Platform must be one of this: ${PlatformList}")
endif()

message(STATUS "Building main mcu for plateform: ${Platform}")
set(SRC
  src/CLOCKS/driver_clocks.c
  src/COMMS/comms_aux_mcu.c
  src/COMMS/comms_hid_msgs.c
  src/COMMS/comms_hid_msgs_debug.c
  src/debug_minible.c
  src/debug_minible_v2.c
  src/DMA/dma.c
  src/FILESYSTEM/custom_bitstream.c
  src/FILESYSTEM/custom_fs.c
  src/FILESYSTEM/custom_fs_emergency_font.c
  src/FLASH/dataflash.c
  src/FLASH/dbflash.c
  src/functional_testing.c
  src/GUI/gui_carousel.c
  src/GUI/gui_dispatcher.c
  src/GUI/gui_menu.c
  src/GUI/gui_prompts.c
  src/INPUTS/inputs.c
  src/LOGIC/logic_aux_mcu.c
  src/LOGIC/logic_bluetooth.c
  src/LOGIC/logic_database.c
  src/LOGIC/logic_device.c
  src/LOGIC/logic_encryption.c
  src/LOGIC/logic_gui.c
  src/LOGIC/logic_power.c
  src/LOGIC/logic_security.c
  src/LOGIC/logic_smartcard.c
  src/LOGIC/logic_user.c
  src/LOGIC/logic_accelerometer.c
  src/NODEMGMT/nodemgmt.c
  src/OLED/mooltipass_graphics_bundle.c
  src/PLATFORM/platform_io.c
  src/RNG/rng.c
  src/SECURITY/fuses.c
  src/SERCOM/driver_sercom.c
  src/SE_SMARTCARD/smartcard_highlevel.c
  src/SE_SMARTCARD/smartcard_lowlevel.c
  src/TIMER/driver_timer.c
  src/utils.c
  src/ASF/common2/boards/user_board/init.c
  src/ASF/common/utils/interrupt/interrupt_sam_nvic.c
  src/ASF/sam0/drivers/system/clock/clock_samd21_r21_da_ha1/clock.c
  src/ASF/sam0/drivers/system/clock/clock_samd21_r21_da_ha1/gclk.c
  src/ASF/sam0/drivers/system/interrupt/system_interrupt.c
  src/ASF/sam0/drivers/system/pinmux/pinmux.c
  src/ASF/sam0/drivers/system/system.c
  src/ASF/sam0/utils/cmsis/samd21/source/gcc/startup_samd21.c
  src/ASF/sam0/utils/cmsis/samd21/source/system_samd21.c
  src/ASF/sam0/utils/syscalls/gcc/syscalls.c
  src/main.c
  src/LOGIC/logic_fido2.c
  src/CRYPTO/monocypher.c
  src/CRYPTO/monocypher-ed25519.c
  src/I2C/driver_i2c.c
  src/I2C/mp2710.c
  src/I2C/pcf85263a.c
)

set(TEXT_SEC_START 0x2000)
if(${Platform} STREQUAL miniBLE)
  set(SRC ${SRC}
    src/ACCELEROMETER/lis2hh12.c
    src/OLED/sh1122.c
  )
  set(TEXT_SEC_START 0x8000)
  set(TARGET_PLATFORM PLAT_V7_SETUP)
elseif(${Platform} STREQUAL miniBLE_V2)
  set(SRC ${SRC}
    src/ACCELEROMETER/lis2dh12.c
    src/OLED/ssd1363.c
  )
  set(TEXT_SEC_START 0x0)
  set(TARGET_PLATFORM V2_PLAT_V1_SETUP)
elseif(${Platform} STREQUAL Emulator)
else()
  message(FATAL_ERROR "Platform: ${Platform} not recognize")
endif()

# message(WARNING "src: ${SRC}")

add_executable(${OUTPUT} ${SRC})
target_link_options(${OUTPUT} PRIVATE -T "${PROJECT_SOURCE_DIR}/src/ASF/sam0/utils/linker_scripts/samd21/gcc/samd21g18a_flash.ld")
target_link_options(${OUTPUT} PRIVATE -L"src/ASF/thirdparty/CMSIS/Lib/GCC" -L"Device_Startup")
target_link_options(${OUTPUT} PRIVATE
  -Wl,-section-start=.start_app_function_addr=0x200
  -Wl,-section-start=.flash_start_addr=0x0
  -Wl,-section-start=.text=${TEXT_SEC_START}
  -Wl,--entry=Reset_Handler
  # -Wl,--cref
  # -Xlinker --undefined=jump_to_application_function_addr
  # -Xlinker --undefined=jump_to_application_function
)
target_compile_options(${OUTPUT} PRIVATE
  -mlong-calls
  -Wall
  -mcpu=cortex-m0plus
  -c
  -pipe
  -fno-strict-aliasing
  -Wall
  -Wstrict-prototypes
  -Wmissing-prototypes
  -Werror-implicit-function-declaration
  -Wpointer-arith
  -std=gnu99
  -Wchar-subscripts
  -Wcomment
  -Wformat=2
  -Wimplicit-int
  -Wmain
  -Wparentheses
  -Wsequence-point
  -Wreturn-type
  -Wswitch
  -Wtrigraphs
  -Wunused
  -Wuninitialized
  -Wunknown-pragmas
  -Wfloat-equal
  -Wundef
  -Wshadow
  -Wbad-function-cast
  -Wwrite-strings
  -Wsign-compare
  -Waggregate-return
  -Wmissing-declarations
  -Wformat
  -Wmissing-format-attribute
  -Wno-deprecated-declarations
  -Wpacked
  -Wredundant-decls
  -Wnested-externs
  -Wunreachable-code
  -Wcast-align
  --param max-inline-insns-single=500
  -Wduplicated-cond
  -Wlogical-op
  -Wnull-dereference
  -Wjump-misses-init
  # @fixme this must be config by CMAKE_BUILD_TYPE
  -Os
)
target_compile_definitions(${OUTPUT} PRIVATE
  -D__SAMD21G18A__
  -DBOARD=USER_BOARD
  -D${TARGET_PLATFORM}=1
)
target_include_directories(${OUTPUT} PRIVATE
  src/ASF/thirdparty/CMSIS/Include
  src/ASF/common/boards
  src/ASF/sam0/utils
  src/ASF/sam0/utils/header_files
  src/ASF/sam0/utils/preprocessor
  src/ASF/thirdparty/CMSIS/Include
  src/ASF/thirdparty/CMSIS/Lib/GCC
  src/ASF/common/utils
  src/ASF/sam0/utils/cmsis/samd21/include
  src/ASF/sam0/utils/cmsis/samd21/source
  src/ASF/sam0/drivers/system
  src/ASF/sam0/drivers/system/clock/clock_samd21_r21_da_ha1
  src/ASF/sam0/drivers/system/clock
  src/ASF/sam0/drivers/system/interrupt
  src/ASF/sam0/drivers/system/interrupt/system_interrupt_samd21
  src/ASF/sam0/drivers/system/pinmux
  src/ASF/sam0/drivers/system/power
  src/ASF/sam0/drivers/system/power/power_sam_d_r_h
  src/ASF/sam0/drivers/system/reset
  src/ASF/sam0/drivers/system/reset/reset_sam_d_r_h
  src/ASF/common2/boards/user_board
  src
  src/config
  src/PLATFORM
  src/CLOCKS
  src/SERCOM
  src/FLASH
  src/FILESYSTEM
  src/DMA
  src/TIMER
  ../packs/samd21a/include
  src/SE_SMARTCARD
  src/OLED
  src/ACCELEROMETER
  src/INPUTS
  src/COMMS
  src/LOGIC
  src/SECURITY
  src/GUI
  src/NODEMGMT
  src/RNG
  src/CRYPTO
  src/I2C
)

include(cmake/bearSSL.cmake)
target_link_libraries(${OUTPUT} bearSSL)
