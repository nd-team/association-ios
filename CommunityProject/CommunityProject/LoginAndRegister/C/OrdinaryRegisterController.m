//
//  OrdinaryRegisterController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/1.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "OrdinaryRegisterController.h"
#import "LoginController.h"
#import <SMS_SDK/SMSSDK.h>

#define RegisterURL @"appapi/app/ordinaryRegister"
#define LoginURL @"appapi/app/login"

@interface OrdinaryRegisterController ()<UITextFieldDelegate,RCIMConnectionStatusDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)int count;

@end

@implementation OrdinaryRegisterController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"codeBtn"] forState:UIControlStateNormal];
    [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"already"] forState:UIControlStateDisabled];
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTitle) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    
    [self leftView:self.phoneTF andFrame:CGRectMake(18, 9.5, 14.5, 25.5) imageName:@"leftUser"];
    [self leftView:self.passwordTF andFrame:CGRectMake(20, 12.7, 17, 20.5) imageName:@"leftSecret"];
    [self leftView:self.nicknameTF andFrame:CGRectMake(20, 12.7, 18.5, 20.5) imageName:@"nickname"];
    [self leftView:self.codeTF andFrame:CGRectMake(18.5, 14.5, 22.5, 16) imageName:@"leftEmail"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
}
-(void)changeTitle{
    if (self.count > 0) {
        self.count --;
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%d s",self.count] forState:UIControlStateDisabled];
        
    }else{
        self.codeBtn.enabled = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}
-(void)tapClick{
    [self.phoneTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.nicknameTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
    }];
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
//发送验证码
- (IBAction)sendCodeClick:(id)sender {
    self.count = 120;
    if ([ImageUrl changeUrl:self.phoneTF.text]) {
        [self showMessage:@"亲，请输入手机号码"];
    }else if (self.phoneTF.text.length !=11) {
        [self showMessage:@"亲，手机号码输入有误"];
    }else{
        self.codeBtn.enabled = NO;
        [self.timer setFireDate:[NSDate distantPast]];
        [self getCodeData];
 
    }
}
-(void)getCodeData{
    WeakSelf;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSSLog(@"获取验证码成功");

        }else{

            NSSLog(@"获取验证码失败error:%@",error);
            [weakSelf.timer setFireDate:[NSDate distantFuture]];
            [weakSelf tapClick];
            weakSelf.codeBtn.enabled = YES;
            [weakSelf showMessage:@"获取验证码失败，点击重新获取"];

        }
    }];
    
}
- (IBAction)registerClick:(id)sender {
    int length = [ImageUrl convertToInt:self.nicknameTF.text];
    if (length > 12) {
        //请输入少于7个中文的昵称
        [self showMessage:@"亲，昵称不可输入超过6个中文哦！"];
        return;
    }

    [self tapClick];
    if (self.nicknameTF.text.length != 0 && self.phoneTF.text.length != 0 && self.codeTF.text.length != 0 && self.passwordTF.text.length != 0) {
        [self netWork];
    }else{
        [self showMessage:@"亲，信息没有填写完整"];
        
    }
}
- (IBAction)backClick:(id)sender {
    UIViewController * vc = self.presentingViewController;
    while (![vc isKindOfClass:[LoginController class]]) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

//判断网络状态
-(void)netWork{
    
    AFNetworkReachabilityManager * net = [AFNetworkReachabilityManager sharedManager];
    
    [net startMonitoring];
    WeakSelf;
    [net setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            [weakSelf showMessage:@"你已进入网络异次元，快去打开网络吧！"];
            
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                //先验证短信码在进行注册
                [weakSelf sureCode];
            
            });
            
        }
        
        
    }];
}
-(void)sureCode{
    WeakSelf;
    [SMSSDK commitVerificationCode:self.codeTF.text phoneNumber:self.phoneTF.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        if (!error) {
            [weakSelf registerMessage];
        }else{
            [weakSelf showMessage:@"短信验证失败"];
            
        }
    }];
}
-(void)registerMessage{
    WeakSelf;
    NSDictionary * params = @{@"nickname":self.nicknameTF.text,@"mobile":self.phoneTF.text,@"password":self.passwordTF.text};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,RegisterURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"注册失败：%@",error);
            [weakSelf showMessage:@"注册失败，请重新获取验证码！"];
            [weakSelf dismissCommon];
        }else{
            NSNumber *code = data[@"code"];
//            NSSLog(@"%@",code);
            if ([code intValue] == 200||[code intValue] == 100) {
                //登录
                [weakSelf loginNet];
            }else if ([code intValue] == 1000){
                [weakSelf showMessage:@"验证码填写失误了么！"];
                [weakSelf dismissCommon];

            }else if ([code intValue] == 0){
                [weakSelf showMessage:@"注册失败，请重新获取验证码！"];
                [weakSelf dismissCommon];

            }
        }
    }];
}
-(void)dismissCommon{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}
-(void)loginNet{
    WeakSelf;
    NSDictionary * dic = @{@"mobile":self.phoneTF.text,@"password":self.passwordTF.text};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,LoginURL] andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        [weakSelf dismissCommon];
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
                //头像
                NSString * url = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:msg[@"userPortraitUrl"]]];
                [userDefaults setValue:url forKey:@"userPortraitUrl"];
                //token
                [userDefaults setValue:msg[@"token"] forKey:@"token"];
                [userDefaults setValue:weakSelf.passwordTF.text forKey:@"password"];
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
                if (![msg[@"experience"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"experience"]] forKey:@"experience"];
                }
                if (![msg[@"creditScore"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"creditScore"]] forKey:@"creditScore"];
                }
                if (![msg[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"contributionScore"]] forKey:@"contributionScore"];
                }
                if (![msg[@"favour"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"favour"] forKey:@"favour"];
                }
                //普通用户
                [userDefaults setValue:@"1" forKey:@"status"];
                [userDefaults synchronize];
                //设置当前用户
                RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:msg[@"userId"] name:msg[@"nickname"] portrait:url];
                [RCIM sharedRCIM].currentUserInfo = userInfo;
                [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:msg[@"userId"]];
                [weakSelf loginRongServicer:msg[@"token"]];
                
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
    WeakSelf;
    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
//        NSSLog(@"登录成功%@",userId);
        [weakSelf loginMain];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField{

    CGFloat offset = textField.frame.origin.y+50-(KMainScreenHeight-216-64);
    if (offset>0){
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, -offset, KMainScreenWidth, KMainScreenHeight);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
        }];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneTF) {
        [self.phoneTF resignFirstResponder];
        [self.nicknameTF becomeFirstResponder];
    }else if (textField == self.nicknameTF){
        [self.nicknameTF resignFirstResponder];
        [self.passwordTF becomeFirstResponder];

    }else if (textField == self.passwordTF){
        [self.passwordTF resignFirstResponder];
        [self.codeTF becomeFirstResponder];
        
    }else{
        [self tapClick];
    }
    return YES;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
@end
