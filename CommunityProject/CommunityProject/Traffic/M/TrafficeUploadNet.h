//
//  TrafficeUploadNet.h
//  CommunityProject
//
//  Created by bjike on 2017/7/7.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^UploadTrafficBlock)(NSURLResponse * response,NSError * error,id data);

@interface TrafficeUploadNet : NSObject
+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andFirstImage:(UIImage *)image andSecondImage:(UIImage *)imageTwo  getBlock:(UploadTrafficBlock)block;

@end
