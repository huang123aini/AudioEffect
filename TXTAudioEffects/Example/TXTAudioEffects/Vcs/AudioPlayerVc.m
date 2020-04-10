//
//  AudioPlayerVc.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/7.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "AudioPlayerVc.h"
#import <AVFoundation/AVFoundation.h>
#import <TXTAudioEffects/TXTReEncoder.h>
#import <TXTAudioEffects/TXTAudioEffectsManager.h>

#import "TTScaleSpringButton.h"
#import "AudioTools.h"

@interface AudioPlayerVc ()
{
    AVAudioPlayer* _audioPlayer;
}

@property(nonatomic,strong)TXTReEncoder* reencoder;

@end

@implementation AudioPlayerVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self setupNavigationBar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)setupUI
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgcolor.jpg"]];
    
    TTScaleSpringButton* reencodeButton = [TTScaleSpringButton buttonWithType:UIButtonTypeSystem];
    [reencodeButton setBackgroundImage:[UIImage imageNamed:@"buttoncolor.jpg"] forState:UIControlStateNormal];
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    reencodeButton.frame = CGRectMake(0.5 * width - 100, 0.5 * height - 300, 200, 200);
    [reencodeButton setTitle:@"开始转码" forState:UIControlStateNormal];
    reencodeButton.titleLabel.font = [UIFont systemFontOfSize:25.];
    [reencodeButton addTarget:self action:@selector(startReencode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reencodeButton];
}
-(void)setupNavigationBar
{

    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
      
}

-(void)goBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareEncode
{
    AudioEffectType effectType = [TXTAudioEffectsManager sharedInstance].effectType;
    switch (effectType)
    {
        case AudioEffectType_PITCH:
        {
            [[TXTAudioEffectsManager sharedInstance] initPitch];
            [[TXTAudioEffectsManager sharedInstance] setPitch:[AudioTools sharedInstance].pitchValue];
            break;
        }
        case AudioEffectType_REVERB:
        {
            ReverbType reverbType = [TXTAudioEffectsManager sharedInstance].reverbType;
            [[TXTAudioEffectsManager sharedInstance] initReverb:reverbType];
            break;
        }
        case AudioEffectType_BIQUAD:
        {
            BiquadType biquadType = [TXTAudioEffectsManager sharedInstance].biquadType;
            [[TXTAudioEffectsManager sharedInstance] initBiquad:biquadType];
            break;
        }
            
            
        default:
            break;
    }
}

-(void)startReencode
{
    [self prepareEncode];
    self.reencoder = [TXTReEncoder new];
    NSString* srcFile = [AudioTools sharedInstance].srcFile;
    NSString* desFile = [[AudioTools sharedInstance] getOutputPath];
    
    [self.reencoder reencoder:srcFile output:desFile finish:^(BOOL success, NSError * _Nonnull error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPlayButton];
        });
    }];

}

-(void)setupPlayButton
{
    TTScaleSpringButton* playButton = [TTScaleSpringButton buttonWithType:UIButtonTypeSystem];
    [playButton setBackgroundImage:[UIImage imageNamed:@"buttoncolor.jpg"] forState:UIControlStateNormal];
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    playButton.frame = CGRectMake(0.5 * width - 200, 0.5 * height , 150, 100);
    [playButton setTitle:@"开始播放" forState:UIControlStateNormal];
    playButton.titleLabel.font = [UIFont systemFontOfSize:25.];
    [playButton addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    TTScaleSpringButton* stopButton = [TTScaleSpringButton buttonWithType:UIButtonTypeSystem];
    [stopButton setBackgroundImage:[UIImage imageNamed:@"buttoncolor.jpg"] forState:UIControlStateNormal];
    stopButton.frame = CGRectMake(0.5 * width, 0.5 * height, 150, 100);
    [stopButton setTitle:@"停止播放" forState:UIControlStateNormal];
    stopButton.titleLabel.font = [UIFont systemFontOfSize:25.];
    [stopButton addTarget:self action:@selector(stopPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
}

-(void)startPlay
{
    NSString* filePath = [NSTemporaryDirectory() stringByAppendingFormat:@"output.m4a"];
    NSURL* url = [NSURL fileURLWithPath:filePath];
    NSError* error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}
-(void)stopPlay
{
    [_audioPlayer stop];
}
@end
