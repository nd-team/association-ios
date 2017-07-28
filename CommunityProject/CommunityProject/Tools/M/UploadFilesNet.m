//
//  UploadFilesNet.m
//  CommunityProject
//
//  Created by bjike on 2017/7/22.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "UploadFilesNet.h"
#import "ReduceImage.h"

@implementation UploadFilesNet
+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andHeader:(NSString *)userId andArray:(NSMutableArray *)array getBlock:(UploadMulBlock)block{
    
    AFHTTPSessionManager * manager = [FixMemoryLeak sharedHTTPSession];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0f;
    manager.securityPolicy = [AFSecuteCertificate customSecurityPolicy];
    [manager.requestSerializer setValue:userId forHTTPHeaderField:@"userId"];

    [manager.requestSerializer setValue:@"text/html;application/xhtml+xml;application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    NSString * boundary = [NSString stringWithFormat:@"WebKitFormBoundary%08X%08X",arc4random(),arc4random()];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=----%@",boundary] forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i = 0;
        for (UIImage * image in array) {
            NSData * imageData = [ReduceImage base64ImageThumbnaiWith:image];
            
            NSDateFormatter * formatter = [NSDateFormatter new];
            
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSString * str = [formatter stringFromDate:[NSDate date]];
            
            NSString * imageName = [NSString stringWithFormat:@"%@-%d.jpg",str,i];
            i++;
            if (imageData) {
                
                [formData appendPartWithFileData:imageData name:@"files" fileName:imageName mimeType:@"image/jpg"];
                
            }
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
