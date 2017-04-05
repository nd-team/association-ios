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
//好友详情
#define FriendDetailURL @"appapi/app/selectUserInfo"
//判断是否是好友
#define TESTURL @"appapi/app/CheckMobile"

@interface MemberListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation MemberListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"群成员(%ld)",self.collectArr.count];
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MemberListCell" bundle:nil] forCellWithReuseIdentifier:@"MemberListCell"];
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isManager) {
        return self.collectArr.count+2;
    }else{
        //添加一个多余的 成员
        return self.collectArr.count+1;
    }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MemberListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberListCell" forIndexPath:indexPath];
    if (self.isManager) {
        if (indexPath.row == self.collectArr.count+1) {
            cell.headImageView.image = [UIImage imageNamed:@"deleteFriend"];
            cell.nameLabel.text = @"";
        }else if (indexPath.row == self.collectArr.count){
            cell.headImageView.image = [UIImage imageNamed:@"addFriend"];
            cell.nameLabel.text = @"";
        }else{
            cell.listModel = self.collectArr[indexPath.row];
        }
    }else{
        if (indexPath.row == self.collectArr.count) {
            cell.headImageView.image = [UIImage imageNamed:@"addFriend"];
            cell.nameLabel.text = @"";
        }else{
            cell.listModel = self.collectArr[indexPath.row];
        }
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MemberListModel * model = self.collectArr[indexPath.row];
    if (self.isManager) {
        if (indexPath.row == self.collectArr.count+1) {
//删除
            
        }else if (indexPath.row == self.collectArr.count){
//拉人
            
        }else{
            [self testUserIsFriendMobile:model.userId];
        }
    }else{
        if (indexPath.row == self.collectArr.count) {
//拉人
        }else{
            [self testUserIsFriendMobile:model.userId];
        }
    }

}
//判断是否是好友
-(void)testUserIsFriendMobile:(NSString *)selectUserId{
    WeakSelf;
    
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,TESTURL] andParams:@{@"userId":self.userId,@"mobile":selectUserId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"判断是否为好友失败：%@",error);
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
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendDetailURL] andParams:@{@"userId":[DEFAULTS objectForKey:@"userId"],@"otherUserId":userId,@"status":@"1"} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"好友详情请求失败：%@",error);
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
                    if (![dict[@"age"] isKindOfClass:[NSNull class]]) {
                        detail.age = dict[@"age"];
                    }
                    if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                        detail.sex = [dict[@"sex"]intValue];
                    }
                    if (![dict[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                        detail.recomendPerson = dict[@"recommendUserId"];
                    }
                    if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                        detail.email = dict[@"email"];
                    }
                    if (![dict[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                        detail.lingPerson = dict[@"claimUserId"];
                    }
                    if (![dict[@"mobile"] isKindOfClass:[NSNull class]]) {
                        detail.phone = dict[@"mobile"];
                    }
                    if (![dict[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                        detail.contribute = [NSString stringWithFormat:@"%@",dict[@"contributionScore"]];
                    }
                    if (![dict[@"birthday"] isKindOfClass:[NSNull class]]) {
                        detail.birthday = dict[@"birthday"];
                    }
                    if (![dict[@"creditScore"] isKindOfClass:[NSNull class]]) {
                        detail.prestige = [NSString stringWithFormat:@"%@",dict[@"creditScore"]];
                    }
                    if (![dict[@"address"] isKindOfClass:[NSNull class]]) {
                        detail.areaStr = dict[@"address"];
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
                    [self.navigationController pushViewController:detail animated:YES];
                }else{
                    //不是好友
                    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
                    UnknownFriendDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"UnknownFriendDetailController"];
                    detail.friendId = userId;
                    //请求网络数据获取用户详细资料
                    detail.name = dict[@"nickname"];
                    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]];
                    detail.url = encodeUrl;
                    if (![dict[@"age"] isKindOfClass:[NSNull class]]) {
                        detail.age = dict[@"age"];
                    }
                    if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                        detail.sex = [dict[@"sex"]intValue];
                    }
                    if (![dict[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                        detail.recomendPerson = dict[@"recommendUserId"];
                    }
                    if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                        detail.email = dict[@"email"];
                    }
                    if (![dict[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                        detail.lingPerson = dict[@"claimUserId"];
                    }
                    if (![dict[@"mobile"] isKindOfClass:[NSNull class]]) {
                        detail.phone = dict[@"mobile"];
                    }
                    if (![dict[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                        detail.contribute = [NSString stringWithFormat:@"%@",dict[@"contributionScore"]];
                    }
                    if (![dict[@"birthday"] isKindOfClass:[NSNull class]]) {
                        detail.birthday = dict[@"birthday"];
                    }
                    if (![dict[@"creditScore"] isKindOfClass:[NSNull class]]) {
                        detail.prestige = [NSString stringWithFormat:@"%@",dict[@"creditScore"]];
                    }
                    if (![dict[@"address"] isKindOfClass:[NSNull class]]) {
                        detail.areaStr = dict[@"address"];
                    }
                    detail.isRegister = YES;
                    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:userId name:dict[@"nickname"] portrait:encodeUrl];
                    [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:userId];
                    [self.navigationController pushViewController:detail animated:YES];
                    [self.navigationController pushViewController:detail animated:YES];
                    
                }
            }
        }
    }];
    
}

-(NSMutableArray *)collectArr{
    if (!_collectArr) {
        _collectArr = [NSMutableArray new];
    }
    return _collectArr;
}
@end
