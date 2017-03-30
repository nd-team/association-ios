//
//  GroupMessageController.m
//  CommunityProject
//
//  Created by bjike on 17/3/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GroupMessageController.h"
#import "GroupMessageCell.h"
#import "GroupApplicationModel.h"
#import "ApplicationTwoModel.h"
//有留言的申请
#define GroupApplicationURL @"http://192.168.0.209:90/appapi/app/groupApplyUser"
//拉人的申请
#define ApplicationURL @"http://192.168.0.209:90/appapi/app/groupAuditingAllUser"

#define AgreeGroupFriendURL @"http://192.168.0.209:90/appapi/app/checkJoinUser"

@interface GroupMessageController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * dataTwoArr;

@end

@implementation GroupMessageController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(agreeAddFriend:) name:@"AgreeGroupMessage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(disagreePerson:) name:@"OverlookMessage" object:nil];

    [self getAllData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AgreeGroupMessage" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"OverlookMessage" object:nil];
}
-(void)agreeAddFriend:(NSNotification *)nofi{
    WeakSelf;
    NSDictionary * dic = [nofi object];
    [AFNetData postDataWithUrl:AgreeGroupFriendURL andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"同意添加好友失败%@",error);
            //  [weakSelf showMessage:@"同意添加好友失败"];
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSSLog(@"%@",jsonDic);
            NSNumber * code = jsonDic[@"code"];
            //1拒绝加入2同意3忽略
            if ([code intValue] == 2) {
                [weakSelf getAllData];
            }else if ([code intValue] == 0){
                // [weakSelf showMessage:@"同意添加好友失败"];
            }
        }
    }];
    
}
-(void)disagreePerson:(NSNotification *)nofi{
    WeakSelf;
    NSDictionary * dic = [nofi object];
    [AFNetData postDataWithUrl:AgreeGroupFriendURL andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"同意添加好友失败%@",error);
            // [weakSelf showMessage:@"同意添加好友失败"];
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSSLog(@"%@",jsonDic);
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 3) {
                [weakSelf getAllData];
            }else if ([code intValue] == 0){
                //[weakSelf showMessage:@"同意添加好友失败"];
            }
        }
    }];

}
-(void)getAllData{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    WeakSelf;
    dispatch_group_async(group,queue , ^{
        [weakSelf getApplicationGroupList];
    });
    dispatch_group_async(group,queue , ^{
        [weakSelf getTwoData];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    });

}
-(void)setUI{
    self.navigationItem.title = @"进群申请";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getAllData];
    }];
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getApplicationGroupList{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    NSDictionary * params = @{@"userId":userId,@"group_id":self.groupId};
    WeakSelf;
    [AFNetData postDataWithUrl:GroupApplicationURL andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"群申请获取失败%@",error);
            //            [weakSelf showMessage:@"添加好友列表获取失败"];
        }else{
            if (weakSelf.dataArr.count != 0 || weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                NSArray * msgArr = jsonDic[@"data"];
                for (NSDictionary * dic in msgArr) {
                    GroupApplicationModel * search = [[GroupApplicationModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:search];
                }
            }else if ([code intValue] == 0){
                //    [weakSelf showMessage:@"没有好友申请"];
            }
            
        }
    }];
    
}
-(void)getTwoData{
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary * params = @{@"userId":userId,@"groupId":self.groupId};
    WeakSelf;
    [AFNetData postDataWithUrl:ApplicationURL andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"群申请获取失败%@",error);
            //            [weakSelf showMessage:@"添加好友列表获取失败"];
        }else{
            if (weakSelf.dataTwoArr.count != 0 || weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.dataTwoArr removeAllObjects];
            }
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            NSSLog(@"%@",jsonDic);
            if ([code intValue] == 200) {
                NSArray * msgArr = jsonDic[@"data"];
                for (NSDictionary * dic in msgArr) {
                    ApplicationTwoModel * search = [[ApplicationTwoModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataTwoArr addObject:search];
                }
            }else if ([code intValue] == 0){
                //    [weakSelf showMessage:@"没有好友申请"];
            }
        }
    }];

}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMessageCell"];
    cell.titleLabel.attributedText = [ImageUrl changeTextColor:[NSString stringWithFormat:@"申请加入 %@",self.groupName] andColor:UIColorFromRGB(0x999999) andRangeStr:self.groupName andChangeColor:UIColorFromRGB(0x333333)];
  
    if (indexPath.section == 0) {
        cell.groupModel = self.dataArr[indexPath.row];
        cell.dataArr = self.dataArr;
//        cell.isFirst = YES;
    }else{
        cell.twoModel = self.dataTwoArr[indexPath.row];
        cell.dataTwoArr = self.dataTwoArr;
//        cell.isFirst = NO;
    }
   
    cell.myTableView = self.tableView;
    cell.groupId = self.groupId;
    
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArr.count;
    }else{
        return self.dataTwoArr.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

-(NSMutableArray *)dataTwoArr{
    if (!_dataTwoArr) {
        _dataTwoArr = [NSMutableArray new];
    }
    return _dataTwoArr;
}
@end
