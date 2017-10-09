//
//  AFNetData.h
//  aiJiaApp
//
//  Created by bjike on 16/6/22.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^returnBlock)(NSURLResponse * response,NSError * error,id data);

@interface AFNetData : NSObject

+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params returnBlock:(returnBlock)block;
    

@end
