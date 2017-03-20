//
//  UIButton+button.m
//  ISSP
//
//  Created by bjike on 16/8/9.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "UIButton+button.h"
//#import <objc/runtime.h>
//static const void * chosenKey = &chosenKey;

@implementation UIButton (button)

+ (UIButton *)CreateTitleButtonWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)color font:(CGFloat)font andTitle:(NSString *)title{
    
    UIButton * btn = [[UIButton alloc] initWithFrame:frame];
    btn.backgroundColor = bgColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}
+ (UIButton *)CreateImageButtonWithFrame:(CGRect)frame  Image:(NSString *)image SelectedImage:(NSString *)sImage and:(id)target Action:(SEL)action{
    UIButton * btn = [[UIButton alloc] initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:sImage] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+(UIButton *)CreateMyButtonWithFrame:(CGRect)frame Image:(NSString *)image SelectedImage:(NSString *)sImage title:(NSString *)title color:(UIColor *)color SelectColor:(UIColor *)selectColor font:(CGFloat)font and:(id)target Action:(SEL)action{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    
    [button setTitleColor:selectColor forState:UIControlStateSelected];
    
    [button setBackgroundImage:[UIImage imageNamed:sImage] forState:UIControlStateSelected];
    
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
    
}
@end
