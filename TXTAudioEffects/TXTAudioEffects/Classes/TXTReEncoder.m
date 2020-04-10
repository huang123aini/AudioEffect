//
//  TXTReEncoder.m
//  Pods-TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/12.
//

#import "TXTReEncoder.h"
#import <AVFoundation/AVFoundation.h>
#import "TXTAudioEffectsManager.h"

@interface TXTReEncoder ()
@property (nonatomic) AVURLAsset *asset;
@property (nonatomic) AVAssetReader *assetReader;
@property (nonatomic) AVAssetWriter *assetWriter;
@property (nonatomic) AVAssetWriterInput *assetWriterAudioInput;
@property (nonatomic) AVAssetReaderTrackOutput *assetReaderAudioOutput;

@property (nonatomic) int sampleRate;
@property (nonatomic) int channels;

@property (nonatomic) BOOL cancelled;
@property (nonatomic) BOOL audioFinished;
@property (nonatomic) dispatch_queue_t reencoderQueue;
@property (nonatomic) dispatch_queue_t audioProcessQueue;
@property (nonatomic) dispatch_group_t dispatchGroup;
@property (nonatomic, copy, nullable) ReencoderFinishHandler reencoderFinishHandler;

-(CMSampleBufferRef)addAudioEffect:(CMSampleBufferRef)audioBuffer;
@end

@implementation TXTReEncoder

- (instancetype)init
{
    if (self = [super init])
    {
        self.fileType = AVFileTypeAppleM4A;
        self.bitRate = 128000;
        NSString *reencoderQueue = [NSString stringWithFormat:@"%@_ReEncoderQueue", self];
        self.reencoderQueue = dispatch_queue_create([reencoderQueue UTF8String], NULL);
        NSString *audioProcessQueue = [NSString stringWithFormat:@"%@_AudioProcessQueue", self];
        self.audioProcessQueue = dispatch_queue_create([audioProcessQueue UTF8String], NULL);
    }
    return self;
}

-(void)setFileType:(NSString *)fileType
{
    _fileType = fileType;
}
-(void)setBitRate:(NSUInteger)bitRate
{
    _bitRate = bitRate;
}

-(void)reencoder:(NSString* )srcFile output:(NSString* )desFile finish:(ReencoderFinishHandler)handler
{
    if (srcFile == nil || desFile == nil)
    {
        return;
    }
    self.reencoderFinishHandler = handler;
    [self load:srcFile];
    dispatch_async(self.reencoderQueue, ^{
        [self setup:desFile];
        [self startReencoder];
    });
}

-(void)load:(NSString* )srcFile
{
   self.asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:srcFile] options:nil];
    [self.asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        dispatch_async(self.reencoderQueue, ^{
            //async
            if (self.cancelled)
            {
                return;
            }
            NSError *error = nil;
            BOOL success = ([self.asset statusOfValueForKey:@"tracks" error:&error] == AVKeyValueStatusLoaded);
            if (!success)
            {
                NSLog(@"load srcfile is failed:%@",error);
            }
        });
    }];
    
}
-(void)setup:(NSString*)outputPath
{
    unlink(outputPath.UTF8String);
    NSError* error;
    self.assetReader = [[AVAssetReader alloc] initWithAsset:self.asset error:&error];
    BOOL success = (self.assetReader != nil);
    if (!success)
    {
        NSLog(@"%@_assetReader init failed",self);
        return;
    }
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:outputPath] fileType:self.fileType error:&error];
    success = (self.assetWriter != nil);
    if (!success)
    {
        NSLog(@"%@_assetWriter init failed",self);
        return;
    }
    AVAssetTrack *assetAudioTrack = nil;
    NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
    if ([audioTracks count] > 0)
    {
        assetAudioTrack = [audioTracks objectAtIndex:0];
    }
       
    if (assetAudioTrack)
    {
        NSDictionary *decompressionAudioSettings = @{ AVFormatIDKey : [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM] };
        self.assetReaderAudioOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:assetAudioTrack outputSettings:decompressionAudioSettings];
        self.assetReaderAudioOutput.alwaysCopiesSampleData = NO;
        [self.assetReader addOutput:self.assetReaderAudioOutput];
        
        const AudioStreamBasicDescription *asbd = NULL;
        if (self.asset)
        {
            AVAsset *asset = self.asset;
            AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
            for (int i = 0; i < track.formatDescriptions.count; i++)
            {
                CMFormatDescriptionRef desc = (__bridge CMFormatDescriptionRef)track.formatDescriptions[i];
                asbd = CMAudioFormatDescriptionGetStreamBasicDescription(desc);
            }
        }
        CGFloat sampleRate = asbd ? asbd->mSampleRate : 44100;
                  int channels = asbd ? asbd->mChannelsPerFrame : 2;
                  AudioChannelLayout acl = {0};
                  bzero( &acl, sizeof(acl));
                  acl.mChannelLayoutTag = channels == 2 ? kAudioChannelLayoutTag_Stereo : kAudioChannelLayoutTag_Mono;
        acl.mChannelBitmap = 0;
        acl.mNumberChannelDescriptions = 0;
        self.sampleRate = sampleRate;
        self.channels = channels;
        [TXTAudioEffectsManager sharedInstance].sampleRate = sampleRate;
        [TXTAudioEffectsManager sharedInstance].channels = channels;
        NSDictionary *compressionAudioSettings =
        @{
            AVFormatIDKey         : [NSNumber numberWithUnsignedInt:kAudioFormatMPEG4AAC],
            AVEncoderBitRateKey   : [NSNumber numberWithInteger:self.bitRate],
            AVSampleRateKey       : [NSNumber numberWithInteger:sampleRate],
            AVChannelLayoutKey    : [NSData dataWithBytes: &acl length: sizeof( acl )],
            AVNumberOfChannelsKey : [NSNumber numberWithUnsignedInteger:channels]
        };
        self.assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:[assetAudioTrack mediaType] outputSettings:compressionAudioSettings];
        [self.assetWriter addInput:self.assetWriterAudioInput];
    }
}

