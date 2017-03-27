//
//  MainTabBarController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MainTabBarController.h"
#import "UIColor+RCColor.h"

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

}

@end
