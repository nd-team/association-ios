//
//  GroupActivityListController.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GroupActivityListController.h"
#import "ActivityListModel.h"
#import "ActivityListCell.h"
#import "ActivityListDatabaseSingleton.h"
#import "CreateActivityController.h"

#define ActURL @"http://192.168.0.209:90/appapi/app/listActives"
@interface GroupActivityListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;


@end

@implementation GroupActivityListController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
//    if (self.isRef) {
//        [self getActivivtyData];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    self.userID = [userDef objectForKey:@"userId"];
    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getActivivtyData];
    }];
    [self netWork];
}
-(void)netWork{
    AFNetworkReachabilityManager * net = [AFNetworkReachabilityManager sharedManager];
    [net startMonitoring];
    WeakSelf;
    [net setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [weakSelf localData];
        }else{
            [weakSelf getActivivtyData];
        }
    }];
}
-(void)localData{
    ActivityListDatabaseSingleton * single = [ActivityListDatabaseSingleton shareDatabase];
    [self.dataArr addObjectsFromArray:[single searchDatabase]];
    if (self.dataArr.count != 0) {
        [self.tableView reloadData];
    }
}
-(void)getActivivtyData{
    WeakSelf;
    NSDictionary * dict = @{@"groupId":self.groupID,@"userId":self.userID};
    NSSLog(@"%@",dict);
    [AFNetData postDataWithUrl:ActURL andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取活动列表失败%@",error);
        }else{
            if (weakSelf.tableView.mj_header.isRefreshing||weakSelf.dataArr.count != 0) {
                for (ActivityListModel * model in weakSelf.dataArr) {
                    [[ActivityListDatabaseSingleton shareDatabase]deleteDatabase:model];
                }

                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                NSArray * array = jsonDic[@"data"];
                NSSLog(@"%@",array);
                for (NSDictionary * dic in array) {
                    ActivityListModel * model = [[ActivityListModel alloc]initWithDictionary:dic error:nil];
                    [[ActivityListDatabaseSingleton shareDatabase]insertDatabase:model];
                    [weakSelf.dataArr addObject:model];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            }else{
                NSSLog(@"%@",jsonDic[@"msgs"]);
            }
        }
    }];
    
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityListCell"];
    cell.actModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createActivityClick:(id)sender {
    [self performSegueWithIdentifier:@"CreateAct" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"CreateAct"]) {
        CreateActivityController * create = segue.destinationViewController;
        create.groupID = self.groupID;
        create.userID = self.userID;
        [self.navigationController pushViewController:create animated:YES];
    }
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
