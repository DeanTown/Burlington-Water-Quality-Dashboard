/* This file was generated by upbc (the upb compiler) from the input
 * file:
 *
 *     udpa/core/v1/context_params.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated. */

#include <stddef.h>
#if COCOAPODS==1
  #include  "third_party/upb/upb/msg.h"
#else
  #include  "upb/msg.h"
#endif
#if COCOAPODS==1
  #include  "src/core/ext/upb-generated/udpa/core/v1/context_params.upb.h"
#else
  #include  "udpa/core/v1/context_params.upb.h"
#endif
#if COCOAPODS==1
  #include  "src/core/ext/upb-generated/udpa/annotations/status.upb.h"
#else
  #include  "udpa/annotations/status.upb.h"
#endif

#if COCOAPODS==1
  #include  "third_party/upb/upb/port_def.inc"
#else
  #include  "upb/port_def.inc"
#endif

static const upb_msglayout *const udpa_core_v1_ContextParams_submsgs[1] = {
  &udpa_core_v1_ContextParams_ParamsEntry_msginit,
};

static const upb_msglayout_field udpa_core_v1_ContextParams__fields[1] = {
  {1, UPB_SIZE(0, 0), 0, 0, 11, _UPB_LABEL_MAP},
};

const upb_msglayout udpa_core_v1_ContextParams_msginit = {
  &udpa_core_v1_ContextParams_submsgs[0],
  &udpa_core_v1_ContextParams__fields[0],
  UPB_SIZE(4, 8), 1, false,
};

static const upb_msglayout_field udpa_core_v1_ContextParams_ParamsEntry__fields[2] = {
  {1, UPB_SIZE(0, 0), 0, 0, 9, 1},
  {2, UPB_SIZE(8, 16), 0, 0, 9, 1},
};

const upb_msglayout udpa_core_v1_ContextParams_ParamsEntry_msginit = {
  NULL,
  &udpa_core_v1_ContextParams_ParamsEntry__fields[0],
  UPB_SIZE(16, 32), 2, false,
};

#if COCOAPODS==1
  #include  "third_party/upb/upb/port_undef.inc"
#else
  #include  "upb/port_undef.inc"
#endif
