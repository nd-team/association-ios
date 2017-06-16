//
//  SearchController.m
//  CommunityProject
//
//  Created by bjike on 17/3/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SearchController.h"
#import "AddFriendsCell.h"
#import "SearchFriendModel.h"
#import "SearchGroupCell.h"
#import "SearchGroupModel.h"
#import "UnknownFriendDetailController.h"
#import "AddFriendController.h"
#import "MaybeKnowCell.h"
#import "MaybeKnowController.h"
#import "ScanCodeViewController.h"
#import "UIView+ChatMoreView.h"

#define SearchURL @"appapi/app/lookupUser"
#define FriendDetailURL @"appapi/app/selectUserInfo"
#define KnowURL @"appapi/app/knowFriends"

@interface SearchController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * personArr;
@property (nonatomic,strong)NSMutableArray * groupArr;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray * collectionArr;

//区分个人和群组
@property (nonatomic,assign)int isPerson;

@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (nonatomic,copy) NSString * userId;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"添加朋友/群组";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18, 40)];
    backView.backgroundColor = UIColorFromRGB(0xeceef0);
    self.searchTF.leftView = backView;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    self.userId = [DEFAULTS objectForKey:@"userId"];

    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self.searchTF becomeFirstResponder];
    self.tableView.hidden = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MaybeKnowCell" bundle:nil] forCellWithReuseIdentifier:@"MaybeKnowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddFriendsCell" bundle:nil] forCellReuseIdentifier:@"AddFriendsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchGroupCell" bundle:nil] forCellReuseIdentifier:@"SearchGroupCell"];

    [self getMaybeKnowPeopleData];
    
}
-(void)tapClick{
    [self.searchTF resignFirstResponder];
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getMaybeKnowPeopleData{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,KnowURL] andParams:@{@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取可能认识的人失败%@",error);
            
            [weakSelf showMessage:@"服务器出问题咯"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    SearchFriendModel * model = [[SearchFriendModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.collectionArr addObject:model];
                }
                [weakSelf.collectionView reloadData];
            }else{
                [weakSelf showMessage:@"加载失败"];
            }
            
        }
        
    }];

}
#pragma mark-textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.firstView.hidden = YES;
    self.tableView.hidden = NO;
    [self searchData:textField.text];
    [self.searchTF resignFirstResponder];
    return YES;
}

