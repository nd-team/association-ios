//
//  AddressListController.m
//  CommunityProject
//
//  Created by bjike on 17/3/21.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AddressListController.h"
#import "FriendsListModel.h"
#import "AddressCell.h"
#import "AddressDataBaseSingleton.h"
#import <Contacts/Contacts.h>

#define FriendListURL @"http://192.168.0.209:90/appapi/app/friends"

@interface AddressListController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
//通讯录的数据
@property (nonatomic,strong)NSMutableArray * dataTwoArr;

@property (nonatomic,strong) NSMutableArray * statusArr;
@property (nonatomic,strong) NSArray * nameArr;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
//标记是否搜索
@property (nonatomic,assign)BOOL isSearch;

@property (nonatomic,strong) NSMutableArray * searchArr;
//标记搜到的人在哪找到的 0 :第一组 1：第二组 2：两组都有
@property (nonatomic,assign)int person;
@end

@implementation AddressListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUI];
    [self getStartData];
    [self readPhoneAddress];
    [self netWork];
}
-(void)setUI{
    self.isSearch = NO;
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 48)];
    
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.searchTF.leftView = backView;
    
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    //手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isSearch = NO;
        [weakSelf refresh];
    }];
}
-(void)tapClick{
    [self.searchTF resignFirstResponder];
}
-(void)getStartData{
    for (int i = 0 ; i < self.nameArr.count;i++) {
            [self.statusArr addObject:@"1"];
    }
   
}
-(void)readPhoneAddress{
    //获取手机通讯录
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"default" ofType:@"png"];
    NSMutableArray * mArr = [NSMutableArray new];
    //授权
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        CNContactStore * store = [CNContactStore new];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSMutableDictionary *mDic = [NSMutableDictionary new];
                NSSLog(@"授权成功");
                CNContactStore * st = [CNContactStore new];//CNContactImageDataKey
                NSArray * keys = @[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContactNicknameKey,CNContactEmailAddressesKey];
                CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keys];
                [st enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    //获取名字
                    NSString * firstname = contact.givenName;
                    NSString * lastname = contact.familyName;
                    NSString * name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
                    //获取昵称
                    NSString * displayName = contact.nickname;
                    //获取电话
                    NSArray * phones = contact.phoneNumbers;
                    NSString * phone = nil;
                    for (CNLabeledValue * label in phones) {
                        CNPhoneNumber * phoneNumber = label.value;
                        phone = phoneNumber.stringValue;
                        NSSLog(@"%@==%@",phoneNumber.stringValue,label.label);
                    }
                    NSString * email = nil;
                    //获取邮件
                    NSArray *emailArr = contact.emailAddresses;
                    for (CNLabeledValue * labelV in emailArr) {
                        email = labelV.value;
                        NSSLog(@"%@",labelV.value);
                    }
                    if ([phone containsString:@"-"]) {
                        NSArray * phArr = [phone componentsSeparatedByString:@"-"];
                        phone = [phArr componentsJoinedByString:@""];
                    }
                    //获取头像
                    // NSData * data = contact.imageData;
                    [mDic setValue:name forKey:@"nickname"];
                    [mDic setValue:displayName forKey:@"displayName"];
                    [mDic setValue:phone forKey:@"mobile"];
                    [mDic setValue:email forKey:@"email"];
                    [mDic setValue:filePath forKey:@"userPortraitUrl"];
                    [mArr addObjectsFromArray:@[mDic]];
                }];
            }else{
                return ;
            }
        }];
    }
