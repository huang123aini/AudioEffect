//
//  PitchPopVc.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/7.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "PitchPopVc.h"
#import "HWPop.h"
#import "Masonry.h"
#import "BAUISlider.h"
#import "AudioTools.h"
#import <TXTAudioEffectsManager.h>
@interface PitchPopVc ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation PitchPopVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popcolor.jpg"]];
    self.contentSizeInPop = CGSizeMake(350, 200);
    [self setupView];
    [self setupUI];
}

-(void)setupUI
{
    BAUISlider* slider = [[BAUISlider alloc] initWithFrame:CGRectMake(100, 100 ,200, 20)];
    slider.isShowTitle = YES;
    slider.minimumValue = 0.5f;
    slider.maximumValue = 2.f;
    slider.value = [AudioTools sharedInstance].pitchValue;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
}

-(void)sliderChange:(UISlider*)slider
{
    [AudioTools sharedInstance].pitchValue = slider.value;
}

- (void)setupView
{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.doneButton];
    [self setupViewConstraints];
}

- (void)setupViewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.equalTo(@0);
        make.top.equalTo(@10);
    }];

    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.size.equalTo(self.doneButton);
        make.bottom.equalTo(@-10);
        make.left.equalTo(@8);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.cancelButton.mas_right).offset(20);
        make.bottom.equalTo(self.cancelButton);
        make.right.equalTo(@-8);
    }];
}

- (void)didTapToDismiss
{
    [[AudioTools sharedInstance] setAudioType:AudioEffectType_PITCH];
    [self.popController dismiss];
}

#pragma mark - Getter

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"Pitch_Value";
    }
    return _titleLabel;
}

- (UIButton *)doneButton
{
    if (!_doneButton)
    {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"选取变声" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton setBackgroundColor:[UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.00]];
        _doneButton.layer.cornerRadius = 4;
        _doneButton.layer.masksToBounds = YES;
        [_doneButton addTarget:self action:@selector(didTapToDismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消特效" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.00]];
        _cancelButton.layer.cornerRadius = 4;
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton addTarget:self action:@selector(didTapToDismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
