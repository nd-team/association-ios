//
//  MainTabBarController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MainTabBarController.h"
#import "UIColor+RCColor.h"
//#import "MineController.h"
//#import "ChatMainController.h"
//#import "AddressListController.h"
//#import "InterestTeamController.h"
//#import "FirstController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

   //隐藏顶部线条
    UIImage * img = [UIColor imageWithColor:[UIColor whiteColor]];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, self.tabBar.frame.size.height)];
    imageView.image = img;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.tabBar insertSubview:imageView atIndex:0];
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
//    UIStoryboard * sb1 = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
//    FirstController * first = [sb1 instantiateViewControllerWithIdentifier:@"FirstController"];
//    [self addChildVc:first title:@"首页" image:@"firstNor" selectedImage:@"firstSel"];
//    
//    UIStoryboard * sb2 = [UIStoryboard storyboardWithName:@"WeChat" bundle:nil];
//    ChatMainController *chat = [sb2 instantiateViewControllerWithIdentifier:@"ChatMainController"];
//    [self addChildVc:chat title:@"聊天" image:@"chat" selectedImage:@"chatSel"];
//    UIStoryboard * sb3 = [UIStoryboard storyboardWithName:@"Interest" bundle:nil];
//    InterestTeamController * interest = [sb3 instantiateViewControllerWithIdentifier:@"InterestTeamController"];
//    [self addChildVc:interest title:@"兴趣联盟" image:@"interestBar" selectedImage:@"interestSel"];
//    
//    UIStoryboard * sb4 = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
//    AddressListController * address = [sb4 instantiateViewControllerWithIdentifier:@"AddressListController"];
//    [self addChildVc:address title:@"通讯录" image:@"address" selectedImage:@"addressSel"];
//    
//    UIStoryboard * sb5 = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
//    MineController * mine = [sb5 instantiateViewControllerWithIdentifier:@"MineController"];
//    [self addChildVc:mine title:@"我的" image:@"mineNor" selectedImage:@"mineSel"];

}
//- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
//{
//    childVc.title = title;
//    childVc.tabBarItem.image = [UIImage imageNamed:image];
//    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = RGB(177, 177, 177);
//    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
//    selectTextAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x10db9f);
//    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//    
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:childVc];
//    
//    [self addChildViewController:nav];
//    
//    
//}

@end
