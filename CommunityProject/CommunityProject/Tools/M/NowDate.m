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
+(NSString *)getCurrentDetailTime{
    NSDateFormatter * df = [NSDateFormatter new];
    
    [df setDateFormat:@"HH:mm:ss"];
    
    NSString * dateStr = [df stringFromDate:[NSDate date]];
    
    return dateStr;
}
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD =[date dateFromString:startTime];
    
    NSDate *endD = [date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    
    int second = (int)value %60;//秒
    
    int minute = (int)value /60%60;
    
    int house = (int)value / (24 * 3600)%3600;
    
    int day = (int)value / (24 * 3600);
    
    NSString *str;
    
    if (day != 0) {
        
        str = [NSString stringWithFormat:@"%d天%d小时%d分%d秒",day,house,minute,second];
        
    }else if (day==0 && house != 0) {
        
        str = [NSString stringWithFormat:@"%d小时%d分%d秒",house,minute,second];
        
    }else if (day== 0 && house== 0 && minute!=0) {
        
        str = [NSString stringWithFormat:@"%d分%d秒",minute,second];
        
    }else{
        
        str = [NSString stringWithFormat:@"%d秒",second];
        
    }
    
    return str;
    
}
@end
