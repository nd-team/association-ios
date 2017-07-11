//
//  MemberListController.m
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MemberListController.h"
#import "MemberListCell.h"
#import "MemberListModel.h"
#import "FriendDetailController.h"
#import "UnknownFriendDetailController.h"
#import "ChooseFriendsController.h"

//好友详情
#define FriendDetailURL @"appapi/app/selectUserInfo"
//判断是否是好友
#define TESTURL @"appapi/app/CheckMobile"
#define MemberURL @"appapi/app/groupMember"

@interface MemberListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation MemberListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

    if (self.isRef) {
        //刷新成员列表
        [self getMemberList];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.name;
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MemberListCell" bundle:nil] forCellWithReuseIdentifier:@"MemberListCell"];
}
-(void)getMemberList{
    WeakSelf;
    NSDictionary * dict = @{@"groupId":self.groupId,@"userId":self.userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MemberURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取群成员失败%@",error);
            [weakSelf showMessage:@"服务器出问题咯！"];
        }else{
            if (self.isRef) {
                [weakSelf.collectArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * array = data[@"data"];
                for (NSDictionary * dic in array) {
                    MemberListModel * member = [[MemberListModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.collectArr addObject:member];
                }
                [weakSelf.collectionView reloadData];
                RCGroup * group = [[RCGroup alloc]initWithGroupId:weakSelf.groupId groupName:weakSelf.groupName portraitUri:[NSString stringWithFormat:NetURL,weakSelf.groupUrl]];
                //刷新群组成员的信息
                [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:weakSelf.groupId];
            }else{
                [weakSelf showMessage:@"加载群成员失败！"];
            }
            
        }
    }];
}

-(void)leftClick{
    if (self.isRef) {
        self.delegate.isRef = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isManager == 1) {
        return self.collectArr.count+2;
    }else if(self.isManager == 0){
        //添加一个多余的 成员
        return self.collectArr.count+1;
    }else{
        return self.collectArr.count;
    }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MemberListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberListCell" forIndexPath:indexPath];
    if (self.isManager == 1) {
        if (indexPath.row == self.collectArr.count+1) {
            cell.headImageView.image = [UIImage imageNamed:@"deleteFriend"];
            cell.nameLabel.text = @"";
        }else if (indexPath.row == self.collectArr.count){
            cell.headImageView.image = [UIImage imageNamed:@"addFriend"];
            cell.nameLabel.text = @"";
        }else{
            cell.listModel = self.collectArr[indexPath.row];
        }
    }else if(self.isManager == 0){
        if (indexPath.row == self.collectArr.count) {
            cell.headImageView.image = [UIImage imageNamed:@"addFriend"];
            cell.nameLabel.text = @"";
        }else{
            cell.listModel = self.collectArr[indexPath.row];
        }
    }else{
        [cell.headImageView zy_cornerRadiusRoundingRect];
        cell.userModel = self.collectArr[indexPath.row];
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.isManager == 1) {
        if (indexPath.row == self.collectArr.count+1) {
             //删除
            [self pushChoose:@"删除成员" andDiff:4];
        }else if (indexPath.row == self.collectArr.count){
            //拉人
            [self pushChoose:@"添加成员" andDiff:3];
        }else{
             MemberListModel * model = self.collectArr[indexPath.row];
            //过滤当前用户
            if ([self.userId isEqualToString:model.userId]) {
                [self pushFriendId:YES andUserId:model.userId];
            }else{
                [self testUserIsFriendMobile:model.userId];
            }
        }
    }else if(self.isManager == 0){
        if (indexPath.row == self.collectArr.count) {
            //拉人
            [self pushChoose:@"添加成员" andDiff:3];
        }else{
             MemberListModel * model = self.collectArr[indexPath.row];
            //当前用户
            if ([self.userId isEqualToString:model.userId]) {
                [self pushFriendId:YES andUserId:model.userId];
            }else{
                [self testUserIsFriendMobile:model.userId];
            }
        }
    }else{
        JoinUserModel * model = self.collectArr[indexPath.row];
        NSSLog(@"%@==%@",model.userId,self.userId);
        //当前用户进入发送消息界面
        if ([self.userId isEqualToString:model.userId]) {
            [self pushFriendId:YES andUserId:model.userId];
        }else{
            [self testUserIsFriendMobile:model.userId];
        }
 
    }

}
-(void)pushChoose:(NSString *)name andDiff:(int)dif{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    ChooseFriendsController * choose = [sb instantiateViewControllerWithIdentifier:@"ChooseFriendsController"];
    choose.groupId = self.groupId;
    choose.name = name;
    choose.dif = dif;
    choose.hostId = self.hostId;
    choose.delegate = self;
    choose.baseArr = self.collectArr;
    choose.rightName = @"确认";
    [self.navigationController pushViewController:choose animated:YES];
}
//判断是否是好友
-(void)testUserIsFriendMobile:(NSString *)selectUserId{
    WeakSelf;
    
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,TESTURL] andParams:@{@"userId":self.userId,@"mobile":selectUserId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"判断是否为好友失败：%@",error);
            [weakSelf showMessage:@"服务器出问题咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                NSNumber * status = dict[@"status"];
                if ([status intValue] == 1) {
                    //好友
                    [weakSelf pushFriendId:YES andUserId:selectUserId];
                }else{
                    [weakSelf pushFriendId:NO andUserId:selectUserId];
                }
            }
        }
    }];
}
//好友界面
-(void)pushFriendId:(BOOL)isFriend andUserId:(NSString *)userId{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendDetailURL] andParams:@{@"userId":[DEFAULTS objectForKey:@"userId"],@"otherUserId":userId,@"status":@"1"} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"好友详情请求失败：%@",error);
            [weakSelf showMessage:@"服务器出问题咯！"];
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
    [self.navigationController.view makeToast:msg];
}
-(NSMutableArray *)collectArr{
    if (!_collectArr) {
        _collectArr = [NSMutableArray new];
    }
    return _collectArr;
}
@end
