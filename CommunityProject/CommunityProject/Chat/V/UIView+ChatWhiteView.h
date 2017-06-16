//
//  UIView+ChatWhiteView.h
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ChatWhiteView)
+(UIView *)createWhiteView:(NSString *)title andImageName:(NSString *)imgName andFont:(CGFloat)font andColor
                          :(UIColor *)color;
+(UIView *)showViewTitle:(NSString *)title;
@end