//    if (self.dataTwoArr.count != 0 || self.tableView.mj_header.isRefreshing) {
//        for (FriendsListModel * model in self.dataTwoArr) {
//            [[AddressDataBaseSingleton shareDatabase]deleteDatabase:model];
//        }
//        [self.dataTwoArr removeAllObjects];
//    }
    if (mArr.count != 0) {
        for (NSDictionary * dic in mArr) {
            FriendsListModel * search = [[FriendsListModel alloc]initWithDictionary:dic error:nil];
            [[AddressDataBaseSingleton shareDatabase]insertDatabase:search];
            [self.dataTwoArr addObject:search];
        }
    }
}
-(void)netWork{
    AFNetworkReachabilityManager * net = [AFNetworkReachabilityManager sharedManager];
    [net startMonitoring];
    WeakSelf;
    [net setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [weakSelf localData];
        }else{
            [weakSelf refresh];
        }
    }];
}
-(void)refresh{
    NSMutableArray * array = [NSMutableArray new];
    AddressDataBaseSingleton * single = [AddressDataBaseSingleton shareDatabase];
    [array addObjectsFromArray:[single searchDatabase]];
    if (array.count != 0) {
        for (FriendsListModel * list in array) {
            if (list.userId.length == 0) {
                [self.dataTwoArr addObject:list];
            }
        }
    }
    [self getFriendList];
}
-(void)localData{
    NSMutableArray * array = [NSMutableArray new];
    AddressDataBaseSingleton * single = [AddressDataBaseSingleton shareDatabase];
    [array addObjectsFromArray:[single searchDatabase]];
    if (array.count != 0) {
        for (FriendsListModel * list in array) {
            if (list.userId.length != 0) {
                [self.dataArr addObject:list];
            }else{
                [self.dataTwoArr addObject:list];
            }
        }
        [self.tableView reloadData];
    }
}
-(void)getFriendList{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userId"];
    NSString * nickname = [userDefaults objectForKey:@"nickname"];
    NSString * head = [userDefaults objectForKey:@"userPortraitUrl"];
    NSString * email = [userDefaults objectForKey:@"email"];
    WeakSelf;
    //从服务器获取好友列表
    [AFNetData postDataWithUrl:FriendListURL andParams:@{@"userId":userID} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取好友列表失败：%@",error);
        }else{
            if (weakSelf.tableView.mj_header.isRefreshing || weakSelf.dataArr.count != 0) {
                for (FriendsListModel * model in weakSelf.dataArr) {
                    if (model.userId.length != 0) {
                        [[AddressDataBaseSingleton shareDatabase]deleteDatabase:model];
                    }
                }
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = jsonDic[@"data"];
                NSMutableArray * array = [NSMutableArray new];
                NSMutableDictionary * mutDic = [NSMutableDictionary new];
                NSDictionary * dict = @{@"userId":userID,@"nickname":nickname,@"userPortraitUrl":head,@"mobile":userID};
                [mutDic setValuesForKeysWithDictionary:dict];
                [mutDic setValue:email forKey:@"email"];
                [array addObjectsFromArray:@[mutDic]];
                [array addObjectsFromArray:arr];
                for (NSDictionary * dic in array) {
                    FriendsListModel * search = [[FriendsListModel alloc]initWithDictionary:dic error:nil];
                    [[AddressDataBaseSingleton shareDatabase]insertDatabase:search];
                    [weakSelf.dataArr addObject:search];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            }else if ([code intValue] == 0){
                NSSLog(@"获取失败");
            }
        }
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.nameArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isSearch) {
        
        if ([[self.statusArr objectAtIndex:section] isEqualToString:@"0"]) {
            
            return 0;
        }else{
            if (section == 0) {
                return self.dataArr.count;
            }else{
                return self.dataTwoArr.count;
            }
        }
    }else{
        if (self.person == 0) {
            if (section == 0) {
                return self.searchArr.count;
            }else{
                return 0;
            }
        }else if (self.person == 1){
            if (section == 1) {
                return self.searchArr.count;
            }else{
                return 0;
            }
        }else{
            return self.searchArr.count;
        }
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    if (!self.isSearch) {
        if (indexPath.section == 0) {
            cell.listModel = self.dataArr[indexPath.row];
            
        }else{
            cell.listModel = self.dataTwoArr[indexPath.row];
        }
    }else{
        cell.listModel = self.searchArr[indexPath.row];
    }
    

    return cell;
}
//设置组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 50)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KMainScreenWidth, 49);
    [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    if ([self.statusArr[section] isEqualToString:@"1"]) {
        [button setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"darkMore.png"] forState:UIControlStateNormal];
    }
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    button.tag = section+30;
    [button setTitle:[NSString stringWithFormat:@"     %@",self.nameArr[section]] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, KMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xeceef0);
    [view addSubview:lineView];
    return view;
}
-(void)clickedButton:(UIButton *)btn{
    
    if ([[self.statusArr objectAtIndex:btn.tag-30]isEqualToString:@"0"]) {
        
        [self.statusArr replaceObjectAtIndex:btn.tag-30 withObject:@"1"];
        
    }else{
        
        [self.statusArr replaceObjectAtIndex:btn.tag-30 withObject:@"0"];
    }
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.tableView reloadData];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag-30] withRowAnimation:UITableViewRowAnimationFade];
    });
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userId"];
    FriendsListModel * model = self.dataArr[indexPath.row];
    if (![model.userId isEqualToString:userID]) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ManageFriendViewController * manage = [sb instantiateViewControllerWithIdentifier:@"ManageFriendViewController"];
        manage.name = model.name;
        NSString * encodeUrl = [NSString stringWithFormat:@"http://192.168.0.212%@",model.userPortraitUrl];
        manage.url = encodeUrl;
        manage.phone = model.mobile;
        manage.email = model.email;
        manage.beiZhu = model.displayName;
        manage.friendId = model.userId;
        [self.navigationController pushViewController:manage animated:YES];
    }
}
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //发起搜索
    self.isSearch = YES;
    [self sendSearch];
    [self.searchTF resignFirstResponder];
    return YES;
}
-(void)sendSearch{
    [self.searchArr removeAllObjects];
    //第一组
    for (FriendsListModel * list in self.dataArr) {
        if ([list.nickname containsString:self.searchTF.text]||[list.displayName containsString:self.searchTF.text]) {
            self.person = 0;
            [self.searchArr addObject:list];
        }
    }
    //第二组
    for (FriendsListModel * list in self.dataTwoArr) {
        if ([list.nickname containsString:self.searchTF.text]||[list.displayName containsString:self.searchTF.text]) {
            self.person = 1;
            [self.searchArr addObject:list];
        }
    }
    if (self.searchArr.count == 2) {
        self.person = 2;
    }
    [self.tableView reloadData];

}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.isSearch = YES;
    [self sendSearch];
    [self.searchTF resignFirstResponder];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)dataTwoArr{
    if (!_dataTwoArr) {
        _dataTwoArr = [NSMutableArray new];
    }
    return _dataTwoArr;
}
-(NSMutableArray *)statusArr{
    if (!_statusArr) {
        _statusArr = [NSMutableArray new];
    }
    return _statusArr;
}
-(NSArray *)nameArr{
    
    if (!_nameArr) {
        
        _nameArr = @[@"我的好友",@"手机通讯录"];
    }
    return _nameArr;
}
-(NSMutableArray *)searchArr{
    
    if (!_searchArr) {
        
        _searchArr = [NSMutableArray new];
    }
    return _searchArr;
}
- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
