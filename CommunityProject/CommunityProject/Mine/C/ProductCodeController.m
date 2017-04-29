//
//  ProductCodeController.m
//  CommunityProject
//
//  Created by bjike on 17/4/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ProductCodeController.h"

@interface ProductCodeController ()
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end

@implementation ProductCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要推荐";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"取消" andLeft:-15 andTarget:self Action:@selector(cancle)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"分享" andLeft:15 andTarget:self Action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.codeLabel.text = [NSString stringWithFormat:@"邀请码：%@",self.code];
    //二维码生成
    [self productCode];
}
-(void)productCode{
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //滤镜默认属性
    [filter setDefaults];
    //转换邀请码为图片
    NSData * data = [self.code dataUsingEncoding:NSUTF8StringEncoding];
    //设置滤镜输入数据
    [filter setValue:data forKey:@"inputMessage"];
    //获取滤镜输出数据
    CIImage * outImage = [filter outputImage];
    //转换并生成指定大小二维码显示
    self.codeImageView.image =  [self createNonInterpolatedUIImageFormCIImage:outImage withSize:111];
    
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
-(void)cancle{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)share{
    //分享还是发送短信
    
}
@end
