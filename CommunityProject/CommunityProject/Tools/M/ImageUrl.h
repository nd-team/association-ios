//
//  ImageUrl.h
//  CommunityProject
//
//  Created by bjike on 17/3/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUrl : NSObject
//过滤反斜杠
+(NSString *)changeUrl:(NSString *)url;
+(NSMutableAttributedString*)changeTextColor:(NSString *)baseStr andColor:(UIColor*)color andRangeStr:(NSString *)rangeStr andChangeColor:(UIColor *)chCplor;
//剪切年月日和时分秒
+(NSArray *)cutString:(NSString *)time;
//剪切年月日
+(NSArray *)cutBigTime:(NSString *)time;
//剪切时分秒
+(NSArray *)cutSmallTime:(NSString *)time;
@end
