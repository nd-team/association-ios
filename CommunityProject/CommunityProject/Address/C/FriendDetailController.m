//
//  FriendDetailController.m
//  CommunityProject
//
//  Created by bjike on 17/3/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "FriendDetailController.h"
#import "NameViewController.h"
#import "ChatDetailController.h"

@interface FriendDetailController ()
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

@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;

@end

@implementation FriendDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBar];
    [self setUI];
}
-(void)setBar{
    self.navigationItem.title = @"详细资料";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
//初始化传参过来的数据
-(void)setUI{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.url]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@  %@岁",self.display,self.age];
    if (self.sex == 1) {
        self.sexImageView.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sexImageView.image = [UIImage imageNamed:@"woman.png"];

    }
    self.userLabel.text = [NSString stringWithFormat:@"账号：%@",self.friendId];
    self.recomendLabel.text = [NSString stringWithFormat:@"推荐：%@",self.recomendPerson];
    self.emailLabel.text = [NSString stringWithFormat:@"邮箱：%@",self.email];
    self.knowLabel.text = [NSString stringWithFormat:@"认领：%@",self.lingPerson];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",self.phone];
    self.contributeLabel.text = [NSString stringWithFormat:@"贡献值：%@",self.contribute];
    self.birthdayLabel.text = [NSString stringWithFormat:@"生日：%@",self.birthday];
    self.prestigeLabel.text = [NSString stringWithFormat:@"信誉值：%@",self.prestige];
    self.areaLabel.text = [NSString stringWithFormat:@"地址：%@",self.areaStr];
   
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//网络请求更多数据
- (IBAction)moreClick:(id)sender {
    
}
- (IBAction)changeNicknameClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    NameViewController * nameVC = [sb instantiateViewControllerWithIdentifier:@"NameViewController"];
    nameVC.friendDelegate = self;
    nameVC.friendId = self.friendId;
    nameVC.name = @"备注";
    nameVC.titleCount = 1;
    [self.navigationController pushViewController:nameVC animated:YES];

}
//发送消息
- (IBAction)sendMessage:(id)sender {
    
    ChatDetailController * chat = [[ChatDetailController alloc]initWithConversationType:ConversationType_PRIVATE targetId:self.friendId];
    chat.conversationType = ConversationType_PRIVATE;
    chat.targetId = self.friendId;
    //会话人备注
    chat.title = self.display;
    [self.navigationController pushViewController:chat animated:YES];
}



#pragma mark- 解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.widthContraints.constant = KMainScreenWidth;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.displayNameLabel.text = self.display;

}
@end
