//
//  MyClaimController.m
//  CommunityProject
//
//  Created by bjike on 17/5/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyClaimController.h"
#import "MyClaimCell.h"
#import "ClaimCenterModel.h"
#define ClaimURL @"appapi/app/allFriendsClaim"

@interface MyClaimController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MyClaimController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的认领";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getClaimData];
    }];
    [self getClaimData];
}
-(void)getClaimData{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    NSDictionary * params = @{@"userId":userId,@"status":@"1"};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ClaimURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"未认领用户数据请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            if (weakSelf.dataArr.count !=0||weakSelf.tableView.mj_header.isRefreshing) {
                
                [weakSelf.dataArr removeAllObjects];
                
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    ClaimCenterModel * model = [[ClaimCenterModel alloc]initWithDictionary:dic error:nil];
                    [self.dataArr addObject:model];
                }
            }else{
                [weakSelf showMessage:@"加载我的认领失败，下拉刷新重试"];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    }];
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyClaimCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyClaimCell"];
    cell.claimModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //
    return self.dataArr.count;
    
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
