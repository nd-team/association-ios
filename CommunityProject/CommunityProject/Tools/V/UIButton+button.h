//
//  UIButton+button.h
//  ISSP
//
//  Created by bjike on 16/8/9.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (button)

+ (UIButton *)CreateTitleButtonWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)color font:(CGFloat)font andTitle:(NSString *)title;

+ (UIButton *)CreateImageButtonWithFrame:(CGRect)frame  Image:(NSString *)image SelectedImage:(NSString *)sImage and:(id)target Action:(SEL)action;

+ (UIButton *)CreateMyButtonWithFrame:(CGRect)frame  Image:(NSString *)image SelectedImage:(NSString *)sImage title:(NSString *)title color:(UIColor *)color SelectColor:(UIColor *)selectColor font:(CGFloat)font and:(id)target Action:(SEL)action;
@end
