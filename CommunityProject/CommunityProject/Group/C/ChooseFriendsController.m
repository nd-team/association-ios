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
#import "NameViewController.h"

//拉人踢人 管理员
#import "MemberListModel.h"
//新建群聊
#import "FriendsListModel.h"
#import "UIView+ChatMoreView.h"
#define MemberURL @"appapi/app/groupMember"
#define  ManagerURL @"appapi/app/vicePrincipal"
#define DeleteURL @"appapi/app/kickGroupUser"
#define FriendListURL @"appapi/app/friends"
#define JoinURL @"appapi/app/recommendUser"

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

//多选
@property (nonatomic,strong)NSMutableArray * usersIdsArray;

@property (nonatomic,strong) UIView * backView;

@property (nonatomic,strong)UIWindow * window;
@property (nonatomic,strong)NSString * result;
@end

@implementation ChooseFriendsController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
}
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
    
    if (self.dif == 1||self.dif == 4) {
        //获取群成员列表选择群管理
        [self getMemberList];
    }else{
        //新建群聊2,拉人3，好友列表
        [self getFriendList];
        
    }
}
-(void)setUI{
    self.tableView.sectionIndexColor = UIColorFromRGB(0x666666);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
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
-(void)getFriendList{
    WeakSelf;
    //从服务器获取好友列表
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendListURL] andParams:@{@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取好友列表失败：%@",error);
        }else{
            if (weakSelf.dataArr.count != 0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    FriendsListModel * search = [[FriendsListModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:search];
                    if (search.displayName.length != 0) {
                        //组头字母
                        weakSelf.sectionArr = [BMChineseSort IndexWithArray:weakSelf.dataArr Key:@"displayName"];
                    }else{
                        //组头字母
                        weakSelf.sectionArr = [BMChineseSort IndexWithArray:weakSelf.dataArr Key:@"nickname"];
                    }
                }
               
                //数据
                weakSelf.rowArr = [BMChineseSort sortObjectArray:weakSelf.dataArr Key:@"nickname"];
                [weakSelf.tableView reloadData];
                NSSLog(@"%@",weakSelf.sectionArr);
            }else if ([code intValue] == 0){
                NSSLog(@"获取失败");
            }
        }
        
    }];
    
}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemClick{
    //单选
    if (self.dif == 1&&self.managerId.length == 0) {
        return;
    }//多选
    if (self.dif != 1&& self.usersIdsArray.count == 0) {
        return;
    }
    if (self.dif == 2) {
        //把当前用户加上
        [self.usersIdsArray addObject:self.userId];
        NSData * data = [NSJSONSerialization dataWithJSONObject:self.usersIdsArray options:NSJSONWritingPrettyPrinted error:nil];

        self.result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        NSData * data = [NSJSONSerialization dataWithJSONObject:self.usersIdsArray options:NSJSONWritingPrettyPrinted error:nil];
        self.result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }

    switch (self.dif) {
        case 1:
            //选择群管理员
            [self addManager];
            break;
           case 2:
            //新建群聊
        {
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
            NameViewController * nameVC = [sb instantiateViewControllerWithIdentifier:@"NameViewController"];
            nameVC.name = @"群名称";
            nameVC.titleCount = 3;
            nameVC.placeHolder = @"设置群名称";
            nameVC.isChangeGroupName = NO;
            nameVC.userStr = self.result;
            [self.navigationController pushViewController:nameVC animated:YES];

        }
            break;
            case 3:
            
        {
            if (self.hostId.length != 0) {
                //群主拉人
                [self showBackViewUI:@"确认添加成员"];
            }else{
                [self showBackViewUI:@"确认添加成员/n等待群主审核"];
  
            }

        }
            break;
        default:
            //移除成员
        {
            [self showBackViewUI:@"确认移除成员"];
  
        }
            
        break;
    }
}
-(void)showBackViewUI:(NSString *)title{
    
    self.backView = [UIView sureViewTitle:title andTag:50 andTarget:self andAction:@selector(buttonAction:)];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewAction)];
    
    [self.backView addGestureRecognizer:tap];
    
    [self.window addSubview:self.backView];
    
}
-(void)buttonAction:(UIButton *)btn{
    switch (btn.tag) {
        case 50:
            //确定
        {
            if (self.dif == 3) {
                NSDictionary * params = @{@"groupId":self.groupId,@"friendsUsers":self.result,@"userId":self.userId};
                [self deletePerson:params andUrl:JoinURL];
            }else{
                NSDictionary * params = @{@"groupId":self.groupId,@"users":self.result,@"groupUserId":self.hostId};
                [self deletePerson:params andUrl:DeleteURL];
            }
            self.backView.hidden = YES;
        }
            break;
            
        default:
            //取消
            self.backView.hidden = YES;
            break;
    }
}
-(void)hideViewAction{
    
    self.backView.hidden = YES;
    
}
-(void)deletePerson:(NSDictionary *)params andUrl:(NSString *)url{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,url] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"踢人/拉人/新建群聊失败%@",error);
//            [weakSelf showMessage:@"踢人失败"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [weakSelf.usersIdsArray removeAllObjects];
                if (weakSelf.dif == 3 || weakSelf.dif == 4) {
                    weakSelf.delegate.isRef = YES;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else{
//                [weakSelf showMessage:@"踢人失败"];
            }
        }
    }];
    
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
    cell.isSingle = self.dif;
    cell.tableView = self.tableView;
    cell.dataArr = self.rowArr;
    switch (self.dif) {
        case 1://管理员
            cell.memberModel = [[self.rowArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            break;
        case 2:
            //新建群聊
            cell.listModel = [[self.rowArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            break;
        case 3://拉人
            cell.listModel = [[self.rowArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            break;
        default://踢人
            cell.memberModel = [[self.rowArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            break;
    }
    WeakSelf;
    cell.managerBlock = ^(NSString * groupUserId,BOOL isSingle,BOOL isRemove){
        if (isSingle) {
            weakSelf.managerId = groupUserId;
        }else{
            //多选
            if (!isRemove) {
                [weakSelf.usersIdsArray addObject:groupUserId];
            }else{
                for (NSString * str  in weakSelf.usersIdsArray) {
                    if ([str isEqualToString:groupUserId]) {
                        [weakSelf.usersIdsArray removeObject:str];
                    }
                }
            }
            //改变标题和搜索框的左侧图片样式
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)",weakSelf.name,weakSelf.usersIdsArray.count];
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
-(NSMutableArray *)usersIdsArray{
    if (!_usersIdsArray) {
        _usersIdsArray = [NSMutableArray new];
    }
    return _usersIdsArray;
}
@end
