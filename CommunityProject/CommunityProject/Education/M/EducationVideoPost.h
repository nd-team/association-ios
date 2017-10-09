//
//  EducationVideoPost.h
//  CommunityProject
//
//  Created by bjike on 2017/6/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UploadVideoBlock)(NSURLResponse * response,NSError * error,id data);

@interface EducationVideoPost : NSObject

+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andImage:(UIImage *)image andVideo:(NSData *)videoData getBlock:(UploadVideoBlock)block;

@end
