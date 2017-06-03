//
//  AFNetData.m
//  aiJiaApp
//
//  Created by bjike on 16/6/22.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "AFNetData.h"


@implementation AFNetData
/**
 NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
 NSData * data = [[NSData alloc]initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
 NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 */
+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params returnBlock:(returnBlock)block{
    //
    AFHTTPSessionManager * manager = [FixMemoryLeak sharedHTTPSession];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.securityPolicy = [AFSecuteCertificate customSecurityPolicy];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSSLog(@"%@",jsonDic);

        block(task.response,nil,jsonDic);
                
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse * res = (NSHTTPURLResponse *)task.response;

        block(res,error,(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]);
        
    }];
    
}
@end
