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
#import "ActivityDetailController.h"

#define ActURL @"appapi/app/listActives"
@interface GroupActivityListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;


@end

@implementation GroupActivityListController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.isRef) {
        [self getActivivtyData];
    }
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
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ActURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取活动列表失败%@",error);
            [weakSelf showMessage:@"服务器出问题咯"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            if (weakSelf.tableView.mj_header.isRefreshing||weakSelf.dataArr.count != 0) {
                for (ActivityListModel * model in weakSelf.dataArr) {
                    [[ActivityListDatabaseSingleton shareDatabase]deleteDatabase:model];
                }

                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * array = data[@"data"];
                for (NSDictionary * dic in array) {
                    ActivityListModel * model = [[ActivityListModel alloc]initWithDictionary:dic error:nil];
                    [[ActivityListDatabaseSingleton shareDatabase]insertDatabase:model];
                    [weakSelf.dataArr addObject:model];
                }
            }else{
                [weakSelf showMessage:[NSString stringWithFormat:@"%@,下拉加载重试",data[@"msgs"]]];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];

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
    ActivityListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    ActivityDetailController * act = [sb instantiateViewControllerWithIdentifier:@"ActivityDetailController"];
    act.actives_id = model.activesId;
    NSArray * bigTime = [ImageUrl cutString:model.activesStart];
    NSArray * bigEndTime = [ImageUrl cutString:model.activesEnd];
    NSArray * month = [ImageUrl cutBigTime:bigTime[0]];
    NSArray * monthEnd = [ImageUrl cutBigTime:bigEndTime[0]];
    NSArray * hour = [ImageUrl cutSmallTime:bigTime[1]];
    NSArray * hourEnd = [ImageUrl cutSmallTime:bigEndTime[1]];
    act.time = [NSString stringWithFormat:@"%02d月%02d日 %02d:%02d-%02d月%02d日 %02d:%02d",[month[1] intValue],[month[2]intValue],[hour[0] intValue],[hour[1]intValue],[monthEnd[1] intValue],[monthEnd[2]intValue],[hourEnd[0]intValue],[hourEnd[1]intValue]];
    act.area = model.activesAddress;
    act.recomend = model.activesContent;
    act.headStr = model.activesImage;
    act.titleStr = model.activesTitle;
    act.listDelegate = self;
    if ([model.status isEqualToString:@"1"]) {
        act.isSign = YES;
    }else{
        act.isSign = NO;
    }
    NSString * detailTime = [NowDate currentDetailTime];
    NSComparisonResult result = [detailTime compare:model.activesClosing];
    if (result == NSOrderedDescending){
     //已结束
        act.isOver = YES;
    }else{
        //进行中
        act.isOver = NO;
    }

    [self.navigationController pushViewController:act animated:YES];

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
        create.delegate = self;
    }
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
