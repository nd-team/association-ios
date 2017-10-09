//
//  UILabel+label.m
//  CommunityProject
//
//  Created by bjike on 2017/7/4.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "UILabel+label.h"

@implementation UILabel (label)
+(UILabel *)initFrame:(CGRect)frame andTitle:(NSString *)title andTextColor:(UIColor *)color andFont:(CGFloat)font{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    return label;
}
@end
