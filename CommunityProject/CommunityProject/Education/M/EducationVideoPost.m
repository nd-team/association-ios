//
//  EducationVideoPost.m
//  CommunityProject
//
//  Created by bjike on 2017/6/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "EducationVideoPost.h"
#import "ReduceImage.h"

@implementation EducationVideoPost
+(void)postDataWithUrl:(NSString *)urlStr andParams:(NSDictionary *)params  andImage:(UIImage *)image andVideo:(NSData *)videoData getBlock:(UploadVideoBlock)block{
    
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
//        NSSLog(@"图片大小：%f MB 视频大小：%f MB",imageData.length/1024.00/1024.00,videoData.length/1024.00/1024.00);
        NSDateFormatter * formatter = [NSDateFormatter new];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString * str = [formatter stringFromDate:[NSDate date]];
        
        NSString * imageName = [NSString stringWithFormat:@"%@.jpg",str];
        
        if (imageData.length != 0) {
            //图片
            [formData appendPartWithFileData:imageData name:@"fileImage" fileName:imageName mimeType:@"image/jpg"];
            
        }//视频
        if (videoData.length != 0) {
            [formData appendPartWithFileData:videoData name:@"fileVideo" fileName:@"educationOfThree.mp4" mimeType:@"video/quicktime"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSSLog(@"%@",jsonDic);
        block(task.response,nil,jsonDic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        block((NSHTTPURLResponse *)task.response,error,(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]);
        
    }];
    
    
}

@end
