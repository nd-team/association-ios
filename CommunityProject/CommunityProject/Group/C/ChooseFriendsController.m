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
#import "HeadImageCell.h"
#import "HobbyController.h"

//拉人踢人 管理员
#import "MemberListModel.h"
//新建群聊
#import "FriendsListModel.h"
#define MemberURL @"appapi/app/groupMember"
#define  ManagerURL @"appapi/app/vicePrincipal"
#define DeleteURL @"appapi/app/kickGroupUser"
#define FriendListURL @"appapi/app/friends"
#define JoinURL @"appapi/app/recommendUser"

@interface ChooseFriendsController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
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
@property (nonatomic,strong) UIView * leftView;

@property (nonatomic,strong)UIWindow * window;
@property (nonatomic,strong)NSString * result;
@property (nonatomic,strong)UICollectionView * collectionView;
//存头像的数据
@property (nonatomic,strong)NSMutableArray * imageArr;
//搜索返回数据
@property (nonatomic,strong)NSMutableArray * searchArr;
//标记是否搜索
@property (nonatomic,assign)BOOL isSearch;

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
    UIButton * rightBtn = [UIButton CreateTitleButtonWithFrame:CGRectMake(0, 0,70, 30) andBackgroundColor:UIColorFromRGB(0xffffff) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:self.rightName];
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self setUI];
    //选择管理员，踢人
    if (self.dif == 1||self.dif == 4) {
        //获取群成员列表选择群管理
        [self getMemberList];
    }else{
        //新建群聊2,拉人3，好友列表5新建兴趣联盟
        [self getFriendList];
        
    }
}
-(void)setUI{
    self.isSearch = NO;
    self.tableView.sectionIndexColor = UIColorFromRGB(0x666666);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.userId = [DEFAULTS objectForKey:@"userId"];
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 42, 50)];
    UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 18, 20)];
    leftImageView.image = [UIImage imageNamed:@"search.png"];
    [self.leftView addSubview:leftImageView];
    self.selectPath = nil;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    [self showCollectionView];

}
-(void)showCollectionView{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.01;
    layout.minimumLineSpacing = 0.01;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeadImageCell" bundle:nil] forCellWithReuseIdentifier:@"headCell"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    if (self.imageArr.count == 0) {
        self.searchTF.leftView = self.leftView;
    }else{
        self.searchTF.leftView = self.collectionView;
    }
    
    
}
-(void)getMemberList{
    WeakSelf;
    NSDictionary * dict = @{@"groupId":self.groupId,@"userId":self.userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MemberURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取群成员失败%@",error);
            [weakSelf showMessage:@"服务器出问题咯！"];
        }else{
            if (weakSelf.dataArr.count != 0 || weakSelf.sectionArr.count != 0 || weakSelf.rowArr.count != 0) {
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.sectionArr removeAllObjects];
                [weakSelf.rowArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * array = data[@"data"];
                for (NSDictionary * dic in array) {
                    MemberListModel * member = [[MemberListModel alloc]initWithDictionary:dic error:nil];
                    if (![member.userId isEqualToString:self.userId]) {
                        [weakSelf.dataArr addObject:member];
                    }
                }
                //组头字母
                weakSelf.sectionArr = [BMChineseSort IndexWithArray:weakSelf.dataArr Key:@"userName"];
                //数据
                weakSelf.rowArr = [BMChineseSort sortObjectArray:weakSelf.dataArr Key:@"userName"];
                }else{
                [weakSelf showMessage:@"获取群成员失败"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });

            
        }
    }];
}
-(void)getFriendList{
    WeakSelf;
    //从服务器获取好友列表
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendListURL] andParams:@{@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取好友列表失败：%@",error);
            [weakSelf showMessage:@"服务器出问题咯！"];
        }else{
            if (weakSelf.dataArr.count != 0 || weakSelf.sectionArr.count != 0 || weakSelf.rowArr.count != 0) {
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.sectionArr removeAllObjects];
                [weakSelf.rowArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    FriendsListModel * search = [[FriendsListModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:search];
                    //过滤已经存在群组的用户 拉人
                    if (weakSelf.dif == 3) {
                        for (MemberListModel * member in weakSelf.baseArr) {
                            if ([member.userId isEqualToString:search.userId]) {
                                [weakSelf.dataArr removeObject:search];
                            }
                        }
                    }
                    if (search.displayName.length != 0) {
                        //组头字母
                        weakSelf.sectionArr = [BMChineseSort IndexWithArray:weakSelf.dataArr Key:@"displayName"];
                        weakSelf.rowArr = [BMChineseSort sortObjectArray:weakSelf.dataArr Key:@"displayName"];

                    }else{
                        //组头字母
                        weakSelf.sectionArr = [BMChineseSort IndexWithArray:weakSelf.dataArr Key:@"nickname"];
                        weakSelf.rowArr = [BMChineseSort sortObjectArray:weakSelf.dataArr Key:@"nickname"];

                    }
                }
            }else if ([code intValue] == 0){
                [weakSelf showMessage:@"加载好友列表失败"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        
    }];
    
}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemClick{
    WeakSelf;

    //单选
    if (self.dif == 1&&self.managerId.length == 0) {
        return;
    }//多选
    if (self.dif != 1&& self.usersIdsArray.count == 0) {
        return;
    }
    if (self.dif == 2 || self.dif == 5) {
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
            nameVC.rightStr = @"创建";
            [self.navigationController pushViewController:nameVC animated:YES];

        }
            break;
            case 3:
            
        {
            if (self.hostId.length != 0) {
                //群主拉人
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf showBackViewUI:@"确认添加成员"];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf showBackViewUI:@"等待群主审核"];
                });
            }

        }
            break;
        case 4:
            //移除成员
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showBackViewUI:@"确认移除成员"];
            });
        }
            
        break;
        default:
            //进入爱好界面
        {
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Interest" bundle:nil];
            HobbyController  * hobby = [sb instantiateViewControllerWithIdentifier:@"HobbyController"];
            hobby.resultStr = self.result;
            UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
            self.navigationItem.backBarButtonItem = backItem;
            [self.navigationController pushViewController:hobby animated:YES];
        }
            break;
    }
}

