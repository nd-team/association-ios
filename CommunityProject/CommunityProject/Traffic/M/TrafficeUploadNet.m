//
//  TrafficeUploadNet.m
//  CommunityProject
//
//  Created by bjike on 2017/7/7.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "TrafficeUploadNet.h"
#import "ReduceImage.h"

@implementation TrafficeUploadNet
+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andFirstImage:(UIImage *)image andSecondImage:(UIImage *)imageTwo  getBlock:(UploadTrafficBlock)block{

    AFHTTPSessionManager * manager = [FixMemoryLeak sharedHTTPSession];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    [manager.requestSerializer setValue:@"text/html;application/xhtml+xml;application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    manager.securityPolicy = [AFSecuteCertificate customSecurityPolicy:@"space"];
    
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    NSString * boundary = [NSString stringWithFormat:@"WebKitFormBoundary%08X%08X",arc4random(),arc4random()];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=----%@",boundary] forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData * imageData1 = [ReduceImage base64ImageThumbnaiWith:image];
        
        NSData * imageData2 = [ReduceImage base64ImageThumbnaiWith:imageTwo];
        
        NSDateFormatter * formatter = [NSDateFormatter new];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString * str = [formatter stringFromDate:[NSDate date]];
        
        NSString * imageName1 = [NSString stringWithFormat:@"%@-灵感背景.jpg",str];
        NSString * imageName2 = [NSString stringWithFormat:@"%@-贩卖图片.jpg",str];
        
        if (imageData1) {
            //活动海报
            [formData appendPartWithFileData:imageData1 name:@"file" fileName:imageName1 mimeType:@"image/jpg"];
            
            [formData appendPartWithFileData:imageData2 name:@"files" fileName:imageName2 mimeType:@"image/jpg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(task.response,nil,jsonDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        block((NSHTTPURLResponse *)task.response,error,(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]);
        
    }];
    
    
}
@end
