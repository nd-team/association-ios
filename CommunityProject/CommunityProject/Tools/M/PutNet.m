//
//  PutNet.m
//  CommunityProject
//
//  Created by bjike on 2017/7/22.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PutNet.h"

@implementation PutNet
+(void)putDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andHeader:(NSString *)userId returnBlock:(Block)block{
    AFHTTPSessionManager * manager = [FixMemoryLeak sharedHTTPSession];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:userId forHTTPHeaderField:@"userId"];
    //
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json",@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    manager.securityPolicy = [AFSecuteCertificate customSecurityPolicy];
    
    
    [manager PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSData * data = [[NSData alloc]initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        block(task.response,nil,data);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse * res = (NSHTTPURLResponse *)task.response;
        
        block(res,error,(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]);
    }];
    
    
}
@end
