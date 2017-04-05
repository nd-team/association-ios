//
//  ChooseFriendsController.m
//  CommunityProject
//
//  Created by bjike on 17/3/31.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ChooseFriendsController.h"
#import "ChooseCell.h"
#import "BMChineseSort.h"

//拉人踢人 管理员
#import "MemberListModel.h"
//新建群聊
#import "FriendsListModel.h"

#define MemberURL @"appapi/app/groupMember"
#define  ManagerURL @"appapi/app/vicePrincipal"
@interface ChooseFriendsController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;
//组数
@property (nonatomic,strong)NSMutableArray * sectionArr;

//行数
@property (nonatomic,strong)NSMutableArray * rowArr;

@property (nonatomic,copy)NSString * userId;
//选择副群主的ID
@property (nonatomic,copy)NSString * managerId;
//单选
@property (nonatomic,strong)NSIndexPath * selectPath;


@end

@implementation ChooseFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.name;
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIButton * rightBtn = [UIButton CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) andBackgroundColor:UIColorFromRGB(0xffffff) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:@"确定"];
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self setUI];
    if (self.dif == 1) {
        //获取群成员列表选择群管理
        [self getMemberList];
    }
}
-(void)setUI{
    self.tableView.sectionIndexColor = UIColorFromRGB(0x666666);
    self.userId = [DEFAULTS objectForKey:@"userId"];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 42, 50)];
    
    UIImageView * leftView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 18, 20)];
    
    leftView.image = [UIImage imageNamed:@"search.png"];
    
    [backView addSubview:leftView];
    
    self.searchTF.leftView = backView;
    
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    self.selectPath = nil;

}
-(void)getMemberList{
    WeakSelf;
    NSDictionary * dict = @{@"groupId":self.groupId,@"userId":self.userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MemberURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取群成员失败%@",error);
        }else{
            if (weakSelf.dataArr.count !=0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * array = data[@"data"];
                for (NSDictionary * dic in array) {
                    MemberListModel * member = [[MemberListModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:member];
                    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:member.userId name:member.userName portrait:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:member.userPortraitUrl]]];
                    //刷新群组成员的信息
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:member.userId];
                }
                //组头字母
                weakSelf.sectionArr = [BMChineseSort IndexWithArray:weakSelf.dataArr Key:@"userName"];
                //数据
                weakSelf.rowArr = [BMChineseSort sortObjectArray:weakSelf.dataArr Key:@"userName"];
                [weakSelf.tableView reloadData];

            }
            
        }
    }];
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemClick{
    if (self.managerId.length == 0) {
        return;
    }
    if (self.dif == 1) {
        //选择群管理员
        [self addManager];
    }
}
-(void)addManager{
    WeakSelf;
    NSDictionary * dict = @{@"groupId":self.groupId,@"userId":self.hostId,@"groupUserId":self.managerId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MemberURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"添加管理员失败%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else if ([code intValue] == 101){
                NSSLog(@"已经是管理员");
            }else if ([code intValue] == 102){
                NSSLog(@"副群主已存在");
            }
            
        }
    }];

}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCell"];
    cell.memberModel = [[self.rowArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.isSingle = 1;
    cell.tableView = self.tableView;
    cell.dataArr = self.rowArr;
    WeakSelf;
    cell.managerBlock = ^(NSString * groupUserId,BOOL isSingle){
        if (isSingle) {
            weakSelf.managerId = groupUserId;
        }
    };
    //实现单选
    cell.selectBlock = ^(NSIndexPath * selectPath){
        weakSelf.selectPath = selectPath;
        [weakSelf.tableView reloadData];
    };
    if (self.selectPath == nil) {
        cell.chooseBtn.selected = NO;
    } else if (self.selectPath.row == indexPath.row&&self.selectPath.section == indexPath.section) {
        cell.chooseBtn.selected = YES;
    }else{
        cell.chooseBtn.selected = NO;
    }
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.rowArr[section] count];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArr.count;
}
//组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 31)];
    view.backgroundColor = UIColorFromRGB(0xECEEF0);
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(11, 0, 100, 31)];
    label.backgroundColor =  UIColorFromRGB(0xECEEF0);
    label.textColor = UIColorFromRGB(0x666666);
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.sectionArr[section];
    [view addSubview:label];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31;
}
//右侧的数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionArr;
}
//右侧索引
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)rowArr{
    if (!_rowArr) {
        _rowArr = [NSMutableArray new];
    }
    return _rowArr;
}
-(NSMutableArray *)sectionArr{
    if (!_sectionArr) {
        _sectionArr = [NSMutableArray new];
    }
    return _sectionArr;
}
@end