-(void)searchData:(NSString *)phone{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,SearchURL] andParams:@{@"number":phone,@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"搜索获取失败%@",error);
            [weakSelf showMessage:@"服务器出问题咯"];
        }else{
            if (weakSelf.personArr.count != 0) {
                [weakSelf.personArr removeAllObjects];
            }
            if (weakSelf.groupArr.count != 0) {
                [weakSelf.groupArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * allArr = data[@"data"];
                for (NSDictionary * dict in allArr) {
                    //用户
                    if ([dict[@"status"]intValue] == 0) {
                        SearchFriendModel * search = [[SearchFriendModel alloc]initWithDictionary:dict error:nil];
                        weakSelf.isPerson = 1;
                        weakSelf.tableView.rowHeight = 84;
                        [weakSelf.personArr addObject:search];
                    }else{
                        //群
                        weakSelf.isPerson = 2;
                        weakSelf.tableView.rowHeight = 87;
                        SearchGroupModel * group = [[SearchGroupModel alloc]initWithDictionary:dict error:nil];
                        [weakSelf.groupArr addObject:group];
                    }
                }
                [weakSelf.tableView reloadData];
                
            }else if ([code intValue] == 0){
                [weakSelf showMessage:@"搜索失败"];
            }
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    if (self.isPerson == 1) {
        AddFriendsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendsCell"];
        cell.tableView = self.tableView;
        cell.dataArr = self.personArr;
        cell.block = ^(UIViewController *vc) {
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.friendModel = self.personArr[indexPath.row];
        return cell;
        
    }else{
        SearchGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchGroupCell"];
        cell.groupModel = self.groupArr[indexPath.row];
        cell.tableView = self.tableView;
        cell.dataArr = self.groupArr;
        cell.block = ^(UIViewController *vc){
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isPerson == 1) {
        return self.personArr.count;
    }else{
        return self.groupArr.count;
    }
    
}

 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if (self.isPerson == 1) {
         WeakSelf;
         SearchFriendModel * model = self.personArr[indexPath.row];
         //请求网络获取朋友的基本信息
         [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendDetailURL] andParams:@{@"userId":self.userId,@"status":@"1",@"otherUserId":model.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
             if (error) {
                 NSSLog(@"好友详情请求失败：%@",error);
                 [weakSelf showMessage:@"服务器出问题咯"];
             }else{
                 NSNumber * code = data[@"code"];
                 if ([code intValue] == 200) {
                     NSDictionary * dict = data[@"data"];
                      UnknownFriendDetailController * know = [[UIStoryboard storyboardWithName:@"Address" bundle:nil]instantiateViewControllerWithIdentifier:@"UnknownFriendDetailController"];
                     know.friendId = model.userId;
                     //请求网络数据获取用户详细资料
                     know.name = dict[@"nickname"];
                     NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]];
                     know.url = encodeUrl;
            
                     if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                         know.sex = [dict[@"sex"]intValue];
                     }
                     if (![dict[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                         know.recomendPerson = [NSString stringWithFormat:@"%@",dict[@"recommendUserId"]];
                     }
                     if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                         know.email = [NSString stringWithFormat:@"%@",dict[@"email"]];
                     }
                     if (![dict[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                         know.lingPerson = [NSString stringWithFormat:@"%@",dict[@"claimUserId"]];
                     }
                     if (![dict[@"mobile"] isKindOfClass:[NSNull class]]) {
                         know.phone = [NSString stringWithFormat:@"%@",dict[@"mobile"]];
                     }
                     if (![dict[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                         know.contribute = [NSString stringWithFormat:@"%@",dict[@"contributionScore"]];
                     }
                     if (![dict[@"birthday"] isKindOfClass:[NSNull class]]) {
                         know.birthday = [NSString stringWithFormat:@"%@",dict[@"birthday"]];
                     }
                     if (![dict[@"creditScore"] isKindOfClass:[NSNull class]]) {
                         know.prestige = [NSString stringWithFormat:@"%@",dict[@"creditScore"]];
                     }
                     if (![dict[@"address"] isKindOfClass:[NSNull class]]) {
                         know.areaStr = [NSString stringWithFormat:@"%@",dict[@"address"]];
                     }
                     if (![dict[@"intimacy"] isKindOfClass:[NSNull class]]) {
                         know.intimacy = [NSString stringWithFormat:@"%@",dict[@"intimacy"]];
                     }
                     know.isRegister = YES;
                     [self.navigationController pushViewController:know animated:YES];
                 }else{
                     [weakSelf showMessage:@"加载好友详情失败"];
                 }
             }
         }];
       
     }else{
         SearchGroupModel * search = self.groupArr[indexPath.row];
         UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
         AddFriendController * add = [sb instantiateViewControllerWithIdentifier:@"AddFriendController"];
         add.buttonName = @"申请加群";
         add.groupId = search.groupId;
         [self.navigationController pushViewController:add animated:YES];
     }
 }

#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.collectionArr.count < 5) {
        return self.collectionArr.count;
    }else{
        return 5;
    }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MaybeKnowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MaybeKnowCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    cell.friendModel = self.collectionArr[indexPath.row];
    cell.collectionArr = self.collectionArr;
    cell.collectionView = self.collectionView;
    cell.block = ^(UIViewController *vc) {
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
    
}
//更多可能认识的人
- (IBAction)morePeopleClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    MaybeKnowController * maybe = [sb instantiateViewControllerWithIdentifier:@"MaybeKnowController"];
    [self.navigationController pushViewController:maybe animated:YES];

}
//扫描二维码加好友
- (IBAction)scanClick:(id)sender {
    ScanCodeViewController * code = [ScanCodeViewController new];
    [self.navigationController pushViewController:code animated:YES];
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
-(NSMutableArray *)personArr{
    if (!_personArr) {
        _personArr = [NSMutableArray new];
    }
    return _personArr;
}
-(NSMutableArray *)groupArr{
    if (!_groupArr) {
        _groupArr = [NSMutableArray new];
    }
    return _groupArr;
}
-(NSMutableArray *)collectionArr{
    if (!_collectionArr) {
        _collectionArr = [NSMutableArray new];
    }
    return _collectionArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UICollectionView class]]) {
        return NO;
    }
    return YES;
}

@end
