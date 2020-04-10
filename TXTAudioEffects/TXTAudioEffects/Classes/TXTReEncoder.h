//
//  TXTReEncoder.h
//  Pods-TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/12.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^ReencoderFinishHandler)(BOOL success,NSError* error);

@interface TXTReEncoder : NSObject

@property(nonatomic,strong)NSString* fileType;/** default is AVFileTypeAppleM4A*/
@property(nonatomic,assign)NSUInteger bitRate;/** default is 128K*/

-(void)reencoder:(NSString*)srcFile output:(NSString*)desFile finish:(ReencoderFinishHandler)handler;
-(void)cancel;/**取消转码*/

@end

NS_ASSUME_NONNULL_END
