//
//  MessageViewController.m
//  CommunityProject
//
//  Created by bjike on 17/3/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "ApplicationFriendsModel.h"
#import "ApplicationDatabaseSingle.h"

#define ApplicationURL @"appapi/app/allAddfriendRequest"
#define AddFriendURL @"appapi/app/confirmFriend"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MessageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(agreeAddFriend:) name:@"AgreeFriend" object:nil];

    NSInteger status = [[RCIMClient sharedRCIMClient]getCurrentNetworkStatus];
    if (status == 0) {
//无网
        [self localData];
    }else{
        [self getApplicationFriendList];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AgreeFriend" object:nil];
}
-(void)agreeAddFriend:(NSNotification *)nofi{
    WeakSelf;
    NSDictionary * dic = [nofi object];
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,AddFriendURL] andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"同意添加好友失败%@",error);
            [weakSelf showMessage:@"同意添加好友失败"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //申请人发送消息
                [weakSelf commonDataSendMsg:@"我们已经是好友了，可以聊天啦！" andIdStr:dic[@"friendUserId"] andType:ConversationType_PRIVATE];

            }else if ([code intValue] == 100){
                [weakSelf showMessage:@"已经是好友咯"];
            }else if ([code intValue] == 0){
                [weakSelf showMessage:@"同意添加好友失败"];
            }
        }
    }];
    
}
-(void)commonDataSendMsg:(NSString *)textStr andIdStr:(NSString *)idStr andType:(RCConversationType)type{
    WeakSelf;
    RCTextMessage * textMsg = [RCTextMessage messageWithContent:textStr];
    [[RCIM sharedRCIM]sendMessage:type targetId:idStr content:textMsg pushContent:textStr pushData:nil success:^(long messageId) {
        [weakSelf getApplicationFriendList];
    } error:^(RCErrorCode nErrorCode, long messageId) {
        [weakSelf showMessage:@"发送消息失败"];
        
    }];
}

-(void)localData{
    ApplicationDatabaseSingle * single = [ApplicationDatabaseSingle shareDatabase];
    [self.dataArr addObjectsFromArray:[single searchDatabase]];
    if (self.dataArr.count != 0) {
        [self.tableView reloadData];
    }
}
-(void)setUI{
    self.navigationItem.title = @"消息";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getApplicationFriendList];
    }];
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getApplicationFriendList{
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary * params = @{@"userId":userId};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ApplicationURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"添加好友列表获取失败%@",error);
            [weakSelf showMessage:@"服务器出问题咯"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            if (weakSelf.dataArr.count != 0 || weakSelf.tableView.mj_header.isRefreshing) {
                for (ApplicationFriendsModel * model in weakSelf.dataArr) {
                    [[ApplicationDatabaseSingle shareDatabase]deleteDatabase:model];
                }
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * msgArr = data[@"data"];
                for (NSDictionary * dic in msgArr) {
                    ApplicationFriendsModel * search = [[ApplicationFriendsModel alloc]initWithDictionary:dic error:nil];
                    [[ApplicationDatabaseSingle shareDatabase]insertDatabase:search];
                    [weakSelf.dataArr addObject:search];
                }
            }else if ([code intValue] == 0){
                [weakSelf showMessage:@"加载好友申请失败，下拉加载重试"];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            
        }
    }];
    
}
-(void)showMessage:(NSString *)msg{
    UIView * msgView = [UIView showViewTitle:msg];
    [self.view addSubview:msgView];
    [UIView animateWithDuration:1.0 animations:^{
        msgView.frame = CGRectMake(20, KMainScreenHeight-150, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
        //完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    cell.appModel = self.dataArr[indexPath.row];
    cell.myTableView = self.tableView;
    cell.dataArr = self.dataArr;
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
