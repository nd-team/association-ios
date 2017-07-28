//
//  JavaGetNet.h
//  CommunityProject
//
//  Created by bjike on 2017/7/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JavaBlock)(NSURLResponse * response,NSError * error,id data);

@interface JavaGetNet : NSObject

+(void)getDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andHeader:(NSString *)userId getBlock:(JavaBlock)block;

@end
