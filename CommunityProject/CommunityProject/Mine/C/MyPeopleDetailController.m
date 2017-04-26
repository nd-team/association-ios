//
//  MyPeopleDetailController.m
//  CommunityProject
//
//  Created by bjike on 17/4/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyPeopleDetailController.h"
#import "TypeAddFriendCell.h"

@interface MyPeopleDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MyPeopleDetailController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.name;
    UIBarButtonItem * backItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x10DB9F) font:16 andTitle:@"返回" andLeft:-15 andTarget:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TypeAddFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TypeAddFriendCell"];
    
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
