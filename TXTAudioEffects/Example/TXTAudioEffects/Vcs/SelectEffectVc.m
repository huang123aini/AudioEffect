//
//  SelectEffectVc.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/6.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "SelectEffectVc.h"
#import "TTScaleSpringButton.h"
#import "UIViewController+HWPopController.h"
#import "ReverbTableVc.h"
#import "BiquadTableVc.h"

#import "PitchPopVc.h"
#import "BiquadPopVc.h"
#import "AudioPlayerVc.h"
@interface SelectEffectVc ()

@end

@implementation SelectEffectVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgcolor2.jpg"]];
    [self setupUI];
    [self setupNavigationBar];
}

-(void)setupUI
{
    int width = self.view.frame.size.width;
    TTScaleSpringButton* pitchBtn = [TTScaleSpringButton buttonWithType:UIButtonTypeSystem];
    [pitchBtn setBackgroundImage:[UIImage imageNamed:@"buttoncolor.jpg"] forState:UIControlStateNormal];
    pitchBtn.frame = CGRectMake(0.5 * width - 100, 80,200, 50);
    [pitchBtn setTitle:@"变声" forState:UIControlStateNormal];
    pitchBtn.titleLabel.font = [UIFont systemFontOfSize:25.];
    [pitchBtn addTarget:self action:@selector(gotoPitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pitchBtn];
    
    TTScaleSpringButton* reverbBtn = [TTScaleSpringButton buttonWithType:UIButtonTypeSystem];
    [reverbBtn setBackgroundImage:[UIImage imageNamed:@"buttoncolor.jpg"] forState:UIControlStateNormal];
    reverbBtn.frame = CGRectMake(0.5 * width - 100, 155,200, 50);
    [reverbBtn setTitle:@"混响" forState:UIControlStateNormal];
    reverbBtn.titleLabel.font = [UIFont systemFontOfSize:25.];
    [reverbBtn addTarget:self action:@selector(gotoReverb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reverbBtn];
    
    TTScaleSpringButton* biquadBtn = [TTScaleSpringButton buttonWithType:UIButtonTypeSystem];
    [biquadBtn setBackgroundImage:[UIImage imageNamed:@"buttoncolor.jpg"] forState:UIControlStateNormal];
    biquadBtn.frame = CGRectMake(0.5 * width - 100, 230,200, 50);
    [biquadBtn setTitle:@"二阶滤波" forState:UIControlStateNormal];
    biquadBtn.titleLabel.font = [UIFont systemFontOfSize:25.];
    [biquadBtn addTarget:self action:@selector(gotoBiquad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:biquadBtn];
    
    TTScaleSpringButton* vibratoBtn = [TTScaleSpringButton buttonWithType:UIButtonTypeSystem];
    [vibratoBtn setBackgroundImage:[UIImage imageNamed:@"buttoncolor.jpg"] forState:UIControlStateNormal];
    vibratoBtn.frame = CGRectMake(0.5 * width - 100, 305,200, 50);
    [vibratoBtn setTitle:@"颤音" forState:UIControlStateNormal];
    vibratoBtn.titleLabel.font = [UIFont systemFontOfSize:25.];
    [vibratoBtn addTarget:self action:@selector(gotoVibrato) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vibratoBtn];
    
}

-(void)setupNavigationBar
{

    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goNext)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

-(void)goBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)goNext
{
    AudioPlayerVc* audioPlayerVc = [AudioPlayerVc new];
    UINavigationController* navVc = [[UINavigationController alloc] initWithRootViewController:audioPlayerVc];
    [self.navigationController presentViewController:navVc animated:YES completion:^{
        
    }];
}

-(void)gotoPitch
{
    PitchPopVc *pitchPopVc= [PitchPopVc new];
    [pitchPopVc popup];
}
-(void)gotoReverb
{
    ReverbTableVc* reverbVc = [ReverbTableVc new];
    UINavigationController* navVc = [[UINavigationController alloc] initWithRootViewController:reverbVc];
    [self presentViewController:navVc animated:YES completion:^{
        
    }];
}
-(void)gotoBiquad
{
    BiquadTableVc* biquadVc = [BiquadTableVc new];
    UINavigationController* navVc = [[UINavigationController alloc] initWithRootViewController:biquadVc];
    [self presentViewController:navVc animated:YES completion:^{

    }];
}
-(void)gotoVibrato
{
    
}

@end
