# BearSSL cmake config

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
)

add_library(bearSSL STATIC ${SRC})
target_include_directories(bearSSL PUBLIC
  src/BearSSL/inc
  src/BearSSL/src
)
target_compile_options(bearSSL PRIVATE -fomit-frame-pointer)
target_compile_definitions(bearSSL PRIVATE
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
)
