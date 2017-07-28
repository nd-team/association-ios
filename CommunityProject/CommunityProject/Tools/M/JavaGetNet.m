//
//  JavaGetNet.m
//  CommunityProject
//
//  Created by bjike on 2017/7/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "JavaGetNet.h"

@implementation JavaGetNet
+(void)getDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andHeader:(NSString *)userId getBlock:(JavaBlock)block{
    
    
    AFHTTPSessionManager * manager = [FixMemoryLeak sharedHTTPSession];
    manager.securityPolicy = [AFSecuteCertificate customSecurityPolicy];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:userId forHTTPHeaderField:@"userId"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
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
