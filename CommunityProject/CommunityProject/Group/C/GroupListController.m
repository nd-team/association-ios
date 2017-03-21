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

#define GroupURL @"http://192.168.0.212/appapi/app/group_data"

@interface GroupListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation GroupListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self localData];
}
-(void)localData{
    GroupDatabaseSingleton * single = [GroupDatabaseSingleton shareDatabase];
    [self.dataArr addObjectsFromArray:[single searchDatabase]];
    if (self.dataArr.count != 0) {
        [self.tableView reloadData];
    }
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,0.001*NSEC_PER_SEC),dispatch_get_main_queue(), ^{
//        [HUDTool showLoadView:[UIApplication sharedApplication].keyWindow withText:@"正在加载..." andHudBlock:^{
            [weakSelf getGroupList];
//        }];
    });
    
}
-(void)setUI{
    self.navigationItem.title = @"群列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //导航栏按钮 创建群组
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroupClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getGroupList];
    }];
}
//获取用户群列表
-(void)getGroupList{
    NSString * userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    WeakSelf;
    [AFNetData postDataWithUrl:GroupURL andParams:@{@"userId":userID} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取群组列表失败%@",error);
        }else{
           //保存到数据库里
            if (weakSelf.tableView.mj_header.isRefreshing || weakSelf.dataArr.count != 0) {
                for (GroupModel * model in weakSelf.dataArr) {
                    [[GroupDatabaseSingleton shareDatabase]deleteDatabase:model];
                }
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = jsonDic[@"data"];
                for (NSDictionary * dic in arr) {
                    GroupModel * model = [[GroupModel alloc]initWithDictionary:dic error:nil];
                    [[GroupDatabaseSingleton shareDatabase]insertDatabase:model];
                    [weakSelf.dataArr addObject:model];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            }
            
        }
    }];
}
-(void)addGroupClick{
//    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    CreateGroupController * create = [sb instantiateViewControllerWithIdentifier:@"CreateGroupController"];
//    create.delegate = self;
//    [self.navigationController pushViewController:create animated:YES];
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
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:conver animated:YES];

}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
