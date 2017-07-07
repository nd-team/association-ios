//
//  TrafficDetailController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/7.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "TrafficDetailController.h"

@interface TrafficDetailController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *hiddenView;

@property (weak, nonatomic) IBOutlet UIImageView *soldImageView;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;
@property (weak, nonatomic) IBOutlet UIView *noSoldView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *soldImageHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hiddenHeightCons;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImageHeightCons;

@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong)UIWindow * window;

@end

@implementation TrafficDetailController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;   
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    if (self.isLook) {
        self.navigationController.navigationBar.hidden = NO;
        self.navigationItem.title = @"预览";
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"发布" andLeft:15 andTarget:self Action:@selector(finishAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.backBtn.hidden = YES;
        
    }else{
        self.navigationController.navigationBar.hidden = YES;
    }
}
-(void)finishAction{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
//购买
- (IBAction)buyClick:(id)sender {
    
}
//分享
- (IBAction)shareClick:(id)sender {
    
}
//文章点赞
- (IBAction)loveClick:(id)sender {
    
}
//评论
- (IBAction)commentClick:(id)sender {
}


@end
