//
//  LoginController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "LoginController.h"
#define LoginURL @"appapi/app/login"
#define RegisterURL @"appapi/app/register"
@interface LoginController ()<UITextFieldDelegate,RCIMConnectionStatusDelegate>{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *oneLine;
@property (weak, nonatomic) IBOutlet UIImageView *twoLine;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *secretTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
//@property (nonatomic,assign)CGFloat height;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    //监听键盘
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    

}
//-(void)keyboardWillShow:(NSNotification *)nofi{
//    NSDictionary * userInfo = [nofi userInfo];
//    NSValue * aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyRect = [aValue CGRectValue];
//    NSSLog(@"%f",keyRect.size.height);
//    self.height = keyRect.size.height;
//    
//   
//}
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//}
-(void)setUI{
    self.msgLabel.hidden = YES;
    self.twoLine.hidden = YES;
    self.registerView.hidden = YES;
    [self.loginBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [self.registerBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [self leftView:self.usernameTF];
    [self leftView:self.secretTF];
    [self leftView:self.phoneTF];
    [self leftView:self.passwordTF];
    [self leftView:self.nicknameTF];
    [self leftView:self.codeTF];
    [self.usernameTF becomeFirstResponder];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"token"];
    NSString * phone = [userDefaults objectForKey:@"userId"];
    NSString * password = [userDefaults objectForKey:@"password"];
    if (token.length && phone.length && password.length) {
        self.usernameTF.text = phone;
        self.secretTF.text = password;
        [self netWork:YES];
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapClick{
    if (self.loginView.hidden) {
        [self.phoneTF resignFirstResponder];
        [self.passwordTF resignFirstResponder];
        [self.nicknameTF resignFirstResponder];
        [self.codeTF resignFirstResponder];
    }else{
        [self.usernameTF resignFirstResponder];
        [self.secretTF resignFirstResponder];
    }
    self.view.frame = CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight);

    
}
-(void)leftView:(UITextField *)textField{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 45)];
    
    backView.backgroundColor = UIColorFromRGB(0xefefef);
    
    textField.leftView = backView;
    
    textField.leftViewMode = UITextFieldViewModeAlways;
}
//登录操作下面的登录注册
- (IBAction)loginClick:(id)sender {
    if (self.usernameTF.text.length == 0) {
        [self showMessage:@"账号不能为空！"];
        
    }else if(self.secretTF.text.length == 0){
        [self showMessage:@"密码不能为空！"];
        
    }else{
        [self netWork:YES];
    }
    
    
}
- (IBAction)registerClick:(id)sender {
    //
    if (self.nicknameTF.text.length != 0 && self.phoneTF.text.length != 0 && self.codeTF.text.length != 0 && self.passwordTF.text.length != 0) {
        [self netWork:NO];
    }else{
        [self showMessage:@"亲，信息没有填写完整"];
        
    }
}
//上面的登录和注册
- (IBAction)loginButtonClick:(id)sender {
    self.loginBtn.selected = YES;
    self.registerBtn.selected = NO;
    self.loginView.hidden = NO;
    self.registerView.hidden = YES;
    self.oneLine.hidden = NO;
    self.twoLine.hidden = YES;
}
- (IBAction)registerButtonClick:(id)sender {
    self.loginBtn.selected = NO;
    self.registerBtn.selected = YES;
    self.loginView.hidden = YES;
    self.registerView.hidden = NO;
    self.oneLine.hidden = YES;
    self.twoLine.hidden = NO;
}
-(void)registerMessage{
    WeakSelf;
    NSDictionary * params = @{@"nickname":self.nicknameTF.text,@"mobile":self.phoneTF.text,@"password":self.passwordTF.text,@"recommendId":self.codeTF.text};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,RegisterURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"注册失败：%@",error);
        }else{
            NSNumber *code = data[@"code"];
            NSSLog(@"%@",code);
            if ([code intValue] == 200) {
                NSSLog(@"注册成功");
               //进入信息确认界面
                
            }else if ([code intValue] == 1000){
                [weakSelf showMessage:@"邀请码填写失误了么！"];
            }else if ([code intValue] == 0){
                [weakSelf showMessage:@"注册失败，点击重新试试吧！"];
            }
        }
    }];
}
//判断网络状态
-(void)netWork:(BOOL)isLogin{
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
                if (isLogin) {
                    [weakSelf loginNet];
                }else{
                    [weakSelf registerMessage];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
           
        }
        
        
    }];
}

