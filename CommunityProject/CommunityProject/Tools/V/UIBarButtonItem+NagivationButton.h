//
//  UIBarButtonItem+NagivationButton.h
//  ISSP
//
//  Created by bjike on 16/12/8.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (NagivationButton)
+ (UIBarButtonItem *)CreateTitleButtonWithFrame:(CGRect)frame titleColor:(UIColor *)color font:(CGFloat)font andTitle:(NSString *)title andLeft:(CGFloat)left andTarget:(id)target Action:(SEL)action;

+ (UIBarButtonItem *)CreateImageButtonWithFrame:(CGRect)frame backImage:(NSString *)sImage and:(id)target Action:(SEL)action;

+ (UIBarButtonItem *)CreateImageButtonWithFrame:(CGRect)frame andMove:(CGFloat)move image:(NSString *)sImage and:(id)target Action:(SEL)action;
+ (UIBarButtonItem *)CreateBackButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andTarget:(id)target Action:(SEL)action;

@end
