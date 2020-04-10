//
//  Lfo.m
//  QAVKit
//
//  Created by huangshiping on 2019/6/12.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "Lfo.h"

#import <math.h>

@interface Lfo()
{
    float sampleRate;
    float frequency;
    float phase;
    float index;
}
@end
@implementation Lfo
-(instancetype)init
{
    if(self = [super init])
    {
        index = 0;
        sampleRate = 0;
        frequency = 0;
        phase = 0;
    }
    return self;
}

-(void)initialize:(float)sr freq:(float)freq
{
    sampleRate = sr;
    frequency = freq;
}
-(void)setFrequency:(float)freq
{
    frequency = freq;
}
-(void)setPhase:(float)ph
{
    phase = ph;
}
-(float)getValue
{
    const float dp = 2 * M_PI * frequency / sampleRate; // phase step
    float value = sin(phase);
    value = (value + 1) * 0.5; // transform from [-1; 1] to [0; 1]
    phase += dp;
    while(phase > 2 * M_PI)
        phase -= 2 * M_PI;
    return value;
}

@end