-(void)startReencoder
{
    if (![self.assetReader startReading])
    {
        NSLog(@"%@_startReader is Failed:%@",self,self.assetReader.error);
        return;
    }
    if (![self.assetWriter startWriting])
    {
        NSLog(@"%@_startWriter is Failed:%@",self,self.assetWriter.error);
    }
    //TODO:后续可能转码Mp4音频
    self.dispatchGroup = dispatch_group_create();
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    self.audioFinished = NO;
    if (self.assetWriterAudioInput)
    {
        dispatch_group_enter(self.dispatchGroup);
        [self.assetWriterAudioInput requestMediaDataWhenReadyOnQueue:self.audioProcessQueue usingBlock:^{
            if (self.audioFinished)
            {
                return;
            }
            BOOL completedOrFailed = NO;
            while ([self.assetWriterAudioInput isReadyForMoreMediaData] && !completedOrFailed)
            {
                CMSampleBufferRef sampleBuffer = [self.assetReaderAudioOutput copyNextSampleBuffer];
                if (sampleBuffer != NULL)
                {
                    CMSampleBufferRef newSampleBuffer = [self addAudioEffect:sampleBuffer];
                    NSLog(@"当前转码后的音频文件:%d",newSampleBuffer != NULL);
                    BOOL success = [self.assetWriterAudioInput appendSampleBuffer:newSampleBuffer];
                    CFRelease(sampleBuffer);
                    sampleBuffer = NULL;
                    completedOrFailed = !success;
                }
                else
                {
                    completedOrFailed = YES;
                }
            }
            if (completedOrFailed)
            {
                BOOL oldFinished = self.audioFinished;
                self.audioFinished = YES;
                if (oldFinished == NO)
                {
                    [self.assetWriterAudioInput markAsFinished];
                }
                dispatch_group_leave(self.dispatchGroup);
            }
        }];
    }
    
    dispatch_group_notify(self.dispatchGroup, self.reencoderQueue, ^{
           BOOL success = YES;
           NSError *error = nil;
           if (self.cancelled)
           {
               [self.assetReader cancelReading];
               [self.assetWriter cancelWriting];
           }else
           {
               if ([self.assetReader status] == AVAssetReaderStatusFailed)
               {
                   success = NO;
                   error = [self.assetReader error];
               }
               if (!success)
               {
                   [self.assetReader cancelReading];
                   [self.assetWriter cancelWriting];
               }
              [self.assetWriter finishWritingWithCompletionHandler:^{
                   if (self.reencoderFinishHandler)
                   {
                       self.reencoderFinishHandler(success, error);
                   }
                   NSLog(@"导出文件完成 isSuccess:%d error:%@",success,error);
               }];
           }

       });
}

-(void)cancel
{
    dispatch_async(self.reencoderQueue, ^{
           if (self.assetWriterAudioInput)
           {
               dispatch_async(self.audioProcessQueue, ^{
                   BOOL oldFinished = self.audioFinished;
                   self.audioFinished = YES;
                   if (oldFinished == NO)
                   {
                       [self.assetWriterAudioInput markAsFinished];
                   }
                   dispatch_group_leave(self.dispatchGroup);
               });
           }
           self.cancelled = YES;
       });
}

