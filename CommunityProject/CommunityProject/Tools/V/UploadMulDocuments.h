//
//  UploadMulDocuments.h
//  ISSP
//
//  Created by bjike on 16/12/8.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UploadMulBlock)(NSURLResponse * response,NSError * error,id data);

@interface UploadMulDocuments : NSObject
+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andArray:(NSMutableArray *)array  getBlock:(UploadMulBlock)block;

@end
