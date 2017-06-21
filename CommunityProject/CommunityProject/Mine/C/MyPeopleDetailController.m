//
//  MyPeopleDetailController.m
//  CommunityProject
//
//  Created by bjike on 17/4/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyPeopleDetailController.h"
#import "TypeAddFriendCell.h"
#import "MyPeopleListModel.h"
#import "UnknownFriendDetailController.h"
#import "FriendDetailController.h"

#define RelationshipURL @"appapi/app/relationship"
#define FriendDetailURL @"appapi/app/selectUserInfo"
#define TESTURL @"appapi/app/CheckMobile"

@interface MyPeopleDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * userId;

@end

@implementation MyPeopleDetailController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.name;
    UIBarButtonItem * backItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x10DB9F) font:16 andTitle:@"返回" andLeft:-15 andTarget:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    //刷新列表
    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFriend:) name:@"RecommendAddFriend" object:nil];
    
    [self getData];
}
-(void)addFriend:(NSNotification *)nofi{
    [self pushFriendId:NO andUserId:[nofi object]];

}
-(void)getData{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,RelationshipURL] andParams:@{@"userId":self.userId,@"type":self.type} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"人脉关系请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            if (weakSelf.dataArr.count != 0||weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * subDic in arr) {
                    MyPeopleListModel * model = [[MyPeopleListModel alloc]initWithDictionary:subDic error:nil];
                    [weakSelf.dataArr addObject:model];
                }
            }else{
                [weakSelf showMessage:@"加载人脉列表失败，下拉刷新重试！"];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];

        }
    }];

}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TypeAddFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TypeAddFriendCell"];
    cell.listModel = self.dataArr[indexPath.row];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyPeopleListModel * model = self.dataArr[indexPath.row];
    if ([model.status isEqualToString:@"1"]) {
        [self pushFriendId:YES andUserId:model.userId];

    }else{
        [self pushFriendId:NO andUserId:model.userId];

    }
}
-(void)pushFriendId:(BOOL)isFriend andUserId:(NSString *)userId{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendDetailURL] andParams:@{@"userId":[DEFAULTS objectForKey:@"userId"],@"otherUserId":userId,@"status":@"1"} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"好友详情请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                if (isFriend) {
                    //传参
                    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
                    FriendDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"FriendDetailController"];
                    detail.friendId = userId;
                    //请求网络数据获取用户详细资料
                    detail.name = dict[@"nickname"];
                    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]];
                    detail.url = encodeUrl;
                    if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                        detail.sex = [dict[@"sex"]intValue];
                    }
                    if (![dict[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                        detail.recomendPerson = [NSString stringWithFormat:@"%@",dict[@"recommendUserId"]];
                    }
                    if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                        detail.email = [NSString stringWithFormat:@"%@",dict[@"email"]];
                    }
                    if (![dict[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                        detail.lingPerson = [NSString stringWithFormat:@"%@",dict[@"claimUserId"]];
                    }
                    if (![dict[@"mobile"] isKindOfClass:[NSNull class]]) {
                        detail.phone = [NSString stringWithFormat:@"%@",dict[@"mobile"]];
                    }
                    if (![dict[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                        detail.contribute = [NSString stringWithFormat:@"%@",dict[@"contributionScore"]];
                    }
                    if (![dict[@"birthday"] isKindOfClass:[NSNull class]]) {
                        detail.birthday = [NSString stringWithFormat:@"%@",dict[@"birthday"]];
                    }
                    if (![dict[@"creditScore"] isKindOfClass:[NSNull class]]) {
                        detail.prestige = [NSString stringWithFormat:@"%@",dict[@"creditScore"]];
                    }
                    if (![dict[@"address"] isKindOfClass:[NSNull class]]) {
                        detail.areaStr = [NSString stringWithFormat:@"%@",dict[@"address"]];
                    }
                    if (![dict[@"intimacy"] isKindOfClass:[NSNull class]]) {
                        detail.intimacy = [NSString stringWithFormat:@"%@",dict[@"intimacy"]];
                    }


                    NSInteger status = [[NSString stringWithFormat:@"%@",dict[@"status"]]integerValue];
                    //好友
                    NSString * name;
                    if (status == 1) {
                        if (![dict[@"friendNickname"] isKindOfClass:[NSNull class]]) {
                            detail.display = dict[@"friendNickname"];
                        }
                        if (dict[@"friendNickname"] != nil) {
                            name = dict[@"friendNickname"];
                        }else{
                            name = dict[@"nickname"];
                        }
                    }else if (status == 2){
                        //自己
                        name = dict[@"nickname"];
                    }
                    
                    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:userId name:name portrait:encodeUrl];
                    [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:userId];
                    [weakSelf.navigationController pushViewController:detail animated:YES];
                }else{
                    //不是好友
                    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
                    UnknownFriendDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"UnknownFriendDetailController"];
                    detail.friendId = userId;
                    //请求网络数据获取用户详细资料
                    detail.name = dict[@"nickname"];
                    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]];
                    detail.url = encodeUrl;

                    if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                        detail.sex = [dict[@"sex"]intValue];
                    }
                    if (![dict[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                        detail.recomendPerson = [NSString stringWithFormat:@"%@",dict[@"recommendUserId"]];
                    }
                    if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                        detail.email = [NSString stringWithFormat:@"%@",dict[@"email"]];
                    }
                    if (![dict[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                        detail.lingPerson = [NSString stringWithFormat:@"%@",dict[@"claimUserId"]];
                    }
                    if (![dict[@"mobile"] isKindOfClass:[NSNull class]]) {
                        detail.phone = [NSString stringWithFormat:@"%@",dict[@"mobile"]];
                    }
                    if (![dict[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                        detail.contribute = [NSString stringWithFormat:@"%@",dict[@"contributionScore"]];
                    }
                    if (![dict[@"birthday"] isKindOfClass:[NSNull class]]) {
                        detail.birthday = [NSString stringWithFormat:@"%@",dict[@"birthday"]];
                    }
                    if (![dict[@"creditScore"] isKindOfClass:[NSNull class]]) {
                        detail.prestige = [NSString stringWithFormat:@"%@",dict[@"creditScore"]];
                    }
                    if (![dict[@"address"] isKindOfClass:[NSNull class]]) {
                        detail.areaStr = [NSString stringWithFormat:@"%@",dict[@"address"]];
                    }
                    if (![dict[@"intimacy"] isKindOfClass:[NSNull class]]) {
                        detail.intimacy = [NSString stringWithFormat:@"%@",dict[@"intimacy"]];
                    }


                    detail.isRegister = YES;
                    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:userId name:dict[@"nickname"] portrait:encodeUrl];
                    [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:userId];
                    [weakSelf.navigationController pushViewController:detail animated:YES];
                    
                }
            }else{
                [weakSelf showMessage:@"加载好友详情失败"];
            }
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
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
