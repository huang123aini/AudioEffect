//
//  AudioTools.h
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/7.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TXTAudioEffects/TXTAudioEffectsManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioTools : NSObject

@property(nonatomic,copy)NSString* srcFile;
@property(nonatomic,copy)NSString* desFile;

+(instancetype)sharedInstance;

@property(nonatomic,assign)float pitchValue;

-(void)setAudioType:(AudioEffectType)audioType;

-(void)setReverbType:(ReverbType)reverbType;
-(ReverbType)getReverbType;

-(void)setBiquadType:(BiquadType)biquadType;
-(BiquadType)getBiquadType;

-(NSString*)getRecordPath;

-(NSString*)getOutputPath;

@end

NS_ASSUME_NONNULL_END
