//
//  NowDate.h
//  ISSP
//
//  Created by bjike on 16/10/21.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NowDate : NSObject

+(NSString *)currentDetailTime;

+(NSString *)getDetailTime:(NSDate *)date;

+(NSString *)currentTime;

+(NSString *)getTime:(NSDate *)date;

+(int)getYear;

@end
