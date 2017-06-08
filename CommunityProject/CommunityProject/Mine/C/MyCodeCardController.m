//
//  MyCodeCardController.m
//  CommunityProject
//
//  Created by bjike on 2017/5/31.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyCodeCardController.h"

@interface MyCodeCardController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@end

@implementation MyCodeCardController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的二维码";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.whiteView.layer.cornerRadius = 5;
    self.headImageView.layer.cornerRadius = 5;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userPortraitUrl]];
    self.nameLabel.text = self.nickname;
    if (self.sex == 1) {
        self.sexImage.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sexImage.image = [UIImage imageNamed:@"woman.png"];
    }
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"MyCode.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    if (savedImage != nil) {
        self.codeImage.image = savedImage;
    }else{
        [self productCode];
    }
    
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)productCode{
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //滤镜默认属性
    [filter setDefaults];
    //用户ID为图片
    NSData * data = [[NSString stringWithFormat:@"BJIKE-%@",self.userId] dataUsingEncoding:NSUTF8StringEncoding];
    //设置滤镜输入数据
    [filter setValue:data forKey:@"inputMessage"];
    //获取滤镜输出数据
    CIImage * outImage = [filter outputImage];
    //转换并生成指定大小二维码显示
    self.codeImage.image =  [self createNonInterpolatedUIImageFormCIImage:outImage withSize:208];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"MyCode.png"];
    
    NSFileManager * file= [NSFileManager defaultManager];
    
    [file removeItemAtPath:path error:nil];
    
    [self saveImage:self.codeImage.image withName:@"MyCode.png"];
    
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
@end
