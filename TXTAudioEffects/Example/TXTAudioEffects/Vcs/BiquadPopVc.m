//
//  BiquadPopVc.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/8.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "BiquadPopVc.h"
#import "HWPop.h"
#import "Masonry.h"
#import "BAUISlider.h"
#import "AudioTools.h"
#import <TXTAudioEffectsManager.h>
@interface BiquadPopVc ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSMutableDictionary* biquadParams;

@end

@implementation BiquadPopVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popcolor.jpg"]];
    self.contentSizeInPop = CGSizeMake(350, 400);
    [self setupView];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupUI];
}

-(void)setupUI
{
    self.biquadParams = [NSMutableDictionary dictionaryWithDictionary: [[TXTAudioEffectsManager sharedInstance] getDefaultBiquadParams]];
    
    NSString* title1 = nil;
    NSString* title2 = nil;
    NSString* title3 = nil;
    BiquadType biquadType = [AudioTools sharedInstance].getBiquadType;
    switch (biquadType)
    {
        case BiquadType_LOWPASS:
        case BiquadType_HIGHPASS:
        {
            title1 = @"cutoff";
            title2 = @"resonance";
            break;
        }
        case BiquadType_BANDPASS:
        case BiquadType_NOTCH:
        case BiquadType_ALLPASS:
        {
            title1 = @"freq";
            title2 = @"Q";
            break;
        }
        case BiquadType_PEAKING:
        case BiquadType_LOWSHELF:
        case BiquadType_HIGHSHELF:
        {
            title1 = @"freq";
            title2 = @"Q";
            title3 = @"gain";
            break;
        }
        default:
            break;
    }
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 80, 50)];
    [label1 setText:title1];
    [label1 setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:label1];
    BAUISlider* slider1 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 100 ,150, 20)];
    slider1.isShowTitle = YES;
    slider1.minimumValue = 200.f;
    slider1.maximumValue = 3000.f;
    slider1.value = [[self.biquadParams objectForKey:@"freq"] floatValue];
    [self.view addSubview:slider1];
    [slider1 addTarget:self action:@selector(slider1Change:) forControlEvents:UIControlEventValueChanged];
  
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 180, 80, 50)];
    [label2 setText:title2];
    [label2 setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:label2];
    BAUISlider* slider2 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 200 ,150, 20)];
    slider2.isShowTitle = YES;
    slider2.minimumValue = 0.f;
    slider2.maximumValue = 1.f;
    slider2.value = [[self.biquadParams objectForKey:@"Q"] floatValue];
    [self.view addSubview:slider2];
    [slider2 addTarget:self action:@selector(slider2Change:) forControlEvents:UIControlEventValueChanged];
    if (title3 != nil)
    {
        UILabel* label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 280, 80, 50)];
        [label3 setText:title3];
        [label3 setFont:[UIFont systemFontOfSize:16]];
        [self.view addSubview:label3];
        BAUISlider* slider3 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 300 ,150, 20)];
        slider3.isShowTitle = YES;
        slider3.minimumValue = -5.f;
        slider3.maximumValue = 10.f;
        slider3.value = [[self.biquadParams objectForKey:@"gain"] floatValue];
        [self.view addSubview:slider3];
        [slider3 addTarget:self action:@selector(slider3Change:) forControlEvents:UIControlEventValueChanged];
    }
}

-(void)slider1Change:(UISlider*)slider
{
    [self.biquadParams setValue:@(slider.value) forKey:@"freq"];
}

-(void)slider2Change:(UISlider*)slider
{
    [self.biquadParams setValue:@(slider.value) forKey:@"Q"];
}
-(void)slider3Change:(UISlider*)slider
{
    [self.biquadParams setValue:@(slider.value) forKey:@"gain"];
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
        _titleLabel.text = @"二阶滤波";
    }
    return _titleLabel;
}

- (UIButton *)doneButton
{
    if (!_doneButton)
    {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"选取二阶滤波" forState:UIControlStateNormal];
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
