//
//  LoginController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "LoginController.h"
#import "ConfirmInfoController.h"
#import "OrdinaryRegisterController.h"
#import "VipRegisterController.h"

#define LoginURL @"appapi/app/login"
@interface LoginController ()<UITextFieldDelegate,RCIMConnectionStatusDelegate>{
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *secretTF;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.msgLabel.hidden = YES;
    [self leftView:self.usernameTF andFrame:CGRectMake(18, 9.5, 14.5, 25.5) imageName:@"leftUser"];
    [self leftView:self.secretTF andFrame:CGRectMake(21.5, 12.7, 17, 20.5) imageName:@"leftSecret"];
    [self.usernameTF becomeFirstResponder];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"token"];
    NSString * phone = [userDefaults objectForKey:@"userId"];
    NSString * password = [userDefaults objectForKey:@"password"];
    if (token.length != 0 && phone.length != 0 && password.length != 0) {
        self.usernameTF.text = phone;
        self.secretTF.text = password;
        [self netWork];
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapClick{
    [self.usernameTF resignFirstResponder];
    [self.secretTF resignFirstResponder];
}
-(void)leftView:(UITextField *)textField andFrame:(CGRect)frame imageName:(NSString *)imgName{
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 45)];
    leftView.backgroundColor = UIColorFromRGB(0xffffff);
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imgName];
    [leftView addSubview:imageView];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.borderColor = UIColorFromRGB(0xb5b5b5).CGColor;
    textField.layer.borderWidth = 1.0;
    [textField setValue:UIColorFromRGB(0xd6d6d6) forKeyPath:@"_placeholderLabel.textColor"];
    
    [textField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
}
//登录操作下面的登录注册
- (IBAction)loginClick:(id)sender {
    if (self.usernameTF.text.length == 0) {
        [self showMessage:@"账号不能为空！"];
        
    }else if(self.secretTF.text.length == 0){
        [self showMessage:@"密码不能为空！"];
        
    }else if(self.usernameTF.text.length != 11){
        [self showMessage:@"账号格式有误"];
        
    }else{
        [self netWork];
    }
    
    
}

-(void)presentSureInfoUI:(NSString *)phone andPassword:(NSString *)password andCode:(NSString *)code{
    //进入信息确认界面
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ConfirmInfoController * confirm = [sb instantiateViewControllerWithIdentifier:@"ConfirmInfoController"];
    confirm.phone = phone;
    confirm.password = password;
    confirm.code = code;
    [self presentViewController:confirm animated:NO completion:nil];

}
//判断网络状态
-(void)netWork{
    [self tapClick];

    AFNetworkReachabilityManager * net = [AFNetworkReachabilityManager sharedManager];
    
    [net startMonitoring];
    WeakSelf;
    [net setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            [weakSelf showMessage:@"你已进入网络异次元，快去打开网络吧！"];
            
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    [weakSelf loginNet];
            });
           
        }
        
        
    }];
}

