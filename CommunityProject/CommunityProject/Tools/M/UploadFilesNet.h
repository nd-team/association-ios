//
//  UploadFilesNet.h
//  CommunityProject
//
//  Created by bjike on 2017/7/22.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^UploadMulBlock)(NSURLResponse * response,NSError * error,id data);

@interface UploadFilesNet : NSObject
+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andHeader:(NSString *)userId andArray:(NSMutableArray *)array  getBlock:(UploadMulBlock)block;

@end
