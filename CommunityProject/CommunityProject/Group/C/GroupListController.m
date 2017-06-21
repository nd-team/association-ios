//
//  GroupListController.m
//  LoveChatProject
//
//  Created by bjike on 17/2/9.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GroupListController.h"
#import "GroupModel.h"
#import "GroupDatabaseSingleton.h"
#import "GroupListCell.h"
#import "ChatDetailController.h"
#import "ChooseFriendsController.h"

#define GroupURL @"appapi/app/groupData"

@interface GroupListController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UIButton * button;

@end

@implementation GroupListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
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
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [weakSelf getGroupList];
               
            });
        }
    }];
}
-(void)localData{
    GroupDatabaseSingleton * single = [GroupDatabaseSingleton shareDatabase];
    [self.dataArr addObjectsFromArray:[single searchDatabase]];
    if (self.dataArr.count != 0) {
        [self.tableView reloadData];
    }
    
}
-(void)setUI{
    self.navigationItem.title = @"群列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //导航栏按钮 创建群组
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png" and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40) andMove:-30 image:@"add.png" and:self Action:@selector(addGroupClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getGroupList];
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf createGroup];
    });

}
-(void)tapClick{
    self.button.hidden = YES;
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//获取用户群列表
-(void)getGroupList{
    NSString * userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,GroupURL] andParams:@{@"userId":userID} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"获取群组列表失败%@",error);
            [weakSelf showMessage:@"服务器出问题咯"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
           //保存到数据库里
            if (weakSelf.tableView.mj_header.isRefreshing || weakSelf.dataArr.count != 0) {
                for (GroupModel * model in weakSelf.dataArr) {
                    [[GroupDatabaseSingleton shareDatabase]deleteDatabase:model];
                }
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            NSSLog(@"%@",data);
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    GroupModel * model = [[GroupModel alloc]initWithDictionary:dic error:nil];
                    [[GroupDatabaseSingleton shareDatabase]insertDatabase:model];
                    [weakSelf.dataArr addObject:model];
                }
               
            }else{
                [weakSelf showMessage:@"加载群组列表失败，下拉刷新重试"];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            
        }
    }];
}
-(void)addGroupClick{
    self.button.hidden = !self.button.hidden;
}
-(void)createGroup{
    
    self.button = [UIButton CreateMyButtonWithFrame:CGRectZero Image:@"smallGreen.png" SelectedImage:@"smallGreen.png" title:@"新建群聊" color:UIColorFromRGB(0x444343) SelectColor:UIColorFromRGB(0x444343) font:14 and:self Action:@selector(showCreateClick)];
    self.button.hidden = YES;
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(2);
        make.right.equalTo(self.view).offset(-15);
        make.width.mas_equalTo(113);
        make.height.mas_equalTo(33.5);
    }];
}
-(void)showCreateClick{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    ChooseFriendsController * choose = [sb instantiateViewControllerWithIdentifier:@"ChooseFriendsController"];
    choose.name = @"选择好友";
    choose.dif = 2;
    choose.rightName = @"下一步";
    [self.navigationController pushViewController:choose animated:YES];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GroupListCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupModel * group = self.dataArr[indexPath.row];
    //群聊
    ChatDetailController * conver = [[ChatDetailController alloc]initWithConversationType:ConversationType_GROUP targetId:group.groupId];
    conver.conversationType = ConversationType_GROUP;
    conver.targetId = group.groupId;
    //会话人备注
    conver.title = group.groupName;    
    [self.navigationController pushViewController:conver animated:YES];

}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    return YES;
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
@end
