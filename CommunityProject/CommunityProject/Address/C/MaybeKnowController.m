//
//  MaybeKnowController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MaybeKnowController.h"
#import "AddFriendsCell.h"
#import "SearchFriendModel.h"
#define KnowURL @"appapi/app/knowFriends"

@interface MaybeKnowController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MaybeKnowController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [DEFAULTS objectForKey:@"userId"];
    self.navigationItem.title = @"可能认识的人";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"AddFriendsCell" bundle:nil] forCellReuseIdentifier:@"AddFriendsDetailCell"];
    [self getMaybeKnowPeopleData];

    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMaybeKnowPeopleData];
    }];
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getMaybeKnowPeopleData{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,KnowURL] andParams:@{@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取可能认识的人失败%@",error);
        }else{
            if (weakSelf.dataArr.count != 0 || weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    SearchFriendModel * model = [[SearchFriendModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:model];
                }
                [weakSelf.tableView reloadData];
            }
            
        }
        
    }];
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    AddFriendsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendsDetailCell"];
    cell.friendModel = self.dataArr[indexPath.row];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    cell.block = ^(UIViewController *vc) {
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
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