-(void)showBackViewUI:(NSString *)title{
    
    self.backView = [UIView sureViewTitle:title andTag:50 andTarget:self andAction:@selector(buttonAction:)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewAction)];
    
    [self.backView addGestureRecognizer:tap];
    
    [self.window addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(-64);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(KMainScreenWidth);
        make.height.mas_equalTo(KMainScreenHeight);
    }];
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
        }
            break;
            
        default:
            //取消
            break;
    }
    [self hideViewAction];
}
-(void)hideViewAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backView.hidden = YES;

    });
    
}
-(void)deletePerson:(NSDictionary *)params andUrl:(NSString *)url{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,url] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"踢人/拉人/新建群聊失败%@",error);
            [weakSelf showMessage:@"服务器出问题咯！"];
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
                [weakSelf showMessage:@"踢/拉/新建群聊人失败"];
            }
        }
    }];
    
}

-(void)addManager{
    WeakSelf;
    NSDictionary * dict = @{@"groupId":self.groupId,@"userId":self.hostId,@"groupUserId":self.managerId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ManagerURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"添加管理员失败%@",error);
            [weakSelf showMessage:@"服务器出问题咯"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else if ([code intValue] == 1005){
                [weakSelf showMessage:@"已经是管理员"];
            }else if ([code intValue] == 100){
                [weakSelf showMessage:@"副群主已存在"];
            }else{
                [weakSelf showMessage:@"选择副群主失败"];
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
        case 4://踢人
            cell.memberModel = [[self.rowArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

            break;
        default://新建兴趣联盟
            cell.listModel = [[self.rowArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            break;
    }
    WeakSelf;
    cell.managerBlock = ^(NSString * groupUserId,NSString * headUrl,BOOL isSingle,BOOL isRemove){
        if (isSingle) {
            weakSelf.managerId = groupUserId;
        }else{
            [weakSelf.usersIdsArray addObject:groupUserId];
            [weakSelf.imageArr addObject:headUrl];
            //多选
            if (isRemove) {
                for (NSString * str  in weakSelf.usersIdsArray) {
                    if ([str isEqualToString:groupUserId]) {
                        [weakSelf.usersIdsArray removeObject:str];
                        break;
                    }
                }
                for (NSString * str  in weakSelf.imageArr) {
                    if ([str isEqualToString:headUrl]) {
                        [weakSelf.imageArr removeObject:str];
                        break;
                    }
                }
            }
            //改变frame
            if (self.imageArr.count*49<(KMainScreenWidth-60)) {
                self.collectionView.frame = CGRectMake(0, 0, self.imageArr.count*49, 50);
            }else{
                self.collectionView.frame = CGRectMake(0, 0, KMainScreenWidth-60, 50);
            }
            //改变标题和搜索框的左侧图片样式
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)",weakSelf.name,(unsigned long)weakSelf.usersIdsArray.count];
            if (weakSelf.imageArr.count == 0) {
                self.searchTF.leftView = self.leftView;
            }else{
                self.searchTF.leftView = self.collectionView;
                //刷新collection
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                });
            }
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
#pragma mark - collectionView的代理方法-表头左侧的视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HeadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
    NSString * url = [ImageUrl changeUrl:self.imageArr[indexPath.row]];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,url]]];
    return cell;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(49, 50);
}
#pragma mark-发起搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //发起搜索
    self.isSearch = YES;
    [self.searchTF resignFirstResponder];
    [self sendSearch];
    return YES;
}
-(void)sendSearch{
    [self.searchArr removeAllObjects];
    [self.rowArr removeAllObjects];
    [self.sectionArr removeAllObjects];
    if (self.dif == 1 && self.dif == 4) {
        //群成员
        for (MemberListModel * member in self.dataArr) {
            if ([self.searchTF.text containsString:member.userName]||[member.userName containsString:self.searchTF.text]) {
                [self.searchArr addObject:member];
            }
        }
        //组头字母
        self.sectionArr = [BMChineseSort IndexWithArray:self.searchArr Key:@"userName"];
        //数据
        self.rowArr = [BMChineseSort sortObjectArray:self.searchArr Key:@"userName"];

    }else{
        //好友列表
        for (FriendsListModel * list in self.dataArr) {
            if ([self.searchTF.text containsString:list.nickname]||[list.nickname containsString:self.searchTF.text]) {
                [self.searchArr addObject:list];
            }
            if (list.displayName.length != 0) {
                //组头字母
                self.sectionArr = [BMChineseSort IndexWithArray:self.searchArr Key:@"displayName"];
                self.rowArr = [BMChineseSort sortObjectArray:self.searchArr Key:@"displayName"];
                
            }else{
                //组头字母
                self.sectionArr = [BMChineseSort IndexWithArray:self.searchArr Key:@"nickname"];
                self.rowArr = [BMChineseSort sortObjectArray:self.searchArr Key:@"nickname"];
                
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
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
-(NSMutableArray *)baseArr{
    if (!_baseArr) {
        _baseArr = [NSMutableArray new];
    }
    return _baseArr;
}
-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray new];
    }
    return _imageArr;
}
-(NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [NSMutableArray new];
    }
    return _searchArr;
}
@end
