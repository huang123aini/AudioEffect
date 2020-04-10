//
//  BiquadTableVc.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/7.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "BiquadTableVc.h"
#import "AudioPlayerVc.h"
#import "AudioTools.h"
#import "BiquadPopVc.h"
#import "UIViewController+HWPopController.h"
@interface BiquadTableVc()

@property(nonatomic,strong)NSMutableArray* demos;

@end

@implementation BiquadTableVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.demos = [NSMutableArray array];
    [self setupNavigationBar];
    NSString* demo1  = @"LOWPASS";
    NSString* demo2  = @"HIGHPASS";
    NSString* demo3  = @"BANDPASS";
    NSString* demo4  = @"NOTCH";
    NSString* demo5  = @"PEAKING";
    NSString* demo6  = @"ALLPASS";
    NSString* demo7  = @"LOWSHELF";
    NSString* demo8  = @"HIGHSHELF";
    [self.demos addObject:demo1];
    [self.demos addObject:demo2];
    [self.demos addObject:demo3];
    [self.demos addObject:demo4];
    [self.demos addObject:demo5];
    [self.demos addObject:demo6];
    [self.demos addObject:demo7];
    [self.demos addObject:demo8];
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
    [[AudioTools sharedInstance] setAudioType:AudioEffectType_BIQUAD];
    [[AudioTools sharedInstance] setBiquadType:(BiquadType)indexPath.row];
    NSLog(@"选取二阶滤波:%@",[self.demos objectAtIndex:indexPath.row]);
    
    BiquadPopVc* biquadVc = [BiquadPopVc new];
    [biquadVc popup];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
