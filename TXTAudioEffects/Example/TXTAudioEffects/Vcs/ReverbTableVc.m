//
//  ReverbTableVc.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/7.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "ReverbTableVc.h"
#import "AudioPlayerVc.h"
#import "AudioTools.h"
#import "ReverbPopVc.h"
#import "UIViewController+HWPopController.h"

@interface ReverbTableVc()

@property(nonatomic,strong)NSMutableArray* demos;

@end

@implementation ReverbTableVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.demos = [NSMutableArray array];
    [self setupNavigationBar];
    NSString* demo1  = @"ADVANCE";
    NSString* demo2  = @"DEFAULT";
    NSString* demo3  = @"SMALLHALL1";
    NSString* demo4  = @"SMALLHALL2";
    NSString* demo5  = @"MEDIUMHALL1";
    NSString* demo6  = @"MEDIUMHALL2";
    NSString* demo7  = @"LARGEHALL1";
    NSString* demo8  = @"LARGEHALL2";
    NSString* demo9  = @"SMALLROOM1";
    NSString* demo10  = @"SMALLROOM2";
    NSString* demo11 = @"MEDIUMROOM1";
    NSString* demo12 = @"MEDIUMROOM2";
    NSString* demo13 = @"LARGEROOM1";
    NSString* demo14 = @"LARGEROOM2";
    NSString* demo15 = @"MEDIUMER1";
    NSString* demo16 = @"MEDIUMER2";
    NSString* demo17 = @"PLATEHIGH";
    NSString* demo18 = @"PLATELOW";
    NSString* demo19 = @"LONGREVERB1";
    NSString* demo20 = @"LONGREVERB2";
    
    [self.demos addObject:demo1];
    [self.demos addObject:demo2];
    [self.demos addObject:demo3];
    [self.demos addObject:demo4];
    [self.demos addObject:demo5];
    [self.demos addObject:demo6];
    [self.demos addObject:demo7];
    [self.demos addObject:demo8];
    [self.demos addObject:demo9];
    [self.demos addObject:demo10];
    [self.demos addObject:demo11];
    [self.demos addObject:demo12];
    [self.demos addObject:demo13];
    [self.demos addObject:demo14];
    [self.demos addObject:demo15];
    [self.demos addObject:demo16];
    [self.demos addObject:demo17];
    [self.demos addObject:demo18];
    [self.demos addObject:demo19];
    [self.demos addObject:demo20];
    
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
    AudioPlayerVc* audioPlayerVc = [AudioPlayerVc new];
    UINavigationController* navVc = [[UINavigationController alloc] initWithRootViewController:audioPlayerVc];
    [self.navigationController presentViewController:navVc animated:YES completion:^{
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    
    cell.textLabel.text = [self.demos objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[AudioTools sharedInstance] setAudioType:AudioEffectType_REVERB];
    [[AudioTools sharedInstance] setReverbType:(ReverbType)indexPath.row];
    NSLog(@"选取混响:%@",[self.demos objectAtIndex:indexPath.row]);
    if ([AudioTools sharedInstance].getReverbType == ReverbType_ADVANCE)
    {
        ReverbPopVc* revervPopVc = [ReverbPopVc new];
        [revervPopVc popup];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
