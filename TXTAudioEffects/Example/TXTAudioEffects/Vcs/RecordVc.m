//
//  RecordVc.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/6.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "RecordVc.h"
#import <AVFoundation/AVFoundation.h>
#import "TTScaleSpringButton.h"
#import "SelectEffectVc.h"
#import "AudioTools.h"
@interface RecordVc ()<AVAudioRecorderDelegate>
{
    AVAudioRecorder *_recoder;  //录音
}
@property(nonatomic,strong)TTScaleSpringButton* recordButton;
@property(nonatomic,assign)BOOL isRecording;
@end

@implementation RecordVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self setupNavigationBar];
}

-(void)setupUI
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgcolor.jpg"]];
    self.isRecording = NO;
    self.recordButton = [TTScaleSpringButton buttonWithType:UIButtonTypeSystem];
    [self.recordButton setBackgroundImage:[UIImage imageNamed:@"buttoncolor.jpg"] forState:UIControlStateNormal];
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    self.recordButton.frame = CGRectMake(0.5 * width - 100, 0.5 * height - 200, 200, 200);
    [self.recordButton setTitle:@"开始录制" forState:UIControlStateNormal];
    self.recordButton.titleLabel.font = [UIFont systemFontOfSize:25.];
    [self.recordButton addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordButton];
    
    TTScaleSpringButton* effectButton = [TTScaleSpringButton buttonWithType:UIButtonTypeSystem];
    [effectButton setBackgroundImage:[UIImage imageNamed:@"buttoncolor.jpg"] forState:UIControlStateNormal];
    effectButton.frame = CGRectMake(0.5 * width - 100, 0.5 * height + 100,200, 100);
    [effectButton setTitle:@"选取特效" forState:UIControlStateNormal];
    effectButton.titleLabel.font = [UIFont systemFontOfSize:25.];
    [effectButton addTarget:self action:@selector(selectEffect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:effectButton];
}

-(void)setupNavigationBar
{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem* rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goNext)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)goBack
{
     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)goNext
{
    
}
-(void)selectEffect
{
    [AudioTools sharedInstance].srcFile = [[AudioTools sharedInstance] getRecordPath];
    SelectEffectVc* selectVc = [SelectEffectVc new];
    UINavigationController* navVc = [[UINavigationController alloc] initWithRootViewController:selectVc];
    [self presentViewController:navVc animated:YES completion:^{
        
    }];
}

-(void)record
{
    if (!self.isRecording)
    {
        [self startRecord];
        [self.recordButton setTitle:@"停止录制" forState:UIControlStateNormal];
        
    }else
    {
        [self stopRecord];
        [self.recordButton setTitle:@"开始录制" forState:UIControlStateNormal];
    }
}

-(void)startRecord
{
    self.isRecording = YES;
    if (!_recoder)
       {
           NSString* path = [[AudioTools sharedInstance] getRecordPath];
           [AudioTools sharedInstance].srcFile = path;
           unlink(path.UTF8String);
           NSDictionary *settings = @{AVFormatIDKey:           @(kAudioFormatMPEG4AAC),
                                      AVSampleRateKey:         @(44100.0),
                                      AVNumberOfChannelsKey:   @(1),
                                      AVEncoderBitRateKey:     @(32000)};
           AVAudioSession *session = [AVAudioSession sharedInstance];
           [session setCategory:AVAudioSessionCategoryRecord error:nil];
           [session setActive:YES error:nil];
           _recoder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path] settings:settings error:nil];
           _recoder.delegate = self;
       }
    [_recoder prepareToRecord];
    [_recoder record];
}

-(void)stopRecord
{
    NSLog(@"停止录制文件");
    self.isRecording = NO;
    [_recoder stop];
}

@end
