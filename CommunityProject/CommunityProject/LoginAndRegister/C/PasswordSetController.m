//
//  PasswordSetController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PasswordSetController.h"
#import "TestPhoneNumController.h"

@interface PasswordSetController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation PasswordSetController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self leftView:self.firstPasswordTF];
    [self leftView:self.secondPasswordTF];
    [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"disableBtn"] forState:UIControlStateDisabled];
    self.sureBtn.enabled = NO;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    
    [self.view addGestureRecognizer:tap];
}
-(void)tapAction{
    [self.firstPasswordTF resignFirstResponder];
    [self.secondPasswordTF resignFirstResponder];
}
-(void)leftView:(UITextField *)textField{
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 45)];
    leftView.backgroundColor = UIColorFromRGB(0xffffff);
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.borderColor = UIColorFromRGB(0xb5b5b5).CGColor;
    textField.layer.borderWidth = 1.0;
    [textField setValue:UIColorFromRGB(0xd6d6d6) forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
}
- (IBAction)backClick:(id)sender {
    UIViewController * vc = self.presentingViewController;
    while (![vc isKindOfClass:[TestPhoneNumController class]]) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)surePasswordClick:(id)sender {
    if ([self.firstPasswordTF.text isEqualToString:self.secondPasswordTF.text]) {
        //修改新密码请求
        
    }else{
        
        [self showMessage:@"亲，两次密码输入不一样哦！"];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.firstPasswordTF) {
        [self.firstPasswordTF resignFirstResponder];
        [self.secondPasswordTF becomeFirstResponder];
    }else{
        [self.firstPasswordTF resignFirstResponder];
        [self.secondPasswordTF resignFirstResponder];

    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (![ImageUrl isEmptyStr:self.firstPasswordTF.text]&&![ImageUrl isEmptyStr:self.secondPasswordTF.text]) {
        self.sureBtn.enabled = YES;
    }else{
        self.sureBtn.enabled = NO;
    }
}
-(void)showMessage:(NSString *)message{
    
    [self.view makeToast:message];
    
}
@end
