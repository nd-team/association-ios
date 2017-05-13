//
//  SearchController.m
//  CommunityProject
//
//  Created by bjike on 17/3/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SearchController.h"
#import "AddFriendCell.h"
#import "SearchFriendModel.h"
#import "SearchGroupCell.h"
#import "SearchGroupModel.h"
#import "UnknownFriendDetailController.h"
#import "AddFriendController.h"

#define SearchURL @"appapi/app/lookupUser"
#define FriendDetailURL @"appapi/app/selectUserInfo"

@interface SearchController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * personArr;
@property (nonatomic,strong)NSMutableArray * groupArr;

//区分个人和群组
@property (nonatomic,assign)int isPerson;


@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"添加朋友/群组";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18, 40)];
    backView.backgroundColor = UIColorFromRGB(0xeceef0);
    self.searchTF.leftView = backView;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;

    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapClick{
    [self.searchTF resignFirstResponder];
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchData:textField.text];
    [self.searchTF resignFirstResponder];
    return YES;
}

-(void)searchData:(NSString *)phone{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,SearchURL] andParams:@{@"number":phone} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"搜索获取失败%@",error);
            //            [weakSelf showMessage:@"获取失败"];
        }else{
            if (weakSelf.personArr.count != 0) {
                [weakSelf.personArr removeAllObjects];
            }
            if (weakSelf.groupArr.count != 0) {
                [weakSelf.groupArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * msgDic = data[@"data"];
                //用户
                if ([msgDic[@"status"]intValue] == 0) {
                    SearchFriendModel * search = [[SearchFriendModel alloc]initWithDictionary:msgDic error:nil];
                    weakSelf.isPerson = 1;
                    weakSelf.tableView.rowHeight = 50;
                    [weakSelf.personArr addObject:search];
                }else{
                    //群
                    weakSelf.isPerson = 2;
                    weakSelf.tableView.rowHeight = 87;
                    SearchGroupModel * group = [[SearchGroupModel alloc]initWithDictionary:msgDic error:nil];
                    [weakSelf.groupArr addObject:group];
                }
                
                [weakSelf.tableView reloadData];
                
            }else if ([code intValue] == 0){
                //                [weakSelf showMessage:@"获取失败"];
            }
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isPerson == 1) {
        AddFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendCell"];
        cell.searchModel = self.personArr[indexPath.row];
        return cell;
        
    }else{
        SearchGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchGroupCell"];
        cell.groupModel = self.groupArr[indexPath.row];
        cell.tableView = self.tableView;
        cell.dataArr = self.groupArr;
        WeakSelf;
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
         UnknownFriendDetailController * know = [[UIStoryboard storyboardWithName:@"Address" bundle:nil]instantiateViewControllerWithIdentifier:@"UnknownFriendDetailController"];
         SearchFriendModel * model = self.personArr[indexPath.row];
         //请求网络获取朋友的基本信息
         [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendDetailURL] andParams:@{@"userId":model.userId,@"status":@"1"} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
             if (error) {
                 NSSLog(@"好友详情请求失败：%@",error);
             }else{
                 NSNumber * code = data[@"code"];
                 if ([code intValue] == 200) {
                     NSDictionary * dict = data[@"data"];
                     know.friendId = model.userId;
                     //请求网络数据获取用户详细资料
                     know.name = dict[@"nickname"];
                     NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]];
                     know.url = encodeUrl;
                     if (![dict[@"age"] isKindOfClass:[NSNull class]]) {
                         know.age = dict[@"age"];
                     }
                     if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                         know.sex = [dict[@"sex"]intValue];
                     }
                     if (![dict[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                         know.recomendPerson = dict[@"recommendUserId"];
                     }
                     if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                         know.email = dict[@"email"];
                     }
                     if (![dict[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                         know.lingPerson = dict[@"claimUserId"];
                     }
                     if (![dict[@"mobile"] isKindOfClass:[NSNull class]]) {
                         know.phone = dict[@"mobile"];
                     }
                     if (![dict[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                         know.contribute = dict[@"contributionScore"];
                     }
                     if (![dict[@"birthday"] isKindOfClass:[NSNull class]]) {
                         know.birthday = dict[@"birthday"];
                     }
                     if (![dict[@"creditScore"] isKindOfClass:[NSNull class]]) {
                         know.prestige = dict[@"creditScore"];
                     }
                     if (![dict[@"address"] isKindOfClass:[NSNull class]]) {
                         know.areaStr = dict[@"address"];
                     }
                     if (![dict[@"intimacy"] isKindOfClass:[NSNull class]]) {
                         know.intimacy = [NSString stringWithFormat:@"%@",dict[@"intimacy"]];
                     }

                     know.isRegister = YES;
                 }
             }
         }];
         
         [self.navigationController pushViewController:know animated:YES];
     }else{
         SearchGroupModel * search = self.groupArr[indexPath.row];
         UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
         AddFriendController * add = [sb instantiateViewControllerWithIdentifier:@"AddFriendController"];
         add.buttonName = @"申请加群";
         add.groupId = search.groupId;
         [self.navigationController pushViewController:add animated:YES];
     }
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

@end