-(CMSampleBufferRef)addAudioEffect:(CMSampleBufferRef)audioBuffer
{
    CFRetain(audioBuffer);
    size_t _pcmBufferSize = 0;
    char* _pcmBuffer = NULL;
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(audioBuffer);
    CFRetain(blockBuffer);
    OSStatus status = CMBlockBufferGetDataPointer(blockBuffer, 0, NULL, &_pcmBufferSize, &_pcmBuffer);
    NSError *error = nil;
    if (status != kCMBlockBufferNoErr)
    {
        error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
        NSLog(@"add audio effect:%ld error:%@",(long)[TXTAudioEffectsManager sharedInstance].effectType,error);
    }
    __block CMSampleBufferRef newBuffer = NULL;
    
    AudioEffectType effectType = [TXTAudioEffectsManager sharedInstance].effectType;
    
    switch (effectType)
    {
        case AudioEffectType_PITCH:
        {
            [[TXTAudioEffectsManager sharedInstance] pushPitchData:(uint8_t*)_pcmBuffer length:(int)_pcmBufferSize finished:^(uint8_t * _Nonnull outData, int outLen)
            {
                newBuffer = [self createAudioSampleBuffer:outData frames:outLen];
                
            }];
            break;
        }
        case AudioEffectType_REVERB:
        {
            [[TXTAudioEffectsManager sharedInstance] pushRevervData:(uint8_t*)_pcmBuffer length:(int)_pcmBufferSize finished:^(uint8_t * _Nonnull outData, int outLen)
            {
                newBuffer = [self createAudioSampleBuffer:outData frames:outLen];
            }];
            break;
        }
        case AudioEffectType_BIQUAD:
        {
            [[TXTAudioEffectsManager sharedInstance] pushBiquadData:(uint8_t*)_pcmBuffer length:(int)_pcmBufferSize finished:^(uint8_t * _Nonnull outData, int outLen)
            {
                newBuffer = [self createAudioSampleBuffer:outData frames:outLen];
            }];
            break;
        }
        case AudioEffectType_VIBRATO:
        {
            [[TXTAudioEffectsManager sharedInstance] pushVibratoData:(uint8_t*)_pcmBuffer length:(int)_pcmBufferSize finished:^(uint8_t * _Nonnull outData, int outLen)
            {
                newBuffer = [self createAudioSampleBuffer:outData frames:outLen];
            }];
            break;
        }
            
        default:
            break;
    }
    
    CFRelease(blockBuffer);
    CFRelease(audioBuffer);
    return newBuffer;
}

-(AudioStreamBasicDescription)getAudioFormat
{
    Float64 samplerate = self.sampleRate;
    UInt32 channels = self.channels;
    AudioStreamBasicDescription format;
    format.mSampleRate = samplerate;
    format.mFormatID = kAudioFormatLinearPCM;
    format.mFormatFlags = kLinearPCMFormatFlagIsPacked | kLinearPCMFormatFlagIsSignedInteger;
    format.mBitsPerChannel = 16;
    format.mChannelsPerFrame = channels;
    format.mBytesPerFrame = format.mBitsPerChannel / 8 * format.mChannelsPerFrame;
    format.mFramesPerPacket = 1;
    format.mBytesPerPacket = format.mBytesPerFrame*format.mFramesPerPacket;
    format.mReserved = 0;
    return format;
}
-(CMSampleBufferRef)createAudioSampleBuffer:(void*)audioData frames:(UInt32)len
{
    Float64 samplerate = self.sampleRate;
    UInt32 channels = self.channels;
    AudioBufferList audioBufferList;
    audioBufferList.mNumberBuffers = 1;
    audioBufferList.mBuffers[0].mNumberChannels=channels;
    audioBufferList.mBuffers[0].mDataByteSize=len;
    audioBufferList.mBuffers[0].mData = audioData;
    AudioStreamBasicDescription asbd = [self getAudioFormat];
    CMSampleBufferRef buff = NULL;
    CMFormatDescriptionRef format = NULL;
    CMTime time = CMTimeMake(len/2 , samplerate);
    CMSampleTimingInfo timing = {CMTimeMake(1,samplerate), time, kCMTimeInvalid };
    OSStatus error = 0;
    if(format == NULL)
    {
        error = CMAudioFormatDescriptionCreate(kCFAllocatorDefault, &asbd, 0, NULL, 0, NULL, NULL, &format);
        if (error)
        {
            NSLog(@"CMAudioFormatDescriptionCreate returned error: %ld", (long)error);
            return NULL;
        }
    }
    error = CMSampleBufferCreate(kCFAllocatorDefault, NULL, false, NULL, NULL, format, len/(2*channels), 1, &timing, 0, NULL, &buff);
    if (error)
    {
        NSLog(@"CMSampleBufferCreate returned error: %ld", (long)error);
        return NULL;
    }
    error = CMSampleBufferSetDataBufferFromAudioBufferList(buff, kCFAllocatorDefault, kCFAllocatorDefault, 0, &audioBufferList);
    if(error)
    {
        NSLog(@"CMSampleBufferSetDataBufferFromAudioBufferList returned error: %ld", (long)error);
        return NULL;
    }
    return buff;
}

@end
