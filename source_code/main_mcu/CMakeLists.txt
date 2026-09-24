# CMakelists.txt from tanche
# 

cmake_minimum_required(VERSION 4.0)
project(main_mcu LANGUAGES C ASM)
set(CMAKE_BUILD_TYPE Debug)

set(SRC
  src/BearSSL/src/symcipher/aes_ct.c
  src/BearSSL/src/symcipher/aes_ct_ctr.c
  src/BearSSL/src/symcipher/aes_ct_ctrcbc.c
  src/BearSSL/src/symcipher/aes_ct_enc.c
  src/BearSSL/src/hash/sha1.c
  src/BearSSL/src/hash/sha2small.c
  src/BearSSL/src/mac/hmac.c
  src/BearSSL/src/rand/hmac_drbg.c
  src/BearSSL/src/ec/ec_p256_m15.c
  src/BearSSL/src/ec/ecdsa_i15_sign_raw.c
  src/BearSSL/src/ec/ec_keygen.c
  src/BearSSL/src/ec/ec_pubkey.c
  src/BearSSL/src/ec/ec_secp256r1.c
  src/BearSSL/src/ec/ec_secp384r1.c
  src/BearSSL/src/ec/ec_secp521r1.c
  src/BearSSL/src/ec/ecdsa_i15_bits.c
  src/BearSSL/src/int/i15_ninv15.c
  src/BearSSL/src/int/i15_encode.c
  src/BearSSL/src/int/i15_decode.c
  src/BearSSL/src/int/i15_decmod.c
  src/BearSSL/src/int/i15_add.c
  src/BearSSL/src/int/i15_sub.c
  src/BearSSL/src/int/i15_modpow.c
  src/BearSSL/src/int/i15_muladd.c
  src/BearSSL/src/int/i15_montmul.c
  src/BearSSL/src/int/i15_fmont.c
  src/BearSSL/src/int/i15_iszero.c
  src/BearSSL/src/int/i15_rshift.c
  src/BearSSL/src/int/i15_bitlen.c
  src/BearSSL/src/int/i15_tmont.c
  src/BearSSL/src/codec/ccopy.c
  src/BearSSL/src/codec/dec32be.c
  src/BearSSL/src/codec/enc32be.c
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
  # @fixme this depend of compile option
  src/ACCELEROMETER/lis2dh12.c
  src/OLED/ssd1363.c
)

add_executable(main_mcu.elf ${SRC})
target_link_options(main_mcu.elf PRIVATE -T "${PROJECT_SOURCE_DIR}/src/ASF/sam0/utils/linker_scripts/samd21/gcc/samd21g18a_flash.ld")
target_link_options(main_mcu.elf PRIVATE -L"src/ASF/thirdparty/CMSIS/Lib/GCC" -L"Device_Startup")
target_link_options(main_mcu.elf PRIVATE
  -Wl,-section-start=.start_app_function_addr=0x200
    -Wl,-section-start=.flash_start_addr=0x0
    -Wl,-section-start=.text=0x0 # @fixme $(TEXT_SEC_START)
  -Wl,--entry=Reset_Handler
  # -Wl,--cref
  # -Xlinker --undefined=jump_to_application_function_addr
  # -Xlinker --undefined=jump_to_application_function
)
target_compile_options(main_mcu.elf PRIVATE
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
  # @fixme needed by bearssl asm code because this asm code use r7 wich
  # is used as frame-pointer by the compiler
  # using -Os opti seen fixing this too
  -fomit-frame-pointer
  -Os
)
target_compile_definitions(main_mcu.elf PRIVATE
  -D__SAMD21G18A__
  -DBOARD=USER_BOARD
  -DARM_MATH_CM0PLUS=true
  -D__CORTEX_SC=0
  -DBR_ARMEL_CORTEXM_GCC=1
  -DBR_amd64=0
  -DBR_BE_UNALIGNED=0
  -DBR_CT_MUL15=0
  -DBR_ENABLE_INTRINSICS=0
  -DBR_CT_MUL31=0
  -DBR_i386=0
  -DBR_LE_UNALIGNED=0
  -DBR_NO_ARITH_SHIFT=0
  -DBR_POWER_ASM_MACROS=0
  -D_ARCH_PWR8=0
  -D_MSC_VER=0
  -D_M_IX86=0
  -D_M_X64=0
  -D__clang__=0
  -DBR_POWER8=0
  # @fixme
  V2_PLAT_V1_SETUP=1
)
target_include_directories(main_mcu.elf PRIVATE
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
  src/BearSSL/src
  src/BearSSL/inc
  src/CRYPTO
  src/I2C
)
