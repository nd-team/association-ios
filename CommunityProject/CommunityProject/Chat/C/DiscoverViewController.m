//
//  DiscoverViewController.m
//  CommunityProject
//
//  Created by bjike on 17/4/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "DiscoverViewController.h"
#import "InterestCell.h"
#import "InterestTeamController.h"
#import "InterestModel.h"
#import "AddFriendController.h"

#define InterestURL @"appapi/app/hobbyGroupList"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

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
    [self getInterestListData:@"1"];
}
#pragma mark-获取数据
-(void)getInterestListData:(NSString *)hobby{
    WeakSelf;
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,InterestURL] andParams:@{@"userId":userId,@"hobbyId":hobby} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取群组列表失败%@",error);
        }else{
            //保存到数据库里
            if (weakSelf.dataArr.count != 0) {
                //                for (InterestModel * model in weakSelf.rightArr) {
                //
                //                }
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    InterestModel * model = [[InterestModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:model];
                }
                [weakSelf.tableView reloadData];
            }
            
        }
        
    }];
}

- (IBAction)friendClick:(id)sender {
    
}
- (IBAction)interestClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"WeChat" bundle:nil];
    InterestTeamController * interest = [sb instantiateViewControllerWithIdentifier:@"InterestTeamController"];
    [self.navigationController pushViewController:interest animated:YES];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InterestCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell"];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    cell.interestModel = self.dataArr[indexPath.row];
    WeakSelf;
    cell.block = ^(UIViewController *vc){
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InterestModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    AddFriendController * add = [sb instantiateViewControllerWithIdentifier:@"AddFriendController"];
    add.buttonName = @"申请加群";
    add.groupId = model.groupId;
    [self.navigationController pushViewController:add animated:YES];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
