//
//  TXTAudioEffectsManager.h
//  Pods-TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AudioEffectType)
{
    AudioEffectType_PITCH,
    AudioEffectType_REVERB,
    AudioEffectType_BIQUAD,
    AudioEffectType_VIBRATO,
    AudioEffectType_NONE
};

typedef NS_ENUM(NSInteger,ReverbType)
{
    ReverbType_ADVANCE,
    ReverbType_DEFAULT,
    ReverbType_SMALLHALL1,
    ReverbType_SMALLHALL2,
    ReverbType_MEDIUMHALL1,
    ReverbType_MEDIUMHALL2,
    ReverbType_LARGEHALL1,
    ReverbType_LARGEHALL2,
    ReverbType_SMALLROOM1,
    ReverbType_SMALLROOM2,
    ReverbType_MEDIUMROOM1,
    ReverbType_MEDIUMROOM2,
    ReverbType_LARGEROOM1,
    ReverbType_LARGEROOM2,
    ReverbType_MEDIUMER1,
    ReverbType_MEDIUMER2,
    ReverbType_PLATEHIGH,
    ReverbType_PLATELOW,
    ReverbType_LONGREVERB1,
    ReverbType_LONGREVERB2
    
};

typedef NS_ENUM(NSInteger,BiquadType)
{
    BiquadType_LOWPASS,
    BiquadType_HIGHPASS,
    BiquadType_BANDPASS,
    BiquadType_NOTCH,
    BiquadType_PEAKING,
    BiquadType_ALLPASS,
    BiquadType_LOWSHELF,
    BiquadType_HIGHSHELF
};

@interface TXTAudioEffectsManager : NSObject

@property(nonatomic,assign)AudioEffectType effectType;
@property(nonatomic,assign)ReverbType reverbType;
@property(nonatomic,assign)BiquadType biquadType;
@property(nonatomic,assign)int channels;/**声道数*/
@property(nonatomic,assign)int sampleRate; /**采样率*/
@property(nonatomic,copy)NSMutableDictionary* advanceReverbParms;
@property(nonatomic,copy)NSMutableDictionary* biquadParams;

+(instancetype)sharedInstance;

/**变声*/
-(void)initPitch;
-(void)setPitch:(float)pitch; /**pitch is 0.5f ~ 2.f default is 1.0f*/
-(void)pushPitchData:(uint8_t*)data length:(int)dataLen finished:(void(^)(uint8_t* outData, int outLen))finished;

/**混响*/
-(void)initReverb:(ReverbType) reverbType;
-(void)pushRevervData:(uint8_t*)data length:(int)dataLen finished:(void(^)(uint8_t* outData, int outLen))finished;
-(NSDictionary*)getAdvanceReverbParms;

/**二阶滤波*/
-(void)initBiquad:(BiquadType) biquadType;
-(void)pushBiquadData:(uint8_t*)data length:(int)dataLen finished:(void(^)(uint8_t* outData, int outLen))finished;
-(NSDictionary*)getDefaultBiquadParams;

/**颤音*/
-(void)initVibrato;
-(void)pushVibratoData:(uint8_t*)data length:(int)dataLen finished:(void(^)(uint8_t* outData, int outLen))finished;

@end

NS_ASSUME_NONNULL_END
