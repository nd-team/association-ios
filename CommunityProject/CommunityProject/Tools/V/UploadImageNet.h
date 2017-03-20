//
//  UploadImageNet.h
//  ISSP
//
//  Created by bjike on 16/8/27.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UploadBlock)(NSURLResponse * response,NSError * error,id data);

@interface UploadImageNet : NSObject

+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andImage:(UIImage *)image getBlock:(UploadBlock)block;
@end
