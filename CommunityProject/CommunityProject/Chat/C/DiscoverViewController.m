//
//  DiscoverViewController.m
//  CommunityProject
//
//  Created by bjike on 17/4/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "DiscoverViewController.h"
#import "InterestCell.h"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DiscoverViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"InterestCell" bundle:nil] forCellReuseIdentifier:@"InterestCell"];
    
}

- (IBAction)friendClick:(id)sender {
    
}
- (IBAction)interestClick:(id)sender {
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"发现" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InterestCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell"];
    
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
