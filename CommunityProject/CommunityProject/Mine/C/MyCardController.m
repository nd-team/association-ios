//
//  MyCardController.m
//  CommunityProject
//
//  Created by bjike on 17/4/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyCardController.h"

@interface MyCardController ()

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

@end

@implementation MyCardController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"名片";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self setUI];
    
}
//初始化传参过来的数据
-(void)setUI{
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userPortraitUrl]];
    self.nameLabel.text = self.nickname;
    if (self.sex == 1) {
        self.sexImageView.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sexImageView.image = [UIImage imageNamed:@"woman.png"];
    }
    self.userLabel.text = self.userId;
   
    self.recomendLabel.text = self.recommendStr;
    
    self.emailLabel.text = self.email;
    
    self.knowLabel.text = self.lingStr;
    
    self.phoneLabel.text = self.mobile;
    self.contributeLabel.text = self.contributeCount;
    self.prestigeLabel.text = self.prestigeCount;
    self.birthdayLabel.text = self.birthday;
    self.areaLabel.text = self.address;
   
}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
