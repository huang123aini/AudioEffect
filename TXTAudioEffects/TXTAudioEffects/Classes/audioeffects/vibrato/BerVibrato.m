//
//  BerVibrato.m
//  QAVKit
//
//  Created by huangshiping on 2019/6/12.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "BerVibrato.h"
#import "Lfo.h"
#import "Ringbuffer.h"

const float BASE_DELAY_SEC = 0.002; // 2 ms
const float VIBRATO_FREQUENCY_DEFAULT_HZ = 2;
const float VIBRATO_FREQUENCY_MAX_HZ = 14;
const float VIBRATO_DEPTH_DEFAULT_PERCENT = 50;

static const int additionalDelay = 3;

@interface BerVibrato()
{
    float sampleRate;
    float depth;
}
@property(nonatomic,strong)Lfo* lfo;
@property(nonatomic,strong)Ringbuffer* buffer;

@end

@implementation BerVibrato

-(instancetype)init
{
    if (self = [super init])
    {
        depth = 0;
        sampleRate = 0;
        
        self.lfo = [[Lfo alloc] init];
        self.buffer = [[Ringbuffer alloc] init];
    }
    return self;
}

-(void)initialize:(float)sr
{
    sampleRate = sr;
    [self.lfo initialize:sampleRate freq:VIBRATO_FREQUENCY_DEFAULT_HZ];
    [self.buffer resize:BASE_DELAY_SEC * sampleRate * 2];
}


-(void)setFrequency:(float)frequency
{
    [self.lfo setFrequency:frequency];
}

-(void)setDepth:(float)dt
{
    depth = dt;
}

-(float)processOneSample:(float)input
{
    float lfoValue = [self.lfo getValue];
    int maxDelay = BASE_DELAY_SEC * sampleRate;
    float delay = lfoValue * depth * maxDelay;
    delay += additionalDelay;
    float value = [self.buffer getHermitAt:delay];
    [self.buffer write_margined:input];
    return value;
}
@end
