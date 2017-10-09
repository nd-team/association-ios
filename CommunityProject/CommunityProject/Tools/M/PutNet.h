//
//  PutNet.h
//  CommunityProject
//
//  Created by bjike on 2017/7/22.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Block)(NSURLResponse * response,NSError * error,id data);

@interface PutNet : NSObject
+(void)putDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andHeader:(NSString *)userId returnBlock:(Block)block;

@end
