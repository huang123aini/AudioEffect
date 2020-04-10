#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TXTAudioEffectsManager.h"
#import "TXTReEncoder.h"
#import "sonic.h"
#import "reverb.h"
#import "biquad.h"
#import "snd.h"
#import "BerVibrato.h"
#import "Lfo.h"
#import "Ringbuffer.h"

FOUNDATION_EXPORT double TXTAudioEffectsVersionNumber;
FOUNDATION_EXPORT const unsigned char TXTAudioEffectsVersionString[];