-(void)loginNet{
    WeakSelf;
    NSDictionary * dic = @{@"mobile":self.usernameTF.text,@"password":self.secretTF.text};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,LoginURL] andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        
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
                [userDefaults setValue:self.secretTF.text forKey:@"password"];
                //sex
                NSNumber * sex = msg[@"sex"];
                [userDefaults setInteger:[sex integerValue] forKey:@"sex"];
                if (![msg[@"age"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setInteger:[msg[@"age"] integerValue]forKey:@"age"];
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
                if (![msg[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"recommendUserId"] forKey:@"recommendUserId"];
                }
                if (![msg[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"claimUserId"] forKey:@"claimUserId"];
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
                [userDefaults synchronize];
                //设置当前用户
                RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:msg[@"userId"] name:msg[@"nickname"] portrait:url];
                [RCIM sharedRCIM].currentUserInfo = userInfo;
                [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:msg[@"userId"]];
                [weakSelf loginMain];

                [weakSelf loginRongServicer:msg[@"token"]];

                
            }else if ([code intValue] == 0){
                [weakSelf showMessage:@"账号不存在！"];
            }else if ([code intValue] == 1000){
                [weakSelf showMessage:@"账号禁止登录！"];
            }else if ([code intValue] == 1001){
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
        NSSLog(@"登录成功%@",userId);
        //登录主界面
    } error:^(RCConnectErrorCode status) {
        NSSLog(@"错误码：%ld",(long)status);
        //SDK自动重新连接
        [[RCIM sharedRCIM]setConnectionStatusDelegate:self];
    } tokenIncorrect:^{
        NSSLog(@"token错误");
        [weakSelf loginMain];
    }];
}
-(void)loginMain{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    });
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == ConnectionStatus_Connected) {
            [RCIM sharedRCIM].connectionStatusDelegate = (id<RCIMConnectionStatusDelegate>)[UIApplication sharedApplication].delegate;
            [weakSelf loginMain];
        } else if (status == ConnectionStatus_NETWORK_UNAVAILABLE) {
//            [weakSelf showMessage:@"当前网络不可用，请检查！"];
            [weakSelf loginMain];

        } else if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
            [weakSelf showMessage:@"您的帐号在别的设备上登录，您被迫下线！"];
        } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
            NSSLog(@"Token无效");
//            [weakSelf showMessage:@"无法连接到服务器！"];
            [weakSelf loginMain];
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
    if (!self.loginView.hidden) {
        if (textField == self.usernameTF) {
            [self.usernameTF resignFirstResponder];
            [self.secretTF becomeFirstResponder];
        }else {
            [self.usernameTF resignFirstResponder];
            [self.secretTF resignFirstResponder];
            self.view.frame = CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight);
        }
    }else{
        if (textField == self.phoneTF) {
            [self.phoneTF resignFirstResponder];
            [self.nicknameTF becomeFirstResponder];
        }else if(textField == self.nicknameTF){
            [self.nicknameTF resignFirstResponder];
            [self.passwordTF becomeFirstResponder];
        }else if(textField == self.passwordTF){
            [self.passwordTF resignFirstResponder];
            [self.codeTF becomeFirstResponder];
        }else{
            [self.phoneTF resignFirstResponder];
            [self.passwordTF resignFirstResponder];
            [self.nicknameTF resignFirstResponder];
            [self.codeTF resignFirstResponder];
            self.view.frame = CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight);

        }
    }
   
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = self.registerView.frame.origin.y+textField.frame.origin.y+50-(KMainScreenHeight-216);
    if (textField == self.passwordTF||textField == self.codeTF){
        self.view.frame = CGRectMake(0, -offset, KMainScreenWidth, KMainScreenHeight);
    }
   
    return YES;
}
@end
