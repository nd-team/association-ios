//
//  UploadActImageNet.h
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^UploadActBlock)(NSURLResponse * response,NSError * error,id data);

@interface UploadActImageNet : NSObject
+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andArray:(NSMutableArray *)array  getBlock:(UploadActBlock)block;

@end
