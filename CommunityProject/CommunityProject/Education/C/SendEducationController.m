
//
//  SendEducationController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SendEducationController.h"
#import "AuthorityController.h"
#import "EducationDetailController.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import "WMPlayer.h"
#import "EducationVideoPost.h"

#define SendURL @"appapi/app/releaseVideo"

@interface SendEducationController ()<UITextFieldDelegate,CTAssetsPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (weak, nonatomic) IBOutlet UITextField *titleTF;

@property (weak, nonatomic) IBOutlet UITextView *contentTF;
@property (weak, nonatomic) IBOutlet UILabel *isPublicLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
//获取视频第一帧和视频的二进制流
@property (nonatomic,strong)UIImage * firstImg;
@property (nonatomic,strong)NSData *videoData;
@property (nonatomic,strong)NSURL * localUrl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
@property (weak, nonatomic) IBOutlet UIView *authView;

@end

@implementation SendEducationController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.authStr.length != 0) {
        self.isPublicLabel.text = self.authStr;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10DB9F);
    self.videoView.layer.borderWidth = 1;
    self.videoView.layer.borderColor = UIColorFromRGB(0xeceef0).CGColor;
    //手势回收键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    
}
-(void)tapClick{
    [self.titleTF resignFirstResponder];
    [self.contentTF resignFirstResponder];
}
//发布
- (IBAction)sendClick:(id)sender {
    [self common];
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf send];
    });
}
-(void)send{
    NSString * status;
    if ([self.isPublicLabel.text isEqualToString:@"公开"]) {
        status = @"0";
    }else{
        status = @"1";
    }
    NSDictionary *dict = @{@"userId":self.userId,@"title":self.titleTF.text,@"content":self.contentTF.text,@"status":status};
    WeakSelf;
    [EducationVideoPost postDataWithUrl:[NSString stringWithFormat:NetURL,SendURL] andParams:dict andImage:self.firstImg andVideo:self.videoData getBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
        if (error) {
            NSSLog(@"上传三分钟教学失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else if ([code intValue] == 1015){
                [weakSelf showMessage:@"上传图片有误！"];
            }else if ([code intValue] == 1038){
                [weakSelf showMessage:@"上传视频文件有误！"];
            }else{
                [weakSelf showMessage:@"上传三分钟教学失败！"];
            }
        }
    }];
 
}
-(void)common{
    [self tapClick];
    if (self.videoData.length == 0) {
        [self showMessage:@"未选中视频"];
        return;
    }
    if (self.titleTF.text.length == 0) {
        [self showMessage:@"未填写视频标题"];
        return;
    }
    if (self.contentTF.text.length == 0) {
        [self showMessage:@"未填写视频的介绍"];
        return;
    }
}
//预览
- (IBAction)lookClick:(id)sender {
    [self common];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Education" bundle:nil];
    EducationDetailController * education = [sb instantiateViewControllerWithIdentifier:@"EducationDetailController"];
    education.userId = self.userId;
    education.firstImg = self.firstImg;
    education.videoData = self.videoData;
    education.nickname = [userDefaults objectForKey:@"nickname"];
    education.headUrl = [userDefaults objectForKey:@"userPortraitUrl"];
    education.topic = self.titleTF.text;
    education.time = [NowDate currentDetailTime];
    education.content = self.contentTF.text;
    education.localUrl = self.localUrl;
    education.isLook = YES;
    NSString * status;
    if ([self.isPublicLabel.text isEqualToString:@"公开"]) {
        status = @"0";
    }else{
        status = @"1";
    }
    education.authStatus = status;
    [self.navigationController pushViewController:education animated:YES];
 
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (self.titleTF == textField) {
        [self.titleTF resignFirstResponder];
//    }
    return YES;
}

- (IBAction)authClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    AuthorityController * auth = [sb instantiateViewControllerWithIdentifier:@"AuthorityController"];
    auth.sendDelegate = self;
    auth.type = 2;
    [self.navigationController pushViewController:auth animated:YES];

}
- (IBAction)pushVideoClick:(id)sender {
    [self tapClick];
    [self pushVideo];
}
-(void)pushVideo{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        CTAssetsPickerController * picker = [[CTAssetsPickerController alloc]init];
        picker.delegate = self;
        picker.showsSelectionIndex = NO;
        picker.doneButtonTitle = @"确定";
        picker.showsEmptyAlbums = NO;
        
        // create options for fetching photo only 视频
        PHFetchOptions *fetchOptions = [PHFetchOptions new];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeVideo];
        
        // assign options
        picker.assetsFetchOptions = fetchOptions;
        [self presentViewController:picker animated:YES completion:nil];
    }];
}
#pragma mark-选择视频的代理回调
//选择完成
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSSLog(@"%ld %@",assets.count,assets);
    WeakSelf;
    for (PHAsset * asset in assets) {
       
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            PHImageManager *manager = [PHImageManager defaultManager];
            [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                
                NSURL *url = urlAsset.URL;
                weakSelf.localUrl = url;
                
                NSData *data = [NSData dataWithContentsOfURL:url];
                NSSLog(@"真实视频大小%lu MB",data.length/1024/1024);
                //获取第一帧
                UIImage * image = [ImageUrl thumbnailImageForVideo:url atTime:0];
                weakSelf.firstImg = image;
                //压缩视频
                ImageUrl * file = [ImageUrl new];
                [file compressVideo:url andVideoName:@"educationOfThree" successCompress:^(NSData *compressData) {
                    NSSLog(@"压缩视频大小%lu MB",compressData.length/1024/1024);
                    weakSelf.videoData = compressData;
                }];
            }];
        }
    }
    //播放本地视频
    WMPlayer * player = [[WMPlayer alloc]initWithFrame:weakSelf.videoView.frame];
    player.placeholderImage = self.firstImg;
    player.titleLabel.text = self.titleTF.text;
    [player setURLString:[self.localUrl absoluteString]];
    [weakSelf.view addSubview:player];
    [player play];

}
//限制只能选择一个视频
-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset{
    NSInteger max = 2;
    if (picker.selectedAssets.count >= max) {
        [self showMessage:@"最多选择一个视频哦！"];
    }
    return picker.selectedAssets.count < max;
    
}
-(void)showMessage:(NSString *)msg{
    UIView * msgView = [UIView showViewTitle:msg];
    [self.view addSubview:msgView];
    [UIView animateWithDuration:1.0 animations:^{
        msgView.frame = CGRectMake(20, KMainScreenHeight-150, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
        //完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
    if (self.authView.frame.origin.y+60<KMainScreenHeight) {
        self.viewHeightCons.constant = KMainScreenHeight-5;
    }else{
        self.viewHeightCons.constant = self.authView.frame.origin.y+160;
    }
}
@end
