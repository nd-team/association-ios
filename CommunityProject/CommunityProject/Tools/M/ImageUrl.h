//
//  ImageUrl.h
//  CommunityProject
//
//  Created by bjike on 17/3/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import <Photos/Photos.h>
//#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^Result)(NSData * data,NSString * filename);
@interface ImageUrl : NSObject
//过滤反斜杠
+(NSString *)changeUrl:(NSString *)url;
+(NSMutableAttributedString*)changeTextColor:(NSString *)baseStr andFirstRangeStr:(NSString *)rangeOneStr andFirstChangeColor:(UIColor *)oneColor andSecondRangeStr:(NSString *)rangeTwoStr andSecondColor:(UIColor*)twoColor;
//两个
+(NSMutableAttributedString*)changeTextColor:(NSString *)baseStr andFirstString:(NSString *)first andColor:(UIColor*)color andFont:(UIFont *)font andRangeStr:(NSString *)secondStr andChangeColor:(UIColor *)secondColor andSecondFont:(UIFont *)secondFont;
//三个
+(NSMutableAttributedString*)messageTextColor:(NSString *)baseStr andFirstString:(NSString *)first andFirstColor:(UIColor*)color andFirstFont:(UIFont *)font andSecondStr:(NSString *)secondStr andSecondColor:(UIColor *)secondColor andSecondFont:(UIFont *)secondFont andThirdStr:(NSString *)thirdStr andThirdColor:(UIColor *)thirdColor andThirdFont:(UIFont *)thirdFont;
//四个
+(NSMutableAttributedString*)commentTextColor:(NSString *)baseStr andFirstString:(NSString *)first andFirstColor:(UIColor*)color andFirstFont:(UIFont *)font andSecondStr:(NSString *)secondStr andSecondColor:(UIColor *)secondColor andSecondFont:(UIFont *)secondFont andThirdStr:(NSString *)thirdStr andThirdColor:(UIColor *)thirdColor andThirdFont:(UIFont *)thirdFont andFourthStr:(NSString *)fourStr andFourthColor:(UIColor *)fourColor andFourthFont:(UIFont *)fourFont;
//左右圆角
+(CAShapeLayer *)maskLayer:(CGRect)rect andleftCorner:(UIRectCorner)left andRightCorner:(UIRectCorner)right;

+ (CGSize)boundingRectWithString:(NSString *)textStr width:(CGFloat)width height:(CGFloat)height font:(NSInteger)font;
+(int)convertToInt:(NSString*)strtemp;
//剪切年月日和时分秒
+(NSArray *)cutString:(NSString *)time;
//剪切年月日
+(NSArray *)cutBigTime:(NSString *)time;
//剪切时分秒
+(NSArray *)cutSmallTime:(NSString *)time;
//获取视频任一帧
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
//视频名字
@property (nonatomic,strong) NSString *videoName;
//获取视频
+ (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(Result)result;
//压缩视频
-(void)compressVideo:(NSURL *)path andVideoName:(NSString *)name
     successCompress:(void(^)(NSData *compressData))successCompress;
@end
