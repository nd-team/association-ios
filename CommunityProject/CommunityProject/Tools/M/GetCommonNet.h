//
//  GetCommonNet.h
//  ISSP
//
//  Created by bjike on 16/11/18.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^getCommonBlock)(NSURLResponse * response,NSError * error,id data);

@interface GetCommonNet : NSObject
+(void)getDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params getBlock:(getCommonBlock)block;

@end
