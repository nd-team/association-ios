//
//  UploadActImageNet.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "UploadActImageNet.h"
#import "ReduceImage.h"
#import "UploadImageModel.h"


@implementation UploadActImageNet
+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params andArray:(NSMutableArray *)array getBlock:(UploadActBlock)block{
    
    AFHTTPSessionManager * manager = [FixMemoryLeak sharedHTTPSession];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0f;
    
    [manager.requestSerializer setValue:@"text/html;application/xhtml+xml;application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    manager.securityPolicy = [AFSecuteCertificate customSecurityPolicy:@"space"];

    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    NSString * boundary = [NSString stringWithFormat:@"WebKitFormBoundary%08X%08X",arc4random(),arc4random()];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=----%@",boundary] forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i = 0;
        
        for (UploadImageModel * model in array) {
            
            if (!model.isPlaceHolder) {
                
                UIImage * image = model.image;
                NSData * imageData = [ReduceImage base64ImageThumbnaiWith:image];
                
                NSDateFormatter * formatter = [NSDateFormatter new];
                
                formatter.dateFormat = @"yyyyMMddHHmmss";
                
                NSString * str = [formatter stringFromDate:[NSDate date]];
                
                NSString * imageName = [NSString stringWithFormat:@"%@-%d.jpg",str,i];
                
                if (imageData) {
                    if (i == 0) {
                        //活动海报
                        [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/jpg"];
 
                    }else{
                        [formData appendPartWithFileData:imageData name:@"files" fileName:imageName mimeType:@"image/jpg"];

                    }
                }
            }
            i++;
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
