//
//  VipRegisterController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/1.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "VipRegisterController.h"
#import "LoginController.h"
#import "ConfirmInfoController.h"
#import "UIView+ChatMoreView.h"

#define RegisterURL @"appapi/app/register"

@interface VipRegisterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong)UIWindow * window;
@end

@implementation VipRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self leftView:self.phoneTF andFrame:CGRectMake(18, 9.5, 14.5, 25.5) imageName:@"leftUser"];
    [self leftView:self.passwordTF andFrame:CGRectMake(20, 12.7, 17, 20.5) imageName:@"leftSecret"];
    [self leftView:self.nicknameTF andFrame:CGRectMake(20, 12.7, 18.5, 20.5) imageName:@"nickname"];
    [self leftView:self.codeTF andFrame:CGRectMake(18.5, 14.5, 22.5, 16) imageName:@"leftEmail"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
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
    
}
- (IBAction)registerClick:(id)sender {
    [self tapClick];
    if (self.nicknameTF.text.length != 0 && self.phoneTF.text.length != 0 && self.codeTF.text.length != 0 && self.passwordTF.text.length != 0) {
        [self netWork];
    }else{
        [self showBackViewUI:@"亲，信息没有填写完整"];
        
    }
    
}
//判断网络状态
-(void)netWork{
    
    AFNetworkReachabilityManager * net = [AFNetworkReachabilityManager sharedManager];
    
    [net startMonitoring];
    WeakSelf;
    [net setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            [weakSelf showBackViewUI:@"你已进入网络异次元，快去打开网络吧！"];
            
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                //注册登录
                [weakSelf registerMessage];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
            
        }
        
        
    }];
}
-(void)registerMessage{
    WeakSelf;
    NSDictionary * params = @{@"nickname":self.nicknameTF.text,@"mobile":self.phoneTF.text,@"password":self.passwordTF.text,@"recommendId":self.codeTF.text};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,RegisterURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"注册失败：%@",error);
            [weakSelf showBackViewUI:@"注册失败，点击重新试试吧！"];
        }else{
            NSNumber *code = data[@"code"];
            NSSLog(@"%@",code);
            if ([code intValue] == 200||[code intValue] == 100) {
                NSSLog(@"注册成功/注册过没确认");
                //进入信息确认界面
                [weakSelf presentSureInfoUI:weakSelf.phoneTF.text andPassword:weakSelf.passwordTF.text andCode:self.codeTF.text];
            }else if ([code intValue] == 1000){
                [weakSelf showBackViewUI:@"邀请码填写失误了么！"];
            }else if ([code intValue] == 0){
                [weakSelf showBackViewUI:@"注册失败，点击重新试试吧！"];
            }
        }
    }];
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
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGFloat offset = textField.frame.origin.y+50-(KMainScreenHeight-216);
    NSSLog(@"%f",offset);
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
-(void)showBackViewUI:(NSString *)title{
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.backView = [UIView sureViewTitle:title andTag:133 andTarget:self andAction:@selector(buttonAction:)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewAction)];
    [self.backView addGestureRecognizer:tap];
    [self.window addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(KMainScreenWidth);
        make.height.mas_equalTo(KMainScreenHeight);
    }];
}
-(void)buttonAction:(UIButton *)btn{
    self.backView.hidden = YES;
    
}
-(void)hideViewAction{
    self.backView.hidden = YES;
}
- (IBAction)backClick:(id)sender {
    
    UIViewController * vc = self.presentingViewController;
    while (![vc isKindOfClass:[LoginController class]]) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];

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
@end
