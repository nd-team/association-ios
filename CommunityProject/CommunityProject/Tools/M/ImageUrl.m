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
+(NSMutableAttributedString*)changeTextColor:(NSString *)baseStr andFirstRangeStr:(NSString *)rangeOneStr andFirstChangeColor:(UIColor *)oneColor andSecondRangeStr:(NSString *)rangeTwoStr andSecondColor:(UIColor *)twoColor{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:baseStr];
    NSRange range = [[str string]rangeOfString:rangeOneStr];
    [str addAttribute:NSForegroundColorAttributeName value:oneColor range:range];
    NSRange range2 = [[str string]rangeOfString:rangeTwoStr];
    [str addAttribute:NSForegroundColorAttributeName value:twoColor range:range2];
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
+(NSMutableAttributedString*)messageTextColor:(NSString *)baseStr andFirstString:(NSString *)first andFirstColor:(UIColor*)color andFirstFont:(UIFont *)font andSecondStr:(NSString *)secondStr andSecondColor:(UIColor *)secondColor andSecondFont:(UIFont *)secondFont andThirdStr:(NSString *)thirdStr andThirdColor:(UIColor *)thirdColor andThirdFont:(UIFont *)thirdFont{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:baseStr];
    NSRange range1 = [[str string]rangeOfString:first];
    NSRange range2 = [[str string]rangeOfString:secondStr];
    NSRange range3 = [[str string]rangeOfString:thirdStr];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [str addAttribute:NSForegroundColorAttributeName value:secondColor range:range2];
    [str addAttribute:NSFontAttributeName value:font range:range1];
    [str addAttribute:NSFontAttributeName value:secondFont range:range2];
    [str addAttribute:NSForegroundColorAttributeName value:thirdColor range:range3];
    [str addAttribute:NSFontAttributeName value:thirdFont range:range3];
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
+(CAShapeLayer *)maskLayer:(CGRect)rect andleftCorner:(UIRectCorner)left andRightCorner:(UIRectCorner)right{
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:left | right cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
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
//动态调节高度
+ (CGSize)boundingRectWithString:(NSString *)textStr width:(CGFloat)width height:(CGFloat)height font:(NSInteger)font{
    CGSize size;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil];
    size = [textStr boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return size;
}
//字符长度
+(int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}
@end
