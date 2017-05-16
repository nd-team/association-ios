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
#define GroupApplicationURL @"appapi/app/groupApplyUser"
//拉人的申请
#define ApplicationURL @"appapi/app/groupAuditingAllUser"

#define AgreeGroupFriendURL @"appapi/app/checkJoinUser"

@interface GroupMessageController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * dataTwoArr;
@property (nonatomic,copy)NSString * userId;
@end

@implementation GroupMessageController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [DEFAULTS objectForKey:@"userId"];

    [self setUI];
    [self getAllData];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(agreeAddFriend:) name:@"AgreeGroupMessage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(agreeAddFriend:) name:@"OverlookMessage" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AgreeGroupMessage" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"OverlookMessage" object:nil];
}
-(void)agreeAddFriend:(NSNotification *)nofi{
    WeakSelf;
    NSDictionary * dic = [nofi object];
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,AgreeGroupFriendURL] andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"审核群员失败%@",error);
            //  [weakSelf showMessage:@"审核群员失败"];
        }else{
            NSNumber * code = data[@"code"];
            //1拒绝加入2同意3忽略
            if ([code intValue] == 2||[code intValue] == 3) {
                [weakSelf commonDataSendMsg:[NSString stringWithFormat:@"%@已经加入群聊了，可以聊天啦！",dic[@"userId"]] andIdStr:dic[@"groupId"] andType:ConversationType_GROUP];
            }
           else if ([code intValue] == 0){
                // [weakSelf showMessage:@"审核群员失败"];
            }
        }
    }];
    
}
-(void)commonDataSendMsg:(NSString *)textStr andIdStr:(NSString *)idStr andType:(RCConversationType)type{
    WeakSelf;
    RCTextMessage * textMsg = [RCTextMessage messageWithContent:textStr];
    [[RCIM sharedRCIM]sendMessage:type targetId:idStr content:textMsg pushContent:textStr pushData:nil success:^(long messageId) {
        [weakSelf getAllData];

    } error:^(RCErrorCode nErrorCode, long messageId) {
//        [weakSelf showMessage:@"发送消息失败"];
        
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
    NSDictionary * params = @{@"userId":self.userId,@"groupId":self.groupId};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,GroupApplicationURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"群申请获取失败%@",error);
            //            [weakSelf showMessage:@"添加好友列表获取失败"];
        }else{
            if (weakSelf.dataArr.count != 0 || weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            NSSLog(@"%@",data);
            if ([code intValue] == 200) {
                NSArray * msgArr = data[@"data"];
                for (NSDictionary * dic in msgArr) {
                    GroupApplicationModel * search = [[GroupApplicationModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:search];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];

            }else if ([code intValue] == 0){
                //    [weakSelf showMessage:@"没有好友申请"];
            }
            
        }
    }];
    
}
-(void)getTwoData{
    NSDictionary * params = @{@"userId":self.userId,@"groupId":self.groupId};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ApplicationURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"群申请获取失败%@",error);
            //            [weakSelf showMessage:@"添加好友列表获取失败"];
        }else{
            if (weakSelf.dataTwoArr.count != 0 || weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.dataTwoArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            NSSLog(@"%@",data);
            if ([code intValue] == 200) {
                NSArray * msgArr = data[@"data"];
                for (NSDictionary * dic in msgArr) {
                    ApplicationTwoModel * search = [[ApplicationTwoModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataTwoArr addObject:search];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];

            }else if ([code intValue] == 0){
                //    [weakSelf showMessage:@"没有好友申请"];
            }
        }
    }];

}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMessageCell"];
    cell.titleLabel.attributedText = [ImageUrl changeTextColor:[NSString stringWithFormat:@"申请加入 %@",self.groupName] andFirstRangeStr:@"申请加入 " andFirstChangeColor:UIColorFromRGB(0x999999) andSecondRangeStr:self.groupName andSecondColor:UIColorFromRGB(0x333333)];

    if (indexPath.section == 0) {
        cell.groupModel = self.dataArr[indexPath.row];
        cell.dataArr = self.dataArr;
    }else{
        cell.twoModel = self.dataTwoArr[indexPath.row];
        cell.dataTwoArr = self.dataTwoArr;
    }
   
    cell.myTableView = self.tableView;
    cell.groupId = self.groupId;
    
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
//        NSSLog(@"%ld",self.dataArr.count);
        return self.dataArr.count;
    }else{
//        NSSLog(@"==%ld",self.dataTwoArr.count);
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
