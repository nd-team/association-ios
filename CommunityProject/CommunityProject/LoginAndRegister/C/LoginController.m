//
//  LoginController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()
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

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}
-(void)setUI{
    self.twoLine.hidden = YES;
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

}
-(void)leftView:(UITextField *)textField{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 45)];
    
    backView.backgroundColor = UIColorFromRGB(0xefefef);
    
    textField.leftView = backView;
    
    textField.leftViewMode = UITextFieldViewModeAlways;
}
//登录操作
- (IBAction)loginClick:(id)sender {
}
- (IBAction)registerClick:(id)sender {
}
- (IBAction)loginButtonClick:(id)sender {
}
- (IBAction)registerButtonClick:(id)sender {
}

@end
