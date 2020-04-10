//
//  FileTableVc.m
//  TXTAudioEffects_Example
//
//  Created by huangshiping on 2019/11/6.
//  Copyright © 2019 huangshiping. All rights reserved.
//

#import "FileTableVc.h"
#import "AudioTools.h"
#import "SelectEffectVc.h"
@interface FileTableVc()

@property(nonatomic,strong)NSMutableArray* demos;

@end

@implementation FileTableVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.demos = [NSMutableArray array];
    [self setupNavigationBar];
    
    NSString* demo1  = @"orig0.m4a";
    [self.demos addObject:demo1];
 
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
    SelectEffectVc* effectVc = [SelectEffectVc new];
    UINavigationController* navVc = [[UINavigationController alloc] initWithRootViewController:effectVc];
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
    NSString* fileName = [self.demos objectAtIndex:indexPath.row];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    [AudioTools sharedInstance].srcFile = filePath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
