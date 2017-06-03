//
//  ScanCodeViewController.m
//  ISSP
//
//  Created by bjike on 16/12/12.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UnknownFriendDetailController.h"
#define FriendDetailURL @"appapi/app/selectUserInfo"

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    
    NSTimer * timer;
    int num;
    BOOL upOrDown;
    
}
@property (nonatomic,strong) AVCaptureDevice * device;

@property (nonatomic,strong) AVCaptureDeviceInput * input;

@property (nonatomic,strong) AVCaptureMetadataOutput * output;

@property (nonatomic,strong) AVCaptureSession * session;

@property (nonatomic,strong) AVCaptureVideoPreviewLayer * preview;
//冲击波视图
@property (nonatomic,strong)UIImageView *lineImageView;

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation ScanCodeViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.tabBarController.tabBar.hidden = YES;
    
    //session和timer做优化
    if (_session && ![_session isRunning]) {
        
        [_session startRunning];
    }

    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(startAnimater) userInfo:nil repeats:YES];
}
- (BOOL)navigationShouldPopOnBackButton
{
    [timer invalidate];
    return YES;
}
-(void)startAnimater{

    if (!upOrDown) {
        
        num++;
        [self.lineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.imageView).offset(2*num);
            
            make.centerX.equalTo(self.view);
            
            make.width.mas_equalTo(200);
            
            make.height.mas_equalTo(2);
 
            
        }];

        if (2*num >= 200) {
            
            upOrDown = YES;
        }
    }else{
        
        num--;
        [self.lineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.imageView).offset(2*num);
            
            make.centerX.equalTo(self.view);
            
            make.width.mas_equalTo(200);
            
            make.height.mas_equalTo(2);
            
            
        }];
        if (num==0) {
            
            upOrDown = NO;
        }
    }
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [timer invalidate];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    upOrDown = NO;
    num = 0;
    self.navigationItem.title = @"扫一扫";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;

    //1.初始化UI
    [self setUI];
    //2.
    [self setupCamera];
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setUI{
    
    self.imageView = [UIImageView new];
    
    self.imageView.image = [UIImage imageNamed:@"contact_scanframe.png"];
    
    [self.view addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        
        make.centerY.equalTo(self.view);
        
        make.width.height.mas_equalTo(200);
        
    }];
    
    self.lineImageView = [UIImageView new];
    
    self.lineImageView.image = [UIImage imageNamed:@"line.png"];
    
    [self.view addSubview:self.lineImageView];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imageView).offset(5);
        
        make.centerX.equalTo(self.view);
        
        make.width.mas_equalTo(200);
        
        make.height.mas_equalTo(2);
    }];
}
//初始化扫描器
-(void)setupCamera{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        // Device
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        // Output
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //设置感兴趣的区域,不设置的话会造成整个屏幕都可以扫描200/KMainScreenHeight 扫描区域高度/屏幕高度
        [_output setRectOfInterest:CGRectMake(200/KMainScreenHeight, (KMainScreenWidth-200)/2/KMainScreenWidth, 200/KMainScreenHeight, 200/KMainScreenWidth)];
        // Session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // Preview
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame = self.view.bounds;
            [self.view.layer insertSublayer:self.preview atIndex:0];
            // Start
            [_session startRunning];
        });
    });

    
}

//处理扫描的结果
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
      if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject * metaObj = metadataObjects[0];
        NSString * str = metaObj.stringValue;
        
        if (str.length > 0) {
            
//            NSLog(@"%@",str);
            if ([str containsString:@"http://"]||[str containsString:@"https://"]) {
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
            }else if ([str containsString:@"BJIKE"]){
                //获取到二维码携带的ID跳转好友详情界面添加好友
                NSString * ike = [str componentsSeparatedByString:@"-"][1];
                [self comeInUnknown:ike];
                
            }else{
                
                NSLog(@"无法识别图中二维码！");
            }
        }
    }else{
        
        return;
    }
    
}
-(void)comeInUnknown:(NSString *)friendId{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendDetailURL] andParams:@{@"userId":[DEFAULTS objectForKey:@"userId"],@"otherUserId":friendId,@"status":@"1"} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"好友详情请求失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [self.session stopRunning];
                [timer invalidate];
                NSDictionary * dict = data[@"data"];
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
                UnknownFriendDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"UnknownFriendDetailController"];
                detail.name = dict[@"nickname"];
                NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]];
                detail.url = encodeUrl;
                detail.friendId = friendId;
                if (![dict[@"age"] isKindOfClass:[NSNull class]]) {
                    detail.age = [NSString stringWithFormat:@"%@",dict[@"age"]];
                }
                if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                    detail.sex = [dict[@"sex"]intValue];
                }
                if (![dict[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                    detail.recomendPerson = [NSString stringWithFormat:@"%@",dict[@"recommendUserId"]];
                }
                if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                    detail.email = [NSString stringWithFormat:@"%@",dict[@"email"]];
                }
                if (![dict[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                    detail.lingPerson = [NSString stringWithFormat:@"%@",dict[@"claimUserId"]];
                }
                if (![dict[@"mobile"] isKindOfClass:[NSNull class]]) {
                    detail.phone = [NSString stringWithFormat:@"%@",dict[@"mobile"]];
                }
                if (![dict[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                    detail.contribute = [NSString stringWithFormat:@"%@",dict[@"contributionScore"]];
                }
                if (![dict[@"birthday"] isKindOfClass:[NSNull class]]) {
                    detail.birthday = [NSString stringWithFormat:@"%@",dict[@"birthday"]];
                }
                if (![dict[@"creditScore"] isKindOfClass:[NSNull class]]) {
                    detail.prestige = [NSString stringWithFormat:@"%@",dict[@"creditScore"]];
                }
                if (![dict[@"address"] isKindOfClass:[NSNull class]]) {
                    detail.areaStr = [NSString stringWithFormat:@"%@",dict[@"address"]];
                }
                if (![dict[@"intimacy"] isKindOfClass:[NSNull class]]) {
                    detail.intimacy = [NSString stringWithFormat:@"%@",dict[@"intimacy"]];
                }
                
                detail.isRegister = YES;
                RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:friendId name:dict[@"nickname"] portrait:encodeUrl];
                [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:friendId];
                [weakSelf.navigationController pushViewController:detail animated:YES];
            }
        }
    }];
    
}
@end
