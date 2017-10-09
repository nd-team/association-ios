//
//  UploadImageNet.m
//  ISSP
//
//  Created by bjike on 16/8/27.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "UploadImageNet.h"
#import "ReduceImage.h"

@implementation UploadImageNet
//    manager.securityPolicy = [AFSecuteCertificate customSecurityPolicy];

+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params  andImage:(UIImage *)image getBlock:(UploadBlock)block{
    
    AFHTTPSessionManager * manager = [FixMemoryLeak sharedHTTPSession];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 5.0f;

    [manager.requestSerializer setValue:@"text/html;application/xhtml+xml;application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.securityPolicy = [AFSecuteCertificate customSecurityPolicy:@"space"];

    
    NSString * boundary = [NSString stringWithFormat:@"WebKitFormBoundary%08X%08X",arc4random(),arc4random()];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=----%@",boundary] forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];

    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //压缩图片
        NSData * imageData = [ReduceImage base64ImageThumbnaiWith:image];
        //图片大小
//        NSLog(@"%ld",(unsigned long)imageData.length);
        NSDateFormatter * formatter = [NSDateFormatter new];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString * str = [formatter stringFromDate:[NSDate date]];
        
        NSString * imageName = [NSString stringWithFormat:@"%@.jpg",str];
        
        if (imageData) {
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/jpg"];
            
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
