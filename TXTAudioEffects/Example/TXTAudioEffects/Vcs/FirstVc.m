//
//  FirstVc.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/6.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "FirstVc.h"
#import "ACPButton.h"
#import "RecordVc.h"
#import "FileTableVc.h"
@interface FirstVc ()

@end

@implementation FirstVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self setupUI];
    
}
-(void)setupUI
{
    ACPButton* fileButton = [ACPButton buttonWithType:UIButtonTypeSystem];
    [fileButton setStyleWithImage:@"cont-bt_normal.png" highlightedImage:@"cont-bt_normal.png" disableImage:nil andInsets:UIEdgeInsetsMake(19, 7, 19, 7)];
    [fileButton setLabelTextShadow:CGSizeMake(-1, -1) normalColor:[UIColor blackColor] highlightedColor:nil disableColor:nil];
    [fileButton setLabelFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:20]];
    [fileButton setGlowHighlightedState:YES];
    
    int width = self.view.frame.size.width;
    [fileButton setFrame:CGRectMake(0.5 * width - 100, 100, 200, 200)];
    [fileButton setTitle:@"文件" forState:UIControlStateNormal];
    [self.view addSubview:fileButton];
    [fileButton addTarget:self action:@selector(gotoFileVc) forControlEvents:UIControlEventTouchUpInside];
    
    ACPButton* recordButton = [ACPButton buttonWithType:UIButtonTypeSystem];
    [recordButton setStyleWithImage:@"cont-bt_normal.png" highlightedImage:@"cont-bt_normal.png" disableImage:nil andInsets:UIEdgeInsetsMake(19, 7, 19, 7)];
    [recordButton setLabelTextShadow:CGSizeMake(-1, -1) normalColor:[UIColor blackColor] highlightedColor:nil disableColor:nil];
    [recordButton setLabelFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:20]];
    [recordButton setGlowHighlightedState:YES];
    [recordButton setFrame:CGRectMake(0.5 * width - 100, 350, 200, 200)];
    [recordButton setTitle:@"录音" forState:UIControlStateNormal];
    [self.view addSubview:recordButton];
    [recordButton addTarget:self action:@selector(gotoRecordVc) forControlEvents:UIControlEventTouchUpInside];
}

-(void)gotoFileVc
{
    FileTableVc* fileVc = [FileTableVc new];
    UINavigationController* navC = [[UINavigationController alloc] initWithRootViewController:fileVc];
    [self presentViewController:navC animated:YES completion:^{
        
    }];
}
-(void)gotoRecordVc
{
    RecordVc* recordVc = [RecordVc new];
     UINavigationController* navC = [[UINavigationController alloc] initWithRootViewController:recordVc];
    [self presentViewController:navC animated:YES completion:^{
        
    }];
}
@end
