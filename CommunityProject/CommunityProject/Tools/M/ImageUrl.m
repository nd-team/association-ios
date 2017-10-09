//
//  ImageUrl.m
//  CommunityProject
//
//  Created by bjike on 17/3/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ImageUrl.h"


@implementation ImageUrl
+(NSString *)changeUrl:(NSString *)url{
    NSString * str = url;
    NSString * regExp = @"[\\\\]+";
    NSString * replaceStr = @"/";
    NSRegularExpression * express = [[NSRegularExpression alloc]initWithPattern:regExp options:NSRegularExpressionCaseInsensitive error:nil];
    str =  [express stringByReplacingMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length) withTemplate:replaceStr];
    return str;
}// 
+(NSMutableAttributedString*)changeTextColor:(NSString *)baseStr andFirstRangeStr:(NSString *)rangeOneStr andFirstChangeColor:(UIColor *)oneColor andSecondRangeStr:(NSString *)rangeTwoStr andSecondColor:(UIColor *)twoColor{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:baseStr];
    NSRange range = [[str string]rangeOfString:rangeOneStr];
    [str addAttribute:NSForegroundColorAttributeName value:oneColor range:range];
    NSRange range2 = [[str string]rangeOfString:rangeTwoStr];
    [str addAttribute:NSForegroundColorAttributeName value:twoColor range:range2];
    return str;
}
+(NSMutableAttributedString *)changeTextColor:(NSString *)baseStr andFirstString:(NSString *)first andColor:(UIColor *)color andFont:(UIFont *)font andRangeStr:(NSString *)secondStr andChangeColor:(UIColor *)secondColor andSecondFont:(UIFont *)secondFont{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:baseStr];
    NSRange range1 = [[str string]rangeOfString:first];
    NSRange range2 = [[str string]rangeOfString:secondStr];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [str addAttribute:NSForegroundColorAttributeName value:secondColor range:range2];
    [str addAttribute:NSFontAttributeName value:font range:range1];
    [str addAttribute:NSFontAttributeName value:secondFont range:range2];

    return str;
}
+(NSMutableAttributedString*)messageTextColor:(NSString *)baseStr andFirstString:(NSString *)first andFirstColor:(UIColor*)color andFirstFont:(UIFont *)font andSecondStr:(NSString *)secondStr andSecondColor:(UIColor *)secondColor andSecondFont:(UIFont *)secondFont andThirdStr:(NSString *)thirdStr andThirdColor:(UIColor *)thirdColor andThirdFont:(UIFont *)thirdFont{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:baseStr];
    NSRange range1 = [[str string]rangeOfString:first];
    NSRange range2 = [[str string]rangeOfString:secondStr];
    NSRange range3 = [[str string]rangeOfString:thirdStr];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [str addAttribute:NSForegroundColorAttributeName value:secondColor range:range2];
    [str addAttribute:NSFontAttributeName value:font range:range1];
    [str addAttribute:NSFontAttributeName value:secondFont range:range2];
    [str addAttribute:NSForegroundColorAttributeName value:thirdColor range:range3];
    [str addAttribute:NSFontAttributeName value:thirdFont range:range3];
    return str;
    

}
+(NSMutableAttributedString *)commentTextColor:(NSString *)baseStr andFirstString:(NSString *)first andFirstColor:(UIColor *)color andFirstFont:(UIFont *)font andSecondStr:(NSString *)secondStr andSecondColor:(UIColor *)secondColor andSecondFont:(UIFont *)secondFont andThirdStr:(NSString *)thirdStr andThirdColor:(UIColor *)thirdColor andThirdFont:(UIFont *)thirdFont andFourthStr:(NSString *)fourStr andFourthColor:(UIColor *)fourColor andFourthFont:(UIFont *)fourFont{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:baseStr];
    NSRange range1 = [[str string]rangeOfString:first];
    NSRange range2 = [[str string]rangeOfString:secondStr];
    NSRange range3 = [[str string]rangeOfString:thirdStr];
    NSRange range4 = [[str string]rangeOfString:fourStr];

    [str addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [str addAttribute:NSForegroundColorAttributeName value:secondColor range:range2];
    [str addAttribute:NSFontAttributeName value:font range:range1];
    [str addAttribute:NSFontAttributeName value:secondFont range:range2];
    [str addAttribute:NSForegroundColorAttributeName value:thirdColor range:range3];
    [str addAttribute:NSFontAttributeName value:thirdFont range:range3];
    [str addAttribute:NSForegroundColorAttributeName value:fourColor range:range4];
    [str addAttribute:NSFontAttributeName value:fourFont range:range4];
    return str;

}
+(CAShapeLayer *)maskLayer:(CGRect)rect andleftCorner:(UIRectCorner)left andRightCorner:(UIRectCorner)right{
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:left | right cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}
+(NSArray *)cutString:(NSString *)time{
    NSArray * arr = [time componentsSeparatedByString:@" "];
    return arr;
}
+(NSArray *)cutBigTime:(NSString *)time{
    NSArray * arr = [time componentsSeparatedByString:@"-"];
    return arr;
}
+(NSArray *)cutSmallTime:(NSString *)time{
    NSArray * arr = [time componentsSeparatedByString:@":"];
    return arr;
}
//动态调节高度
+ (CGSize)boundingRectWithString:(NSString *)textStr width:(CGFloat)width height:(CGFloat)height font:(NSInteger)font{
    CGSize size;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil];
    size = [textStr boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return size;
}
//字符长度
+(int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    NSParameterAssert(asset);
    
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    
    CFTimeInterval thumbnailImageTime = time;
    
    NSError *thumbnailImageGenerationError = nil;
    
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        
       NSSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage * thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
    
}
+ (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(Result)result{
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 
                                                                 NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE]];
                                                                 result(data, fileName);
                                                             }
                                                             [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                                                         }];
    } else {
        result(nil, nil);
    }
}
-(void)compressVideo:(NSURL *)path andVideoName:(NSString *)name
     successCompress:(void(^)(NSData *compressData))successCompress  //saveState 是否保存视频到相册
{
    self.videoName = name;
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:path options:nil];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [self compressedURL];//设置压缩后视频流导出的路径
        exportSession.shouldOptimizeForNetworkUse = true;
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        //异步导出
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            NSSLog(@"%ld",(long)[exportSession status]);
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                NSSLog(@"视频压缩成功,压缩后大小 %f MB",[self fileSize:[self compressedURL]]);
//                if (saveState) {
//                    [self saveVideo:[self compressedURL]];//保存视频到相册
//                }
                //压缩成功视频流回调回去
//                successCompress([NSData dataWithContentsOfURL:[self compressedURL]].length > 0?[NSData dataWithContentsOfURL:[self compressedURL]]:nil);
                successCompress([NSData dataWithContentsOfURL:[self compressedURL]]);
            }else{
                //压缩失败的回调
                successCompress(nil);
            }
        }];
}
#pragma mark 保存压缩
- (NSURL *)compressedURL
{
    return [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",self.videoName]]];
}

#pragma mark 计算视频大小
- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}
/*
#pragma mark 保存视频到相册
- (void)saveVideo:(NSURL *)outputFileURL
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            //(@"保存视频失败:%@",error);
        } else {
            //NSLog(@"保存视频到相册成功");
        }
    }];
}
 */
+(BOOL) isEmptyStr:(NSString *) aString
{
    if (aString == nil || aString == NULL)
    {
        return YES;
    }
    if ([aString  isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([aString length]==0) {
        return YES;
    }
    if ([[aString lowercaseString] isEqualToString:@"null"] )
    {
        return YES;
    }
    
    if ([[aString lowercaseString] isEqualToString:@"<null>"] )
    {
        return YES;
    }
    
    return NO;
}
@end
