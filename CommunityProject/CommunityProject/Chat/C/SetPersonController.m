//
//  SetPersonController.m
//  CommunityProject
//
//  Created by bjike on 17/3/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SetPersonController.h"
#import "ChatMainController.h"

#define DeleteURL @"appapi/app/deleteUser"
#define FriendDetailURL @"appapi/app/selectUserInfo"

@interface SetPersonController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContraints;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UILabel *recomendLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *knowLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *contributeLabel;

@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *prestigeLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *topChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@property (nonatomic,copy)NSString * userId;
//会话头像
@property (nonatomic,copy)NSString * url;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightContraints;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation SetPersonController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBar];
    [self setUI];
    //获取用户基本信息
    [self getUserInformation];
    
}

-(void)setBar{
    self.navigationItem.title = @"详细资料";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.topChatBtn setBackgroundImage:[UIImage imageNamed:@"switchOff.png"] forState:UIControlStateNormal];
    [self.topChatBtn setBackgroundImage:[UIImage imageNamed:@"switchOn.png"] forState:UIControlStateSelected];
    [self.messageBtn setBackgroundImage:[UIImage imageNamed:@"switchOff.png"] forState:UIControlStateNormal];
    [self.messageBtn setBackgroundImage:[UIImage imageNamed:@"switchOn.png"] forState:UIControlStateSelected];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefaults objectForKey:@"userId"];
    BOOL isTop = [userDefaults boolForKey:@"topChatPerson"];
    self.topChatBtn.selected = isTop;
    //设置按钮状态
    WeakSelf;
    [[RCIMClient sharedRCIMClient]getConversationNotificationStatus:self.conversationType targetId:self.friendId success:^(RCConversationNotificationStatus nStatus) {
        //免打扰
        if (nStatus == 0) {
            weakSelf.messageBtn.selected = YES;
        }else{
            //消息提醒
            weakSelf.messageBtn.selected = NO;
        }
    } error:^(RCErrorCode status) {
        NSSLog(@"%ld",(long)status);
    }];

}
-(void)setUI{
    self.headImageView.layer.cornerRadius = 5;
    self.headImageView.layer.masksToBounds = YES;
    self.userLabel.text = [NSString stringWithFormat:@"账号：%@",self.friendId];
    self.nameLabel.text = self.nickname;
    self.ageLabel.text = @"0岁";
    self.recomendLabel.text = @"推荐：";
    self.emailLabel.text = @"邮箱：";
    self.knowLabel.text = @"认领：";
    self.phoneLabel.text = @"电话：";
    self.contributeLabel.text = @"贡献值：";
    self.birthdayLabel.text = @"生日：";
    self.prestigeLabel.text = @"信誉值：";
    self.areaLabel.text = @"地址：";
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getUserInformation{
    WeakSelf;
    //获取数据初始化数据
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendDetailURL] andParams:@{@"otherUserId":self.friendId,@"status":@"1",@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"好友详情请求失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
//                NSSLog(@"%@",dict);
                //请求网络数据获取用户详细资料
                NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]];
                [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
                if (![dict[@"age"] isKindOfClass:[NSNull class]]) {
                    weakSelf.ageLabel.text = [NSString stringWithFormat:@"%@岁",dict[@"age"]];
                }
                if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                    if ([dict[@"sex"]intValue] == 1) {
                        weakSelf.sexImageView.image = [UIImage imageNamed:@"man.png"];
                    }else{
                        weakSelf.sexImageView.image = [UIImage imageNamed:@"woman.png"];
                    }
                }
                if (![dict[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                    weakSelf.recomendLabel.text = [NSString stringWithFormat:@"推荐人：%@",dict[@"recommendUserId"]];
                }
                if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                    weakSelf.emailLabel.text = [NSString stringWithFormat:@"邮箱：%@",dict[@"email"]];
                }
                if (![dict[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                    weakSelf.knowLabel.text = [NSString stringWithFormat:@"认领人：%@",dict[@"claimUserId"]];
                }
                if (![dict[@"mobile"] isKindOfClass:[NSNull class]]) {
                    weakSelf.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",dict[@"mobile"]];
                }
                if (![dict[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                    weakSelf.contributeLabel.text = [NSString stringWithFormat:@"贡献值：%@",dict[@"contributionScore"]];
                }
                if (![dict[@"birthday"] isKindOfClass:[NSNull class]]) {
                   weakSelf.birthdayLabel.text = [NSString stringWithFormat:@"生日：%@",dict[@"birthday"]];
                }
                if (![dict[@"creditScore"] isKindOfClass:[NSNull class]]) {
                    weakSelf.prestigeLabel.text = [NSString stringWithFormat:@"信誉值：%@",dict[@"creditScore"]];
                }
                if (![dict[@"address"] isKindOfClass:[NSNull class]]) {
                    weakSelf.areaLabel.text = [NSString stringWithFormat:@"地址：%@",dict[@"address"]];
                }
        
            }
        }
    }];

}
//删除好友
- (IBAction)deleteClick:(id)sender {
    WeakSelf;
    [MessageAlertView alertViewWithTitle:@"亲，确定删除该好友吗？" message:nil buttonTitle:@[@"取消",@"确定"] Action:^(NSInteger indexpath) {
        if (indexpath == 0) {
            NSSLog(@"取消");
        }else{
            [weakSelf deleteFriend];
        }
    } viewController:self];
}
-(void)deleteFriend{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * nickname = [user objectForKey:@"nickname"];
    NSString * headUrl = [user objectForKey:@"userPortraitUrl"];
    NSString * url = [ImageUrl changeUrl:headUrl];
    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:self.userId name:nickname portrait:[NSString stringWithFormat:NetURL,url]];
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,DeleteURL] andParams:@{@"userId":self.userId,@"friendUserid":self.friendId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"删除好友失败%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //刷新SDK缓存
                [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:self.userId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (UIViewController* vc in self.navigationController.viewControllers) {
                        
                        if ([vc isKindOfClass:[ChatMainController class]]) {
                            
                            [weakSelf.navigationController popToViewController:vc animated:YES];
                        }
                    }
                });
            }
        }
    }];
}
//消息免打扰
- (IBAction)messageClick:(id)sender {
    self.messageBtn.selected = !self.messageBtn.selected;
    [self setMessage:self.messageBtn.selected];
}
-(void)setMessage:(BOOL)isBlocked{
    WeakSelf;
    [[RCIMClient sharedRCIMClient]setConversationNotificationStatus:self.conversationType targetId:self.friendId isBlocked:isBlocked success:^(RCConversationNotificationStatus nStatus) {
        //免打扰
        if (nStatus == 0) {
            weakSelf.messageBtn.selected = YES;
        }else{
            //消息提醒
            weakSelf.messageBtn.selected = NO;
        }
    } error:^(RCErrorCode status) {
        NSSLog(@"状态码：%ld",(long)status);
    }];
}
//置顶聊天
- (IBAction)topChatClick:(id)sender {
    self.topChatBtn.selected = !self.topChatBtn.selected;
    [[RCIMClient sharedRCIMClient]setConversationToTop:self.conversationType targetId:self.friendId isTop:self.topChatBtn.selected];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:self.topChatBtn.selected forKey:@"topChatPerson"];
    [userDefaults synchronize];
}

#pragma mark- 解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.widthContraints.constant = KMainScreenWidth+5;
    if ((self.deleteView.frame.origin.y+75)<KMainScreenHeight) {
        self.scrollView.scrollEnabled = NO;
    }else{
        self.scrollView.scrollEnabled = YES;
  
    }
//    NSSLog(@"%f==%f===%f",KMainScreenWidth,self.scrollView.frame.size.width,self.deleteView.frame.size.width);
}

@end
