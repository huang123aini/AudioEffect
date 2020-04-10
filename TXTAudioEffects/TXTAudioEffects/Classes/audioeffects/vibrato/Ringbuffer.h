//
//  Ringbuffer.h
//  QAVKit
//
//  Created by huangshiping on 2019/6/12.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ringbuffer : NSObject

-(instancetype)init;
-(void)write:(float)sample;
-(void)write_margined:(float)sample;
-(float)readWithDelay:(int)delay;
-(void)resize:(int)size;
-(float)getHermitAt:(float)delay;

@end
