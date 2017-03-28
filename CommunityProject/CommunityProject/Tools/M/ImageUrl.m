//
//  ImageUrl.m
//  CommunityProject
//
//  Created by bjike on 17/3/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ImageUrl.h"

@implementation ImageUrl
+(NSString *)changeUrl:(NSString *)url{
    NSString * str = url;
    NSString * regExp = @"[\\\\]+";
    NSString * replaceStr = @"/";
    NSRegularExpression * express = [[NSRegularExpression alloc]initWithPattern:regExp options:NSRegularExpressionCaseInsensitive error:nil];
    str =  [express stringByReplacingMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length) withTemplate:replaceStr];
    return str;
}// 
+(NSMutableAttributedString*)changeTextColor:(NSString *)baseStr andColor:(UIColor*)color andRangeStr:(NSString *)rangeStr andChangeColor:(UIColor *)chCplor{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:baseStr];
    NSRange range = [[str string]rangeOfString:rangeStr];
    [str addAttribute:NSForegroundColorAttributeName value:chCplor range:range];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, baseStr.length)];

    return str;
}
@end
