//
//  ImageUrl.h
//  CommunityProject
//
//  Created by bjike on 17/3/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUrl : NSObject
+(NSString *)changeUrl:(NSString *)url;
+(NSMutableAttributedString*)changeTextColor:(NSString *)baseStr andRangeStr:(NSString *)rangeStr;
@end
