//
//  AudioTools.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/7.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "AudioTools.h"

@interface AudioTools()

@end

@implementation AudioTools

+ (instancetype)sharedInstance
{
    static AudioTools *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init
{
    if (self = [super init])
    {
        self.pitchValue = 1.f;
    }
    return self;
}

-(void)setAudioType:(AudioEffectType)audioType
{
    [[TXTAudioEffectsManager sharedInstance] setEffectType:audioType];
}
-(void)setReverbType:(ReverbType)reverbType
{
    [TXTAudioEffectsManager sharedInstance].reverbType = reverbType;
}
-(ReverbType)getReverbType
{
    return [TXTAudioEffectsManager sharedInstance].reverbType;
}

-(void)setBiquadType:(BiquadType)biquadType
{
    [TXTAudioEffectsManager sharedInstance].biquadType = biquadType;
}
-(BiquadType)getBiquadType
{
    return [TXTAudioEffectsManager sharedInstance].biquadType;
}

-(NSString*)getRecordPath
{
    return [NSTemporaryDirectory() stringByAppendingFormat:@"audio.m4a"];
}

-(NSString*)getOutputPath
{
    return [NSTemporaryDirectory() stringByAppendingFormat:@"output.m4a"];
}
@end
