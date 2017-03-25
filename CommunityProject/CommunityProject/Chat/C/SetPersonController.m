//
//  SetPersonController.m
//  CommunityProject
//
//  Created by bjike on 17/3/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SetPersonController.h"
#import "ChatMainController.h"

#define BaseInfoURL @""
#define DeleteURL @"http://192.168.0.209:90/appapi/app/deleteUser"
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
@end

@implementation SetPersonController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBar];
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
    self.userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
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
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getUserInformation{
    //获取数据初始化数据
    
}
//删除好友
- (IBAction)deleteClick:(id)sender {
    [self deleteFriend];
}
-(void)deleteFriend{
    
    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:self.friendId name:self.nickname portrait:self.url];
    WeakSelf;
    [AFNetData postDataWithUrl:DeleteURL andParams:@{@"userId":self.userId,@"friendUserid":self.friendId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"删除好友失败%@",error);
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSSLog(@"%@",jsonDic);
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                //刷新SDK缓存 请求服务器的好友列表保存到数据库刷新才有效
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
    
}

#pragma mark- 解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.widthContraints.constant = KMainScreenWidth;
}

@end