-(void)loginNet{
    WeakSelf;
    NSDictionary * dic = @{@"mobile":self.usernameTF.text,@"password":self.secretTF.text};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,LoginURL] andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"登录失败：%@",error);
            [weakSelf showMessage:@"登录失败！"];

        }else{            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //成功
                NSDictionary * msg = data[@"data"];
                //保存用户数据
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                //用户ID
                [userDefaults setValue:msg[@"userId"] forKey:@"userId"];
                //昵称
                [userDefaults setValue:msg[@"nickname"] forKey:@"nickname"];
                //token
                [userDefaults setValue:msg[@"token"] forKey:@"token"];
                //头像
                NSString * url = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:msg[@"userPortraitUrl"]]];
                [userDefaults setValue:url forKey:@"userPortraitUrl"];
                [userDefaults setValue:weakSelf.secretTF.text forKey:@"password"];
                //sex
                NSNumber * sex = msg[@"sex"];
                [userDefaults setInteger:[sex integerValue] forKey:@"sex"];
                if (![msg[@"checkVip"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setInteger:[msg[@"checkVip"] integerValue]forKey:@"checkVip"];
                }
                if (![msg[@"birthday"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"birthday"] forKey:@"birthday"];
                }
                if (![msg[@"address"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"address"] forKey:@"address"];
                }
                if (![msg[@"email"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"email"] forKey:@"email"];
                }
                if (![msg[@"mobile"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"mobile"] forKey:@"mobile"];
                }
                if (![msg[@"numberId"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"numberId"] forKey:@"numberId"];
                }
                if (![msg[@"favour"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"favour"] forKey:@"favour"];
                }
                if (![msg[@"experience"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"experience"]] forKey:@"experience"];
                }
                if (![msg[@"creditScore"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"creditScore"]] forKey:@"creditScore"];
                }
                if (![msg[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"contributionScore"]] forKey:@"contributionScore"];
                }

                //设置当前用户
                RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:msg[@"userId"] name:msg[@"nickname"] portrait:url];
                [RCIM sharedRCIM].currentUserInfo = userInfo;
                [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:msg[@"userId"]];
                //VIP字段
                if ([[msg allKeys] containsObject:@"recommendUserId"]) {
                    if (![msg[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                        [userDefaults setValue:msg[@"recommendUserId"] forKey:@"recommendUserId"];
                    }
                }
                if ([[msg allKeys] containsObject:@"claimUserId"]) {
                    if (![msg[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                        [userDefaults setValue:msg[@"claimUserId"] forKey:@"claimUserId"];
                    }
                }
                
                if ([[msg allKeys] containsObject:@"status"]) {
                    NSInteger status = [msg[@"status"] integerValue];
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"status"]] forKey:@"status"];
                    if (status == 0) {
                        //信息未确认进入确认界面
                        [weakSelf presentSureInfoUI:weakSelf.usernameTF.text andPassword:weakSelf.secretTF.text andCode:msg[@"numberId"]];
                        
                    }else{              //已确认登录
                        
                        [weakSelf loginMain];
                        [weakSelf loginRongServicer:msg[@"token"]];
                        
                    }
                }else{
                    //普通用户登录
                    [userDefaults setValue:@"1" forKey:@"status"];
                    [weakSelf loginMain];
                    [weakSelf loginRongServicer:msg[@"token"]];
                }
              
                [userDefaults synchronize];
                
            }else if ([code intValue] == 0){
                [weakSelf showMessage:@"账号不存在！"];
            }else if ([code intValue] == 1002){
                [weakSelf showMessage:@"账号禁止登录！"];
            }else if ([code intValue] == 1003){
                [weakSelf showMessage:@"密码错误！"];
                //清空登录信息
                
            }else{
                [weakSelf showMessage:@"登录失败！"];
            }
        }
    }];
}
//登录融云服务器
-(void)loginRongServicer:(NSString *)token{
    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
        NSSLog(@"登录成功%@",userId);
        //登录主界面
    } error:^(RCConnectErrorCode status) {
        NSSLog(@"错误码：%ld",(long)status);
        //SDK自动重新连接
        [[RCIM sharedRCIM]setConnectionStatusDelegate:self];
    } tokenIncorrect:^{
        NSSLog(@"token错误");
    }];
}
-(void)loginMain{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    });
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == ConnectionStatus_Connected) {
            [RCIM sharedRCIM].connectionStatusDelegate = (id<RCIMConnectionStatusDelegate>)[UIApplication sharedApplication].delegate;
        } else if (status == ConnectionStatus_NETWORK_UNAVAILABLE) {
//            [weakSelf showMessage:@"当前网络不可用，请检查！"];

        } else if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
//            [weakSelf showMessage:@"您的帐号在别的设备上登录，您被迫下线！"];
        } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
            NSSLog(@"Token无效");
//            [weakSelf showMessage:@"无法连接到服务器！"];
        } else {
            NSLog(@"RCConnectErrorCode is %zd", status);
        }
    });
}

-(void)showMessage:(NSString *)message{
    
    self.msgLabel.hidden = NO;
    
    self.msgLabel.text = message;
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
}
-(void)timerAction{
    
    self.msgLabel.hidden = YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.usernameTF) {
        [self.usernameTF resignFirstResponder];
        [self.secretTF becomeFirstResponder];
    }else {
        [self tapClick];
    }
   
    return YES;
}
//普通注册
- (IBAction)ordinaryRegisterClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    OrdinaryRegisterController * ori = [sb instantiateViewControllerWithIdentifier:@"OrdinaryRegisterController"];
    [self presentViewController:ori animated:YES completion:nil];
}
//VIP注册
- (IBAction)vipRegisterClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    VipRegisterController * vip = [sb instantiateViewControllerWithIdentifier:@"VipRegisterController"];
    [self presentViewController:vip animated:YES completion:nil];
}


@end
