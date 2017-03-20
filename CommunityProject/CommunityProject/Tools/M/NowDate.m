//
//  NowDate.m
//  ISSP
//
//  Created by bjike on 16/10/21.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "NowDate.h"

@implementation NowDate
+(NSString *)currentTime{
    
    NSDateFormatter * df = [NSDateFormatter new];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString * dateStr = [df stringFromDate:[NSDate date]];
    
    return dateStr;
}
+(NSString *)getTime:(NSDate *)date{
    
    NSDateFormatter * df = [NSDateFormatter new];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString * dateStr = [df stringFromDate:date];
    
    return dateStr;
}
+(NSString *)currentDetailTime{
    
    NSDateFormatter * df = [NSDateFormatter new];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * dateStr = [df stringFromDate:[NSDate date]];
    
    return dateStr;
}
+(NSString *)getDetailTime:(NSDate *)date{
    
    NSDateFormatter * df = [NSDateFormatter new];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * dateStr = [df stringFromDate:date];
    
    return dateStr;
}
+(int)getYear{
    
    NSDateFormatter * df = [NSDateFormatter new];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString * dateStr = [df stringFromDate:[NSDate date]];
    
    NSArray * arr = [dateStr componentsSeparatedByString:@"-"];
    
    return [arr[0] intValue];
    
}
@end
