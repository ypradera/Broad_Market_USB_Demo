#ifndef __COMDEF_H__
#define __COMDEF_H__


#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

/*===========================================================================
                   S T A N D A R D    D E C L A R A T I O N S
===========================================================================*/
#ifdef __cplusplus
  #define   __I     volatile             /*!< Defines 'read only' permissions */
#else
  #define   __I     volatile const       /*!< Defines 'read only' permissions */
#endif
#define     __O     volatile             /*!< Defines 'write only' permissions */
#define     __IO    volatile             /*!< Defines 'read / write' permissions */

#ifdef LOCAL
   #undef LOCAL
#endif

#ifdef SHOW_STAT
  #define LOCAL
#else
  #define LOCAL static
#endif

#ifndef MAX
   #define  MAX( x, y ) ( ((x) > (y)) ? (x) : (y) )
#endif

#ifndef MIN
   #define  MIN( x, y ) ( ((x) < (y)) ? (x) : (y) )
#endif

#if !defined(ARR_SIZE)
#define  ARR_SIZE( a )  ( sizeof( (a) ) / sizeof( (a[0]) ) )
#endif

//#ifndef IS_ALIGNED
//#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
//#endif

#define read8(port)        (*((volatile uint8_t *) (port)))
#define read16(port)       (*((volatile uint16_t *) (port)))
#define read32(port)       (*((volatile uint32_t *) (port)))
#define read64(port)       (*((volatile uint64_t *) (port)))
#define write8(port, val)  (*((volatile uint8_t *) (port)) = ((uint8_t) (val)))
#define write16(port, val) (*((volatile uint16_t *) (port)) = ((uint16_t) (val)))
#define write32(port, val) (*((volatile uint32_t *) (port)) = ((uint32_t) (val)))
#define write64(port, val) (*((volatile uint64_t *) (port)) = ((uint64_t) (val)))

#define in8(port)        (*((volatile uint8_t *) (port)))
#define in16(port)       (*((volatile uint16_t *) (port)))
#define in32(port)       (*((volatile uint32_t *) (port)))
#define in64(port)       (*((volatile uint64_t *) (port)))
#define out8(port, val)  (*((volatile uint8_t *) (port)) = ((uint8_t) (val)))
#define out16(port, val) (*((volatile uint16_t *) (port)) = ((uint16_t) (val)))
#define out32(port, val) (*((volatile uint32_t *) (port)) = ((uint32_t) (val)))
#define out64(port, val) (*((volatile uint64_t *) (port)) = ((uint64_t) (val)))

#define BIT(n)  (uint32_t)0x1<<n


#ifndef u8
typedef uint8_t u8;
#endif

#ifndef u16
typedef uint16_t u16;
#endif

#ifndef u32
typedef uint32_t u32;
#endif

#ifndef s8
typedef int8_t  s8;
#endif

#ifndef bool
typedef char bool;
#endif

#ifndef false
#define false 0
#endif

#ifndef true
#define true 1
#endif


#endif /*__COMDEF_H__*/
