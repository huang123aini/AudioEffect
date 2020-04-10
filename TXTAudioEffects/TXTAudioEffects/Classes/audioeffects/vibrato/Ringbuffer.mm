//
//  Ringbuffer.m
//  QAVKit
//
//  Created by huangshiping on 2019/6/12.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "Ringbuffer.h"
#include <vector>

static const int interpolatorMargin = 3;

float getSampleHermite4p3o(float x, float *y)
{
    static float c0, c1, c2, c3;
    // 4-point, 3rd-order Hermite (x-form)
    c0 = y[1];
    c1 = (1.0/2.0)*(y[2]-y[0]);
    c2 = (y[0] - (5.0/2.0)*y[1]) + (2.0*y[2] - (1.0/2.0)*y[3]);
    c3 = (1.0/2.0)*(y[3]-y[0]) + (3.0/2.0)*(y[1]-y[2]);
    return ((c3*x+c2)*x+c1)*x+c0;
}

@interface Ringbuffer()
{
    std::vector<float> buffer;
    int writeIndex;
    int size;
}
@end

@implementation Ringbuffer

-(instancetype)init
{
    if (self = [super init])
    {
        size = 0;
        writeIndex = 0;
    }
    return self;
}

-(void)write:(float)sample
{
    buffer[writeIndex] = sample;
    writeIndex++;
    if(writeIndex == size)
    {
        writeIndex = 0;
    }
}

-(void)write_margined:(float)sample
{
    buffer[writeIndex] = sample;
    if( writeIndex < interpolatorMargin )
    {
        buffer[size + writeIndex] = sample;
    }
    writeIndex++;
    if(writeIndex == size)
    {
        writeIndex = 0;
    }
}

-(float)readWithDelay:(int)delay
{
    int readIndex = writeIndex - delay;
    if (readIndex < 0)
    {
        readIndex += size;
    }
    return buffer[readIndex];    
}

-(void)resize:(int)sz
{
    size = sz;
    buffer.resize(size + interpolatorMargin);
}

-(float)getHermitAt:(float)delay
{
    float fReadIndex = writeIndex - 1 - delay;
    while(fReadIndex < 0)
        fReadIndex += size;
    while(fReadIndex >= size)
        fReadIndex -= size;
    
    int iPart = (int)fReadIndex; // integer part of the delay
    float fPart = fReadIndex - iPart; // fractional part of the delay
    
    return getSampleHermite4p3o(fPart, &(buffer[iPart]));
}

@end
