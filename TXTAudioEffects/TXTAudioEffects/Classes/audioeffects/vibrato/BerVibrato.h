//
//  BerVibrato.h
//  QAVKit
//
//  Created by huangshiping on 2019/6/12.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BerVibrato : NSObject

-(instancetype)init;

-(void)initialize:(float)sampleRate;

-(void)setFrequency:(float)frequency;

-(void)setDepth:(float)depth;

-(float)processOneSample:(float)input;

@end

