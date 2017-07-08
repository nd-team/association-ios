
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
#import "UIView+ChatMoreView.h"

#define SendURL @"appapi/app/releaseVideo"

@interface SendEducationController ()<UITextFieldDelegate,CTAssetsPickerControllerDelegate,UITextViewDelegate,WMPlayerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong)UIWindow * window;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//视频时长
@property (nonatomic,copy)NSString * videoTime;
@property (nonatomic,strong)WMPlayer * player;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;


@end

@implementation SendEducationController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    if (self.authStr.length != 0) {
        self.isPublicLabel.text = self.authStr;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10DB9F);
    self.videoView.layer.borderWidth = 1;
    self.videoView.layer.borderColor = UIColorFromRGB(0xeceef0).CGColor;
    self.topView.layer.borderWidth = 1;
    self.topView.layer.borderColor = UIColorFromRGB(0xeceef0).CGColor;

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
    [self tapClick];
    if ([self checkLegal]) {
        [self showBackViewUI:@"确定发布内容？"];
    }
   

}
-(void)showBackViewUI:(NSString *)title{
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.backView = [UIView sureViewTitle:title andTag:146 andTarget:self andAction:@selector(buttonAction:)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewAction)];
    
    [self.backView addGestureRecognizer:tap];
    
    [self.window addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-64);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(KMainScreenWidth);
        make.height.mas_equalTo(KMainScreenHeight);
    }];
}
-(void)buttonAction:(UIButton *)btn{
    if (btn.tag == 146) {
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf send];
        });
    }
        [self hideViewAction];
}
-(void)hideViewAction{
    self.backView.hidden = YES;
}
-(void)send{
    NSString * status;
    if ([self.isPublicLabel.text isEqualToString:@"公开"]) {
        status = @"0";
    }else{
        status = @"1";
    }
    NSDictionary *dict = @{@"userId":self.userId,@"title":self.titleTF.text,@"content":self.contentTF.text,@"playTime":self.videoTime,@"status":status};
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
                weakSelf.delegate.isRef = YES;
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

-(BOOL)checkLegal{
    BOOL a = YES;
    if (self.videoData.length == 0) {
        a = NO;
        [self showMessage:@"未选中视频"];
    }
    else if (self.firstImg == nil) {
        a = NO;
        [self showMessage:@"未添加背景图片"];
    }
    else if ([ImageUrl isEmptyStr:self.titleTF.text]) {
        a = NO;
        [self showMessage:@"未填写视频标题"];
    }
    else if ([ImageUrl isEmptyStr:self.contentTF.text]) {
        a = NO;
        [self showMessage:@"未填写视频的介绍"];
    }
    return  a;
}
//预览
- (IBAction)lookClick:(id)sender {
    [self tapClick];
    if ([self checkLegal]) {
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
        education.videoTime = self.videoTime;
        NSString * status;
        if ([self.isPublicLabel.text isEqualToString:@"公开"]) {
            status = @"0";
        }else{
            status = @"1";
        }
        education.authStatus = status;
        UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController pushViewController:education animated:YES];
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.titleTF resignFirstResponder];
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
        picker.showsSelectionIndex = YES;
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
                //视频时长
                long seconds = urlAsset.duration.value / urlAsset.duration.timescale;
                //计算超过3分钟提示重新上传
                if (seconds>180) {
                    [weakSelf showMessage:@"由于您的视频超过3分钟，请截取您的视频！"];
                    return ;
                }
                NSInteger minute = seconds/60;
                int second = seconds%60;
                weakSelf.videoTime = [NSString stringWithFormat:@"%ld’%d”",(long)minute,second];
//                NSSLog(@"视频时长：%@,%ld",weakSelf.videoTime,(long)seconds);
                NSData *data = [NSData dataWithContentsOfURL:url];
                float realMB = data.length/1024.00/1024.00;
                NSSLog(@"真实视频大小%f MB",realMB);
                //获取第一帧
//                UIImage * image = [ImageUrl thumbnailImageForVideo:url atTime:1];
                //播放本地视频
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.player = [[WMPlayer alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth-20, 200)];
                    weakSelf.player.placeholderImage = weakSelf.firstImg;
                    weakSelf.player.topView.hidden = YES;
                    weakSelf.player.delegate = weakSelf;
                    [weakSelf.player setURLString:[url absoluteString]];
                    [weakSelf.videoView addSubview:weakSelf.player];
                    [weakSelf.player play];
                });

                if (realMB<40) {
                    //不压缩
                    weakSelf.videoData = data;

                }else{
                    //压缩视频
                    ImageUrl * file = [ImageUrl new];
                    [file compressVideo:url andVideoName:@"educationOfThreeing" successCompress:^(NSData *compressData) {
                        NSSLog(@"压缩视频大小%f MB",compressData.length/1024.00/1024.00);
                        float dataMB = compressData.length/1024/1024;
                        //超过40M提示
                        if (dataMB>40) {
                            [weakSelf showMessage:@"由于您的视频超出40M，请截取您的视频,否则无法上传！"];
                            return ;
                        }
                        if (dataMB == 0) {
                            NSSLog(@"压缩失败");
                            return;
                        }
                        weakSelf.videoData = compressData;
                    }];
                }
                
            }];
        }
    }

   
}
//限制只能选择一个视频
-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset{
    NSInteger max = 1;
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
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
    }
}
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
    if (self.authView.frame.origin.y+60<KMainScreenHeight) {
        self.viewHeightCons.constant = KMainScreenHeight-5;
        self.scrollView.scrollEnabled = NO;
    }else{
        self.viewHeightCons.constant = self.authView.frame.origin.y+160;
        self.scrollView.scrollEnabled = YES;

    }
}
//播放完成继续播放
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSSLog(@"wmplayerDidFinishedPlay");
    //播放完成显示小屏 显示播放按钮隐藏bottom
    [self.player play];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player pause];
}
-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player resetWMPlayer];
}
//进入系统相册
- (IBAction)pushAlbumsClick:(id)sender {
    [self tapClick];
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //dismiss系统的设置自定义
    [self dismissViewControllerAnimated:YES completion:nil];
    self.topLabel.hidden = YES;
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    self.firstImg = originalImage;
    self.imageView.image = originalImage;
}
@end
