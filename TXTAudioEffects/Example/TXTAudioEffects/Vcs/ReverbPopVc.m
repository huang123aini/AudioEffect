//
//  ReverbPopVc.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/8.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "ReverbPopVc.h"
#import "HWPop.h"
#import "Masonry.h"
#import "BAUISlider.h"
#import "AudioTools.h"
#import <TXTAudioEffectsManager.h>
@interface ReverbPopVc ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic,strong)NSMutableDictionary* paramsDic;
@end

NSString* param1 = @"oversamplefactor";
NSString* param2 = @"ertolate";
NSString* param3 = @"erefwet";
NSString* param4 = @"dry";
NSString* param5 = @"ereffactor";
NSString* param6 = @"erefwidth";
NSString* param7 = @"width";
NSString* param8 = @"wet";
NSString* param9 = @"wander";
NSString* param10 = @"bassb";
NSString* param11 = @"spin";
NSString* param12 = @"inputlpf";
NSString* param13 = @"basslpf";
NSString* param14 = @"damplpf";
NSString* param15 = @"outputlpf";
NSString* param16 = @"rt60";
NSString* param17 = @"delay";

@implementation ReverbPopVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popcolor.jpg"]];
    self.contentSizeInPop = CGSizeMake(350, 500);
    [self setupView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupUI];
}

