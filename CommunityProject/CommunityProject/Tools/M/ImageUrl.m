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
    NSRange range2 = NSMakeRange(0, baseStr.length-rangeStr.length);
    [str addAttribute:NSForegroundColorAttributeName value:color range:range2];

    return str;
}
+(NSMutableAttributedString *)changeTextColor:(NSString *)baseStr andFirstString:(NSString *)first andColor:(UIColor *)color andFont:(UIFont *)font andRangeStr:(NSString *)secondStr andChangeColor:(UIColor *)secondColor andSecondFont:(UIFont *)secondFont{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:baseStr];
    NSRange range1 = [[str string]rangeOfString:first];
    NSRange range2 = [[str string]rangeOfString:secondStr];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [str addAttribute:NSForegroundColorAttributeName value:secondColor range:range2];
    [str addAttribute:NSFontAttributeName value:font range:range1];
    [str addAttribute:NSFontAttributeName value:secondFont range:range2];

    return str;
}
+(NSMutableAttributedString *)commentTextColor:(NSString *)baseStr andFirstString:(NSString *)first andFirstColor:(UIColor *)color andFirstFont:(UIFont *)font andSecondStr:(NSString *)secondStr andSecondColor:(UIColor *)secondColor andSecondFont:(UIFont *)secondFont andThirdStr:(NSString *)thirdStr andThirdColor:(UIColor *)thirdColor andThirdFont:(UIFont *)thirdFont andFourthStr:(NSString *)fourStr andFourthColor:(UIColor *)fourColor andFourthFont:(UIFont *)fourFont{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:baseStr];
    NSRange range1 = [[str string]rangeOfString:first];
    NSRange range2 = [[str string]rangeOfString:secondStr];
    NSRange range3 = [[str string]rangeOfString:thirdStr];
    NSRange range4 = [[str string]rangeOfString:fourStr];

    [str addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [str addAttribute:NSForegroundColorAttributeName value:secondColor range:range2];
    [str addAttribute:NSFontAttributeName value:font range:range1];
    [str addAttribute:NSFontAttributeName value:secondFont range:range2];
    [str addAttribute:NSForegroundColorAttributeName value:thirdColor range:range3];
    [str addAttribute:NSFontAttributeName value:thirdFont range:range3];
    [str addAttribute:NSForegroundColorAttributeName value:fourColor range:range4];
    [str addAttribute:NSFontAttributeName value:fourFont range:range4];
    

    return str;

}
+(NSArray *)cutString:(NSString *)time{
    NSArray * arr = [time componentsSeparatedByString:@" "];
    return arr;
}
+(NSArray *)cutBigTime:(NSString *)time{
    NSArray * arr = [time componentsSeparatedByString:@"-"];
    return arr;
}
+(NSArray *)cutSmallTime:(NSString *)time{
    NSArray * arr = [time componentsSeparatedByString:@":"];
    return arr;
}
@end
