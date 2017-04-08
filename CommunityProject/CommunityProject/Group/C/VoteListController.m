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
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"群投票";
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,60, 40) titleColor:UIColorFromRGB(0x121212) font:14 andTitle:@"新建投票" and:self Action:@selector(rightClick)];
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
                NSSLog(@"%@",arr);
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
