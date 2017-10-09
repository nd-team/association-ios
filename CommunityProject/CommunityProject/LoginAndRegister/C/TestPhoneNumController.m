//
//  TestPhoneNumController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "TestPhoneNumController.h"
#import "LoginController.h"
#import <SMS_SDK/SMSSDK.h>
#import "PasswordSetController.h"

@interface TestPhoneNumController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)int count;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation TestPhoneNumController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self leftView:self.phoneTF andFrame:CGRectMake(18, 9.5, 14.5, 25.5) imageName:@"leftUser"];
    [self leftView:self.codeTF andFrame:CGRectMake(18.5, 14.5, 22.5, 16) imageName:@"leftEmail"];
    [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"codeBtn"] forState:UIControlStateNormal];
    [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"already"] forState:UIControlStateDisabled];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"disableBtn"] forState:UIControlStateDisabled];
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTitle) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    self.nextBtn.enabled = NO;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    
    [self.view addGestureRecognizer:tap];
}
-(void)tapAction{
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
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
- (IBAction)backClick:(id)sender {
    UIViewController * vc = self.presentingViewController;
    while (![vc isKindOfClass:[LoginController class]]) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendCodeClick:(id)sender {
    self.count = 120;
    if ([ImageUrl isEmptyStr:self.phoneTF.text]) {
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
            [weakSelf tapAction];
            weakSelf.codeBtn.enabled = YES;
            [weakSelf showMessage:@"获取验证码失败，点击重新获取"];
            
        }
    }];
    
}
- (IBAction)nextStepClick:(id)sender {
    //验证验证码
    [self sureCode];
   
}
-(void)sureCode{
    WeakSelf;
    [SMSSDK commitVerificationCode:self.codeTF.text phoneNumber:self.phoneTF.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                PasswordSetController * test = [sb instantiateViewControllerWithIdentifier:@"PasswordSetController"];
                [weakSelf presentViewController:test animated:YES completion:nil];
            });
        }else{
            [weakSelf showMessage:@"短信验证失败"];
            
        }
    }];
}
-(void)showMessage:(NSString *)message{
    
    [self.view makeToast:message];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (![ImageUrl isEmptyStr:self.phoneTF.text]&&![ImageUrl isEmptyStr:self.codeTF.text]) {
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.enabled = NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneTF) {
        [self.phoneTF resignFirstResponder];
        [self.codeTF becomeFirstResponder];
    }else{
        [self.phoneTF resignFirstResponder];
        [self.codeTF resignFirstResponder];
    }
    return YES;
}
@end
