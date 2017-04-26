//
//  VoteListController.m
//  CommunityProject
//
//  Created by bjike on 17/4/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "VoteListController.h"
#import "VoteListModel.h"
#import "VoteListCell.h"
#import "VoteViewController.h"
#import "VoteDetailController.h"

#define VoteListURL @"appapi/app/voteList"

@interface VoteListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation VoteListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBar];
    //本地保存
    [self getVoteList];
}
-(void)setBar{
    //导航栏按钮 创建群组
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"群投票";
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,60, 40) titleColor:UIColorFromRGB(0x121212) font:14 andTitle:@"新建投票" andLeft:15 andTarget:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getVoteList];
    }];

}
-(void)getVoteList{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,VoteListURL] andParams:@{@"groupId":self.groupId,@"userId":userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取投票列表失败%@",error);
        }else{
            if (weakSelf.tableView.mj_header.isRefreshing || weakSelf.dataArr.count != 0) {
                
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    VoteListModel * model = [[VoteListModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:model];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            }
            
        }
    }];

}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightClick{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    VoteViewController * vote = [sb instantiateViewControllerWithIdentifier:@"VoteViewController"];
    vote.delegate = self;
    vote.groupID = self.groupId;
    vote.groupName = self.groupName;
    [self.navigationController pushViewController:vote animated:YES];

}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoteListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VoteListCell"];
    cell.voteModel = self.dataArr[indexPath.row];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    cell.groupID = self.groupId;
    cell.listVC = self;
    WeakSelf;
    cell.block = ^(UIViewController * vc){
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VoteListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    VoteDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"VoteDetailController"];
    detail.groupID = self.groupId;
    detail.voteID = model.voteId;
    detail.createTime = model.addTime;
    int timeStatus = [model.timeStatus intValue];
    int status = [model.status intValue];
    if (timeStatus == 0) {
        //活动已结束
        detail.statusStr = @"活动结束";
    }else{
        //进行中
        detail.statusStr = @"进行中";
    }
    if (status == 0) {
        detail.isVote = NO;
    }else{
        detail.isVote = YES;
    }
    detail.topic = model.voteTitle;
    detail.topicUrl = model.voteImage;
    detail.endTime = model.endTime;
    detail.delegate = self;
    [self.navigationController pushViewController:detail animated:YES];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.isRef) {
        [self getVoteList];
    }
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
