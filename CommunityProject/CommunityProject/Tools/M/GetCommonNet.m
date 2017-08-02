//
//  GetCommonNet.m
//  ISSP
//
//  Created by bjike on 16/11/18.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "GetCommonNet.h"

@implementation GetCommonNet
+(void)getDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params getBlock:(getCommonBlock)block{
    
    
    AFHTTPSessionManager * manager = [FixMemoryLeak sharedHTTPSession];
    manager.securityPolicy = [AFSecuteCertificate customSecurityPolicy:@"space"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 3;
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSData * data = [[NSData alloc]initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        block(task.response,nil,data);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse * res = (NSHTTPURLResponse *)task.response;
        
        block(res,error,(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]);
        
        
    }];
    
    
}

@end
