//
//  MainTabBarController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

//隐藏顶部线条
    CGRect rect  = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, self.tabBar.frame.size.height)];
    imageView.image = img;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.tabBar insertSubview:imageView atIndex:0];
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];

}

@end
