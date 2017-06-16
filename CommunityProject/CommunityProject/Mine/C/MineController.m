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
#import "AreadyRecommendController.h"
#import "PersonBaseInfoController.h"
#import "RecommendController.h"
#import "SignInViewController.h"
#import "MyCodeCardController.h"
#import "ApplicationVipController.h"

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
//头像
@property (nonatomic,copy)NSString * url;
//性别
@property (nonatomic,assign)NSInteger sex;
@property (nonatomic,copy)NSString * nickname;
@property (nonatomic,copy)NSString * mobile;
@property (nonatomic,copy)NSString * address;

@property (nonatomic,copy)NSString * birth;
@property (nonatomic,copy)NSString * email;
@property (nonatomic,copy)NSString * recomend;
@property (nonatomic,copy)NSString * lingStr;
@property (nonatomic,copy)NSString * presCount;
@property (nonatomic,copy)NSString * expCount;
@property (nonatomic,copy)NSString * conCount;

@end

@implementation MineController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    //更多消息里面更改
    self.mobile  = [DEFAULTS objectForKey:@"mobile"];
    if (self.mobile.length != 0) {
        self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",self.mobile];
    }else{
        self.phoneLabel.text = @"电话：";
        
    }
    self.birth = [DEFAULTS objectForKey:@"birthday"];
    if (self.birth.length != 0) {
        self.birthdayLabel.text = [NSString stringWithFormat:@"生日：%@",self.birth];
    }else{
        self.birthdayLabel.text = @"生日：";
    }
    if (self.isRef) {
        [self setUI];
    }

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
    self.nickname = [DEFAULTS objectForKey:@"nickname"];
    self.url = [DEFAULTS objectForKey:@"userPortraitUrl"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.url]];
    self.nameLabel.text = self.nickname;
    self.sex = [DEFAULTS integerForKey:@"sex"];
    if (self.sex == 1) {
        self.sexImageView.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sexImageView.image = [UIImage imageNamed:@"woman.png"];
    }
    self.userId = [DEFAULTS objectForKey:@"numberId"];
    self.userLabel.text = [NSString stringWithFormat:@"账号：%@",self.userId];
    self.recomend = [DEFAULTS objectForKey:@"recommendUserId"];
    self.recomendLabel.text = [NSString stringWithFormat:@"推荐：%@",self.recomend];
    self.email = [DEFAULTS objectForKey:@"email"];
    if (self.email.length != 0) {
        self.emailLabel.text = [NSString stringWithFormat:@"邮箱：%@",self.email];

    }else{
        self.emailLabel.text = @"邮箱：";
    }
    self.lingStr = [DEFAULTS objectForKey:@"claimUserId"];
    if (self.lingStr.length != 0) {
        self.knowLabel.text = [NSString stringWithFormat:@"认领：%@",self.lingStr];

    }else{
        self.knowLabel.text = @"认领：";
    }
    
    self.conCount = [DEFAULTS objectForKey:@"contributionScore"];
    self.contributeLabel.text = [NSString stringWithFormat:@"贡献值：%@",self.conCount];
    self.presCount = [DEFAULTS objectForKey:@"creditScore"];
    self.prestigeLabel.text = [NSString stringWithFormat:@"信誉值：%@",self.presCount];
    
    
    self.address = [DEFAULTS objectForKey:@"address"];
    if (self.address.length != 0) {
        self.areaLabel.text = [NSString stringWithFormat:@"地址：%@",self.address];
    }else{
      self.areaLabel.text = @"地址：";
    }
}
//签到
- (IBAction)arriveClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    SignInViewController * sign = [sb instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self.navigationController pushViewController:sign animated:YES];

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
    [self.navigationController pushViewController:set animated:YES];
}
//推荐
- (IBAction)recomendClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    RecommendController * recomm = [sb instantiateViewControllerWithIdentifier:@"RecommendController"];
    [self.navigationController pushViewController:recomm animated:YES];
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
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    PersonBaseInfoController * person = [sb instantiateViewControllerWithIdentifier:@"PersonBaseInfoController"];
    person.delegete = self;
    //传参
    person.userId = self.userId;
    person.nickname = self.nickname;
    person.userPortraitUrl = self.url;
    person.sex = self.sex;
    person.mobile = self.mobile;
    person.email = self.email;
    person.recommendStr = self.recomend;
    person.lingStr = self.lingStr;
    person.contributeCount = self.conCount;
    person.prestigeCount = self.presCount;
    person.address = self.address;
    person.expCount = [NSString stringWithFormat:@"%@",[DEFAULTS objectForKey:@"experience"]];
    [self.navigationController pushViewController:person animated:YES];

}
//我的钱包
- (IBAction)myWalletCclick:(id)sender {
    [JrmfWalletSDK openWallet];
}
//已推荐人
- (IBAction)alreadyRecommendClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    AreadyRecommendController * recommend = [sb instantiateViewControllerWithIdentifier:@"AreadyRecommendController"];
    [self.navigationController pushViewController:recommend animated:YES];

}
//二维码名片
- (IBAction)myCodeCardClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    MyCodeCardController * set = [sb instantiateViewControllerWithIdentifier:@"MyCodeCardController"];
    //传参
    set.userId = self.userLabel.text;
    set.nickname = self.nameLabel.text;
    set.userPortraitUrl = self.url;
    set.sex = self.sex;
    [self.navigationController pushViewController:set animated:YES];
 
}
//申请VIP
- (IBAction)vipClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    ApplicationVipController * application = [sb instantiateViewControllerWithIdentifier:@"ApplicationVipController"];
    [self.navigationController pushViewController:application animated:YES];
}

//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.widthContraints.constant = KMainScreenWidth;
    if (self.lastView.frame.origin.y+178<KMainScreenHeight) {
        self.scrollView.scrollEnabled = NO;
    }else{
        self.scrollView.scrollEnabled = YES;
    }
    
}
@end
