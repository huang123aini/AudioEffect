//
//  Lfo.h
//  QAVKit
//
//  Created by huangshiping on 2019/6/12.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lfo : NSObject

-(instancetype)init;
-(void)initialize:(float)samplerate freq:(float)freq;
-(void)setFrequency:(float)freq;
-(void)setPhase:(float)phase;
-(float)getValue;

@end
