//
//  TXTViewController.m
//  TXTAudioEffects
//
//  Created by huangshiping on 11/05/2019.
//  Copyright (c) 2019 huangshiping. All rights reserved.
//

#import "TXTViewController.h"
#import <TXTAudioEffects/TXTReEncoder.h>
#import <TXTAudioEffects/TXTAudioEffectsManager.h>

@interface TXTViewController ()

@property(nonatomic,strong)TXTReEncoder* reencoder;

@end

@implementation TXTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //测试变声
    [[TXTAudioEffectsManager sharedInstance] initPitch];
    
    NSString* srcFile = [[NSBundle mainBundle] pathForResource:@"orig0" ofType:@"m4a"];
    NSString* desFile = [NSTemporaryDirectory() stringByAppendingFormat:@"output.m4a"];
    
    [[TXTAudioEffectsManager sharedInstance] setPitch: 0.5];
    self.reencoder = [TXTReEncoder new];
    [self.reencoder reencoder:srcFile output:desFile finish:^(BOOL success, NSError * _Nonnull error)
     {
        if (success)
        {
            NSLog(@"转码完成---");
        }else
        {
            NSLog(@"转码失败:%@",error);
        }
    }];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
