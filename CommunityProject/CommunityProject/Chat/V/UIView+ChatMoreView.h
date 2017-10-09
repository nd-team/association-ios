//
//  UIView+ChatMoreView.h
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ChatMoreView)
+(UIView *)createViewFrame:(CGRect)frame andTarget:(id)target andSel:(SEL)action;
+(UIView *)locationViewFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)action;
+(UIView *)sureViewTitle:(NSString *)title andTag:(CGFloat)tag andTarget:(id)target andAction:(SEL)action;
+(UIView *)claimMessageViewFrame:(CGRect)frame andArray:(NSArray *)titleArr andTarget:(id)target andSel:(SEL)action andTag:(NSInteger)tag;
+(UIView *)showMessageTitle:(NSString *)title andTarget:(id)target andSel:(SEL)action;

@end
