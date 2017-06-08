//
//  MyJoinActivityController.m
//  CommunityProject
//
//  Created by bjike on 17/5/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyJoinActivityController.h"
#import "ActCommonListCell.h"
#import "PlatformActListModel.h"
#import "PlatformDetailController.h"

#define JoinURL @"appapi/app/selectJoinPlatformActives"
@interface MyJoinActivityController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MyJoinActivityController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我参与的活动";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x121212);
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 40, 40) andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"ActCommonListCell" bundle:nil] forCellReuseIdentifier:@"JoinActListCell"];
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getJoinActListData];
    }];
    self.tableView.mj_footer.hidden = YES;
}
-(void)getJoinActListData{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    NSDictionary * params = @{@"userId":userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,JoinURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"我参与的平台活动数据请求失败：%@",error);
        }else{
            if (weakSelf.tableView.mj_header.isRefreshing||self.dataArr.count != 0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dict in arr) {
                    PlatformActListModel * model = [[PlatformActListModel alloc]initWithDictionary:dict error:nil];
                    [self.dataArr addObject:model];
                }
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }else{
                NSSLog(@"我参与的请求平台活动数据失败");
            }
        }
    }];
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActCommonListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JoinActListCell"];
    cell.actModel = self.dataArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlatformActListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
    PlatformDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"PlatformDetailController"];
    detail.idStr = [NSString stringWithFormat:@"%ld",(long)model.id];
    [self.navigationController pushViewController:detail animated:YES];

}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
