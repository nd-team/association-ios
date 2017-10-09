//
//  UIBarButtonItem+NagivationButton.m
//  ISSP
//
//  Created by bjike on 16/12/8.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "UIBarButtonItem+NagivationButton.h"

@implementation UIBarButtonItem (NagivationButton)
+ (UIBarButtonItem *)CreateTitleButtonWithFrame:(CGRect)frame titleColor:(UIColor *)color font:(CGFloat)font andTitle:(NSString *)title andLeft:(CGFloat)left  andTarget:(id)target Action:(SEL)action{
    
    UIButton * btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:font];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, left, 0, 0);
    btn.enabled = YES;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}
+ (UIBarButtonItem *)CreateImageButtonWithFrame:(CGRect)frame backImage:(NSString *)sImage and:(id)target Action:(SEL)action{
    
    UIButton * btn = [[UIButton alloc] initWithFrame:frame];
    [btn setBackgroundImage:[UIImage imageNamed:sImage] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}
+ (UIBarButtonItem *)CreateImageButtonWithFrame:(CGRect)frame andMove:(CGFloat)move image:(NSString *)sImage and:(id)target Action:(SEL)action{
    
    UIButton * btn = [[UIButton alloc] initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:sImage] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, move);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}
+(UIBarButtonItem *)CreateBackButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andTarget:(id)target Action:(SEL)action{
    UIButton * btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x10db9f) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;

}
@end
