//
//  bpx_bridge.h
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/24/22.
//

#ifndef bpx_bridge_h
#define bpx_bridge_h

#include <bpx/open.h>
#include <bpx/container.h>
#include <bpx/sd.h>
#include <bpx/section.h>
#include <bpx/error_codes.h>

//Searched for 1 hour on google there exists no solution in swift, well then throw good old proper C at it!
int8_t bypass_garbage_signed_bits_count(uint8_t byte);

#endif /* bpx_bridge_h */
