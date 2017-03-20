//
//  AFNetData.m
//  aiJiaApp
//
//  Created by bjike on 16/6/22.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "AFNetData.h"


@implementation AFNetData

+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params returnBlock:(returnBlock)block{
    
    
    AFHTTPSessionManager * manager = [FixMemoryLeak sharedHTTPSession];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.securityPolicy = [AFSecuteCertificate customSecurityPolicy];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    

    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        block(task.response,nil,responseObject);
                
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse * res = (NSHTTPURLResponse *)task.response;

        block(res,error,(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]);
        
    }];
    
}
@end
