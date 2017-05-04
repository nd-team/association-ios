//
//  ProductCodeController.m
//  CommunityProject
//
//  Created by bjike on 17/4/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ProductCodeController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

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
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"code.png"];
    
    NSFileManager * file= [NSFileManager defaultManager];
    
    [file removeItemAtPath:path error:nil];
    
    [self saveImage:self.codeImageView.image withName:@"code.png"];

}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
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
    //分享还是发送短信  二进制流
//    NSData *imageData = UIImageJPEGRepresentation(self.codeImageView.image, 0.5);
//路径
    NSArray * imageArr = @[[UIImage imageWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"code.png"]]];
    //应用路径
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.code
                                     images:imageArr
                                        url:[NSURL URLWithString:@""]
                                      title:@"注册邀请码"
                                       type:SSDKContentTypeAuto];
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    WeakSelf;
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           //移除分享图片
                           NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"code.png"];
                           
                           NSFileManager * file= [NSFileManager defaultManager];
                           
                           [file removeItemAtPath:path error:nil];

                           [weakSelf showMessage:@"分享成功"];
                                                     break;
                       }
                       case SSDKResponseStateFail:
                       {
                           [weakSelf showMessage:@"分享失败"];
                                                      break;
                       }
                       default:
                           break;
                   }
               }
     ];
}
-(void)showMessage:(NSString *)title{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