-(void)setupUI
{
    self.paramsDic = [NSMutableDictionary dictionaryWithDictionary:[[TXTAudioEffectsManager sharedInstance] getAdvanceReverbParms]];
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    UIScrollView* scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height - 100)];
    [self.view addSubview:scrollview];
    
    scrollview.contentSize = CGSizeMake(width, height * 2);
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.pagingEnabled = YES;
    scrollview.bounces = NO;
    
    int count = 0;
    
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label1 setText:param1];
    [label1 setFont:[UIFont systemFontOfSize:11]];
    [scrollview addSubview:label1];
    BAUISlider* slider1 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider1.isShowTitle = YES;
    slider1.minimumValue = 1;
    slider1.maximumValue = 4;
    slider1.value = [[self.paramsDic objectForKey:@"oversamplefactor"] intValue];
    [scrollview addSubview:slider1];
    [slider1 addTarget:self action:@selector(slider1Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label2 setText:param2];
    [label2 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label2];
    BAUISlider* slider2 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider2.isShowTitle = YES;
    slider2.minimumValue = 0;
    slider2.maximumValue = 1;
    slider2.value = [[self.paramsDic objectForKey:@"ertolate"] floatValue];
    [scrollview addSubview:slider2];
    [slider2 addTarget:self action:@selector(slider2Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label3 setText:param3];
    [label3 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label3];
    BAUISlider* slider3 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider3.isShowTitle = YES;
    slider3.minimumValue = -70;
    slider3.maximumValue = 10;
    slider3.value = [[self.paramsDic objectForKey:@"erefwet"] floatValue];
    [scrollview addSubview:slider3];
    [slider3 addTarget:self action:@selector(slider3Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label4 setText:param4];
    [label4 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label4];
    BAUISlider* slider4 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider4.isShowTitle = YES;
    slider4.minimumValue = -70;
    slider4.maximumValue = 10;
    slider4.value = [[self.paramsDic objectForKey:@"dry"] floatValue];
    [scrollview addSubview:slider4];
    [slider4 addTarget:self action:@selector(slider4Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label5 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label5 setText:param5];
    [label5 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label5];
    BAUISlider* slider5 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider5.isShowTitle = YES;
    slider5.minimumValue = 0.5f;
    slider5.maximumValue = 2.5f;
    slider5.value = [[self.paramsDic objectForKey:@"ereffactor"] floatValue];
    [scrollview addSubview:slider5];
    [slider5 addTarget:self action:@selector(slider5Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label6 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label6 setText:param6];
    [label6 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label6];
    BAUISlider* slider6 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider6.isShowTitle = YES;
    slider6.minimumValue = -1.f;
    slider6.maximumValue = 1.f;
    slider6.value = [[self.paramsDic objectForKey:@"erefwidth"] floatValue];
    [scrollview addSubview:slider6];
    [slider6 addTarget:self action:@selector(slider6Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label7 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label7 setText:param7];
    [label7 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label7];
    BAUISlider* slider7 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider7.isShowTitle = YES;
    slider7.minimumValue = 0.f;
    slider7.maximumValue = 1.f;
    slider7.value = [[self.paramsDic objectForKey:@"width"] floatValue];
    [scrollview addSubview:slider7];
    [slider7 addTarget:self action:@selector(slider7Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label8 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label8 setText:param8];
    [label8 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label8];
    BAUISlider* slider8 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider8.isShowTitle = YES;
    slider8.minimumValue = -70.f;
    slider8.maximumValue = 10.f;
    slider8.value = [[self.paramsDic objectForKey:@"wet"] floatValue];
    [scrollview addSubview:slider8];
    [slider8 addTarget:self action:@selector(slider8Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label9 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label9 setText:param9];
    [label9 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label9];
    BAUISlider* slider9 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider9.isShowTitle = YES;
    slider9.minimumValue = 0.1f;
    slider9.maximumValue = 0.6f;
    slider9.value = [[self.paramsDic objectForKey:@"wander"] floatValue];
    [scrollview addSubview:slider9];
    [slider9 addTarget:self action:@selector(slider9Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label10 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label10 setText:param10];
    [label10 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label10];
    BAUISlider* slider10 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider10.isShowTitle = YES;
    slider10.minimumValue = 0.f;
    slider10.maximumValue = 0.5f;
    slider10.value = [[self.paramsDic objectForKey:@"bassb"] floatValue];
    [scrollview addSubview:slider10];
    [slider10 addTarget:self action:@selector(slider10Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label11 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label11 setText:param11];
    [label11 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label11];
    BAUISlider* slider11 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider11.isShowTitle = YES;
    slider11.minimumValue = 0.f;
    slider11.maximumValue = 10.f;
    slider11.value = [[self.paramsDic objectForKey:@"spin"] floatValue];
    [scrollview addSubview:slider11];
    [slider11 addTarget:self action:@selector(slider11Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label12 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label12 setText:param12];
    [label12 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label12];
    BAUISlider* slider12 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider12.isShowTitle = YES;
    slider12.minimumValue = 200.f;
    slider12.maximumValue = 18000.f;
    slider12.value = [[self.paramsDic objectForKey:@"inputlpf"] floatValue];
    [scrollview addSubview:slider12];
    [slider12 addTarget:self action:@selector(slider12Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label13 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label13 setText:param13];
    [label13 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label13];
    BAUISlider* slider13 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider13.isShowTitle = YES;
    slider13.minimumValue = 50.f;
    slider13.maximumValue = 1050.f;
    slider13.value = [[self.paramsDic objectForKey:@"basslpf"] floatValue];
    [scrollview addSubview:slider13];
    [slider13 addTarget:self action:@selector(slider13Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label14 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label14 setText:param14];
    [label14 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label14];
    BAUISlider* slider14 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider14.isShowTitle = YES;
    slider14.minimumValue = 200.f;
    slider14.maximumValue = 18000.f;
    slider14.value = [[self.paramsDic objectForKey:@"damplpf"] floatValue];
    [scrollview addSubview:slider14];
    [slider14 addTarget:self action:@selector(slider14Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label15 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label15 setText:param15];
    [label15 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label15];
    BAUISlider* slider15 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider15.isShowTitle = YES;
    slider15.minimumValue = 200.f;
    slider15.maximumValue = 18000.f;
    slider15.value = [[self.paramsDic objectForKey:@"outputlpf"] floatValue];
    [scrollview addSubview:slider15];
    [slider15 addTarget:self action:@selector(slider15Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label16 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label16 setText:param16];
    [label16 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label16];
    BAUISlider* slider16 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider16.isShowTitle = YES;
    slider16.minimumValue = 0.1f;
    slider16.maximumValue = 30.f;
    slider16.value = [[self.paramsDic objectForKey:@"rt60"] floatValue];
    [scrollview addSubview:slider16];
    [slider16 addTarget:self action:@selector(slider16Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
    UILabel* label17 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + count * 50, 80, 50)];
    [label17 setText:param17];
    [label17 setFont:[UIFont systemFontOfSize:15]];
    [scrollview addSubview:label17];
    BAUISlider* slider17 = [[BAUISlider alloc] initWithFrame:CGRectMake(120, 50 + count * 50 ,150, 20)];
    slider17.isShowTitle = YES;
    slider17.minimumValue = -0.5f;
    slider17.maximumValue = 0.5f;
    slider17.value = [[self.paramsDic objectForKey:@"delay"] floatValue];
    [scrollview addSubview:slider17];
    [slider17 addTarget:self action:@selector(slider17Change:) forControlEvents:UIControlEventValueChanged];
    count++;
    
}

-(void)slider1Change:(UISlider*)slider
{
    int val = (int)slider.value;
    [self.paramsDic setValue:@(val) forKey:@"oversamplefactor"];
}

-(void)slider2Change:(UISlider*)slider
{
   [self.paramsDic setValue:@(slider.value) forKey:@"ertolate"];
}
-(void)slider3Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"erefwet"];
}
-(void)slider4Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"dry"];
}
-(void)slider5Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"ereffactor"];
}
-(void)slider6Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"erefwidth"];
}
-(void)slider7Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"width"];
}
-(void)slider8Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"wet"];
}
-(void)slider9Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"wander"];
}
-(void)slider10Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"bassb"];
}
-(void)slider11Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"spin"];
}
-(void)slider12Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"inputlpf"];
}
-(void)slider13Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"basslpf"];
}
-(void)slider14Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"damplpf"];
}
-(void)slider15Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"outputlpf"];
}
-(void)slider16Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"rt60"];
}
-(void)slider17Change:(UISlider*)slider
{
    [self.paramsDic setValue:@(slider.value) forKey:@"delay"];
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
    [TXTAudioEffectsManager sharedInstance].advanceReverbParms = self.paramsDic;
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
        _titleLabel.text = @"混响";
    }
    return _titleLabel;
}

- (UIButton *)doneButton
{
    if (!_doneButton)
    {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"选取混响" forState:UIControlStateNormal];
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

