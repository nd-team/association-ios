//
//  VoteTypeController.m
//  LoveChatProject
//
//  Created by bjike on 17/3/7.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "VoteTypeController.h"
#import "VoteTypeCell.h"

@interface VoteTypeController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic,assign)NSInteger lastPath;

@end

@implementation VoteTypeController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投票类型";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    NSInteger row = [DEFAULTS integerForKey:@"indexPath"];
    if (row) {
        self.lastPath = row;
    }
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoteTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VoteTypeCell"];
    cell.nameLabel.text = self.dataArr[indexPath.row];
    if (indexPath.row == self.lastPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VoteTypeCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    VoteTypeCell * lastcell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPath inSection:0]];
    lastcell.accessoryType = UITableViewCellAccessoryNone;
    self.lastPath = indexPath.row;
//保存本地
    [DEFAULTS setInteger:self.lastPath forKey:@"indexPath"];
    [DEFAULTS synchronize];
    self.delegate.chooseType = self.dataArr[indexPath.row];
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"单选",@"多选(不限)"];
    }
    return _dataArr;
}
@end
