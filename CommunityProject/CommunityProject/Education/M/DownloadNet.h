//
//  DownloadNet.h
//  CommunityProject
//
//  Created by bjike on 2017/6/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^DownloadVideoBlock)(NSURLResponse * response,NSError * error,id data);

@interface DownloadNet : NSObject
+(void)downloadDataWithUrl:(NSString *)urlStr getBlock:(DownloadVideoBlock)block;

@end
