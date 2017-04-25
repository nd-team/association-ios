//
//  MineController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MineController.h"
#import "GroupNoticeViewController.h"
#import "SettingViewController.h"
#import "MyCardController.h"
#import "MyPeopleController.h"

@interface MineController ()

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

@property (nonatomic,copy)NSString * userId;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (nonatomic,copy)NSString * url;
//性别
@property (nonatomic,assign)NSInteger sex;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation MineController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setUI];
}
-(void)setUI{
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x121212);
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    //设置头像和名字
    NSString * nickname = [DEFAULTS objectForKey:@"nickname"];
    NSInteger age = [DEFAULTS integerForKey:@"age"];
    self.url = [DEFAULTS objectForKey:@"userPortraitUrl"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.url]];
    self.nameLabel.text = nickname;
    if (age == 0) {
        self.ageLabel.text = @"0岁";
    }else{
        self.ageLabel.text = [NSString stringWithFormat:@"%ld岁",age];
    }
    self.sex = [DEFAULTS integerForKey:@"sex"];
    if (self.sex == 1) {
        self.sexImageView.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sexImageView.image = [UIImage imageNamed:@"woman.png"];
    }
    self.userLabel.text = [NSString stringWithFormat:@"账号：%@",[DEFAULTS objectForKey:@"userId"]];
    self.recomendLabel.text = [NSString stringWithFormat:@"推荐：%@",[DEFAULTS objectForKey:@"recommendUserId"]];
    NSString * email = [DEFAULTS objectForKey:@"email"];
    if (email.length != 0) {
        self.emailLabel.text = [NSString stringWithFormat:@"邮箱：%@",email];

    }else{
        self.emailLabel.text = @"邮箱：";
    }
    NSString * ling = [DEFAULTS objectForKey:@"claimUserId"];
    if (ling.length != 0) {
        self.knowLabel.text = [NSString stringWithFormat:@"认领：%@",ling];

    }else{
        self.knowLabel.text = @"认领：";
    }
    NSString * mobile  = [DEFAULTS objectForKey:@"mobile"];
    if (mobile.length != 0) {
        self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",mobile];
    }else{
        self.phoneLabel.text = @"电话：";
   
    }
    NSString * contri = [DEFAULTS objectForKey:@"contributionScore"];
    self.contributeLabel.text = [NSString stringWithFormat:@"贡献值：%@",contri];
    
    self.prestigeLabel.text = [NSString stringWithFormat:@"信誉值：%@",[DEFAULTS objectForKey:@"creditScore"]];
    
    NSString * birth = [DEFAULTS objectForKey:@"birthday"];
    if (birth.length != 0) {
        self.birthdayLabel.text = [NSString stringWithFormat:@"生日：%@",birth];
    }else{
       self.birthdayLabel.text = @"生日：";
    }
    NSString * area = [DEFAULTS objectForKey:@"address"];
    if (area.length != 0) {
        self.areaLabel.text = [NSString stringWithFormat:@"地址：%@",area];
    }else{
      self.areaLabel.text = @"地址：";
    }
}
//签到
- (IBAction)arriveClick:(id)sender {
    
    
}
//名片
- (IBAction)cardClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    MyCardController * set = [sb instantiateViewControllerWithIdentifier:@"MyCardController"];
    //传参
    set.userId = self.userLabel.text;
    set.nickname = self.nameLabel.text;
    set.userPortraitUrl = self.url;
    set.sex = self.sex;
    set.mobile = self.phoneLabel.text;
    set.email = self.emailLabel.text;
    set.recommendStr = self.recomendLabel.text;
    set.lingStr = self.knowLabel.text;
    set.birthday = self.birthdayLabel.text;
    set.contributeCount = self.contributeLabel.text;
    set.prestigeCount = self.prestigeLabel.text;
    set.address = self.areaLabel.text;
    set.ageStr = self.ageLabel.text;
    [self.navigationController pushViewController:set animated:YES];
}
//推荐
- (IBAction)recomendClick:(id)sender {
   
    
}
//我的人脉
- (IBAction)myPeopleClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    MyPeopleController * people = [sb instantiateViewControllerWithIdentifier:@"MyPeopleController"];
    [self.navigationController pushViewController:people animated:YES];

}
//反馈
- (IBAction)feedBackClick:(id)sender {
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    GroupNoticeViewController * notice = [sb instantiateViewControllerWithIdentifier:@"GroupNoticeViewController"];
    notice.dif = 2;
    notice.name = @"反馈";
    notice.rightStr = @"确定";
    [self.navigationController pushViewController:notice animated:YES];

}
//设置
- (IBAction)setClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    SettingViewController * set = [sb instantiateViewControllerWithIdentifier:@"SettingViewController"];
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:set animated:YES];

}
//编辑个人信息
- (IBAction)editClick:(id)sender {
    
}

//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    if (self.lastView.frame.origin.y+50<KMainScreenHeight) {
        self.scrollView.scrollEnabled = NO;
    }else{
        self.scrollView.scrollEnabled = YES;
    }
    
}
@end
