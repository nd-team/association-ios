//
//  UIView+ChatWhiteView.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "UIView+ChatWhiteView.h"

@implementation UIView (ChatWhiteView)
+(UIView *)createWhiteView:(NSString *)title andImageName:(NSString *)imgName andFont:(CGFloat)font andColor:(UIColor *)color{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];

    view.backgroundColor = UIColorFromRGB(0xeceef0);
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:imgName];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(212);
        make.centerX.equalTo(view);
        make.width.mas_equalTo(175);
        make.height.mas_equalTo(91);
    }];
    UILabel * label = [UILabel new];
    label.text = title;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(13);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(250);
        make.centerX.equalTo(view);
    }];
    return view;
}
+(UIView *)showViewTitle:(NSString *)title{
    UIView * view = [UIView new];
    view.frame = CGRectMake(20, KMainScreenHeight, KMainScreenWidth-40, 50);
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    view.layer.cornerRadius = 5;
    UILabel * label = [UILabel new];
    label.textColor = UIColorFromRGB(0xffffff);
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = title;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.preferredMaxLayoutWidth = (KMainScreenWidth-60);
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(view);
    }];
    
    return view;
}
@end
