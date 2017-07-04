//
//  EducationDetailController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "EducationDetailController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "PlatformCommentController.h"
#import "WMPlayer.h"
#import "EducationVideoPost.h"
#import "UIView+ChatMoreView.h"
#import "EducationListController.h"
#import "ManagerDownloadController.h"
#import "VideoDownloadListModel.h"
#import "VideoDatabaseSingleton.h"
#import "UIView+Shadow.h"
#import "SRDownloadManager.h"

#define ZanURL @"appapi/app/userPraise"
#define CollectURL @"appapi/app/articleCollection"
#define SendURL @"appapi/app/releaseVideo"
#define SHAREURL @"appapi/app/updateInfo"
#define THREEdetailurl @"appapi/app/selectVideoInfo"

@interface EducationDetailController ()<WMPlayerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//设置阴影
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *loveBtn;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightCons;
@property (nonatomic,strong)WMPlayer * player;
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong)UIWindow * window;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *downView;

@property (weak, nonatomic) IBOutlet UIView *loadWhiteView;
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *loadBtn;
@property (weak, nonatomic) IBOutlet UIView *titileView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (nonatomic,strong)NSURLSessionDownloadTask * downloadTask;

@end

@implementation EducationDetailController

-(BOOL)prefersStatusBarHidden{
    if (self.player) {
        if (self.player.isFullscreen) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
//    self.navigationController.navigationBarHidden = NO;
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];

    if (self.isLook) {
        self.navigationController.navigationBar.hidden = NO;
        self.navigationItem.title = @"预览";
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"发布" andLeft:15 andTarget:self Action:@selector(finishAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.backBtn.hidden = YES;

    }else{
        self.navigationController.navigationBar.hidden = YES;
    }
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (self.player==nil||self.player.superview==nil){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (self.player.isFullscreen) {

                [self toCell];
                
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            self.player.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            self.player.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        default:
            break;
    }
}
///把播放器wmPlayer对象放到图片上，同时更新约束
-(void)toCell{
    self.player.topView.hidden = YES;
    self.player.bottomView.hidden = YES;
    [self.player removeFromSuperview];
    WeakSelf;
    [UIView animateWithDuration:0.7f animations:^{
        self.player.transform = CGAffineTransformIdentity;
        if (self.isLook) {
            self.player.frame = CGRectMake(0, 0, KMainScreenWidth, 200);
        }else{
            self.player.frame = CGRectMake(0, 0, KMainScreenWidth, 230);
        }
        self.player.playerLayer.frame =  self.player.frame;
        [self.firstImage addSubview:self.player];
        [self.firstImage bringSubviewToFront:self.player];
        [self.player.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.player).with.offset(0);
            make.width.mas_equalTo(KMainScreenWidth);
            make.height.mas_equalTo(self.player.frame.size.height);
            
        }];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            self.player.effectView.frame = CGRectMake(KMainScreenWidth/2-155/2,KMainScreenHeight/2-155/2, 155, 155);
        }else{
            //            wmPlayer.lightView.frame = CGRectMake(kScreenWidth/2-155/2, kScreenHeight/2-155/2, 155, 155);
        }
        
        [self.player.FF_View  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointMake(KMainScreenWidth/2-180, self.player.frame.size.height/2-144));
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(120);
            
        }];
        
        [self.player.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player).with.offset(0);
            make.right.equalTo(self.player).with.offset(0);
            make.height.mas_equalTo(49);
            make.bottom.equalTo(self.player).with.offset(0);
        }];
        [self.player.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player).with.offset(0);
            make.right.equalTo(self.player).with.offset(0);
            make.height.mas_equalTo(49);
            make.top.equalTo(self.player).with.offset(0);
        }];
        [self.player.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player.topView).with.offset(45);
            make.right.equalTo(self.player.topView).with.offset(-45);
            make.center.equalTo(self.player.topView);
            make.top.equalTo(self.player.topView).with.offset(0);
        }];
        [self.player.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(self.player).with.offset(20);
        }];
        [self.player.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.player);
            make.width.equalTo(self.player);
            make.height.equalTo(@30);
        }];
    }completion:^(BOOL finished) {
        self.player.isFullscreen = NO;
        [weakSelf setNeedsStatusBarAppearanceUpdate];
        self.player.fullScreenBtn.selected = NO;
        self.player.FF_View.hidden = YES;
    }];
 
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    self.player.topView.hidden = NO;
    self.player.bottomView.hidden = NO;
    [self.player removeFromSuperview];
    self.player.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        self.player.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        self.player.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    self.player.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
    self.player.playerLayer.frame =  CGRectMake(0,0, KMainScreenHeight,KMainScreenWidth);
    
    [self.player.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KMainScreenHeight);
        make.height.mas_equalTo(KMainScreenWidth);
        make.left.equalTo(self.player).with.offset(0);
        make.top.equalTo(self.player).with.offset(0);
    }];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        self.player.effectView.frame = CGRectMake(KMainScreenHeight/2-155/2, KMainScreenWidth/2-155/2, 155, 155);
    }else{
        //        wmPlayer.lightView.frame = CGRectMake(kScreenHeight/2-155/2, kScreenWidth/2-155/2, 155, 155);
    }
    [self.player.FF_View  mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player).with.offset(KMainScreenHeight/2-120/2);
        make.top.equalTo(self.player).with.offset(KMainScreenWidth/2-60/2);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(120);
    }];
    [self.player.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(KMainScreenHeight);
        make.bottom.equalTo(self.player.contentView).with.offset(0);
    }];
    
    [self.player.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.equalTo(self.player).with.offset(0);
        make.width.mas_equalTo(KMainScreenHeight);
    }];
    
    [self.player.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player.topView).with.offset(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(50);
        make.top.equalTo(self.player).with.offset(5);
        
    }];
    
    [self.player.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player.topView).with.offset(45);
        make.right.equalTo(self.player.topView).with.offset(-45);
        make.center.equalTo(self.player.topView);
        make.top.equalTo(self.player.topView).with.offset(0);
    }];
    
    [self.player.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player).with.offset(0);
        make.top.equalTo(self.player).with.offset(KMainScreenWidth/2-30/2);
        make.height.equalTo(@30);
        make.width.mas_equalTo(KMainScreenHeight);
    }];
    
    [self.player.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player).with.offset(KMainScreenHeight/2-22/2);
        make.top.equalTo(self.player).with.offset(KMainScreenWidth/2-22/2);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    [self.view addSubview:self.player];
    [[UIApplication sharedApplication].keyWindow addSubview:self.player];
    self.player.fullScreenBtn.selected = YES;
    self.player.isFullscreen = YES;
    self.player.FF_View.hidden = YES;
}
//发布三分钟
-(void)finishAction{
    [self showBackViewUI:@"确定发布内容？"];
   
}
-(void)send{
    WeakSelf;
    NSDictionary *dict = @{@"userId":self.userId,@"title":self.topic,@"content":self.content,@"playTime":self.videoTime,@"status":self.authStatus};
    [EducationVideoPost postDataWithUrl:[NSString stringWithFormat:NetURL,SendURL] andParams:dict andImage:self.firstImg andVideo:self.videoData getBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"上传三分钟教学失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //刷新列表 通知传参
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SendEducationOfThree" object:@"1"];
                for (UIViewController* vc in self.navigationController.viewControllers) {
                    
                    if ([vc isKindOfClass:[EducationListController class]]) {
                        
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                    }
                }
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
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
}
#pragma mark-初始化UI
-(void)setUI{
    
    NSInteger  checkVIP = [DEFAULTS integerForKey:@"checkVip"];
    if (checkVIP == 1) {
        self.downloadBtn.hidden = NO;
    }else{
        self.downloadBtn.hidden = YES;
    }
    [self.headImageView zy_cornerRadiusRoundingRect];
    self.headImageView.layer.masksToBounds = YES;
    self.downView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.downView.hidden = YES;
    self.loadWhiteView.layer.cornerRadius = 5;
    self.titileView.layer.cornerRadius = 5;
    self.titileView.layer.borderWidth = 1;
    self.titileView.layer.borderColor = UIColorFromRGB(0xa6a6a6).CGColor;
    self.nameTitleLabel.text = self.topic;
    self.loadBtn.hidden = YES;
    [self.loadBtn setImage:[UIImage imageNamed:@"pinkLoad"] forState:UIControlStateNormal];
    //下载完成不可用
    [self.loadBtn setImage:[UIImage imageNamed:@"loadFinish"] forState:UIControlStateDisabled];
    
    self.loadingLabel.layer.cornerRadius = 12;
    self.loadingLabel.layer.masksToBounds = YES;
    self.loadingLabel.hidden = YES;
    
    if ([self.headUrl containsString:NetURL]) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    }else{
        if (self.isDown) {
            self.headImageView.image = [UIImage imageWithData:self.headData];
        }else{
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
        }
    }
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    if (self.isLook) {
        self.bottomView.hidden = YES;
        self.imageHeightCons.constant = 200;
        self.firstImage.image = self.firstImg;
        //播放本地视频
        [self setPlayer:self.localUrl anImage:self.firstImg];
        self.player.player.automaticallyWaitsToMinimizeStalling = false;
    }else{
        self.bottomView.hidden = NO;
        self.imageHeightCons.constant = 230;
        if (self.isDown) {
            self.firstImage.image = self.firstImg;
            //二进制流
            [self setPlayer:self.localUrl anImage:self.firstImg];
            self.player.player.automaticallyWaitsToMinimizeStalling = false;
            //请求网络数据初始化数字
            [self getDetailData];
            self.downloadBtn.hidden = YES;
        }else{
            [self.firstImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.firstUrl]]] placeholderImage:[UIImage imageNamed:@"banner3"]];
            //播放网络视频
            [self setPlayer:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.videoUrl]]] anImage:self.firstImage.image];
            self.player.player.automaticallyWaitsToMinimizeStalling = true;

        }
       
        [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart.png"] forState:UIControlStateNormal];
        [self.loveBtn setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateSelected];
        [self.collectionBtn setImage:[UIImage imageNamed:@"collection.png"] forState:UIControlStateNormal];
        [self.collectionBtn setImage:[UIImage imageNamed:@"selCollection.png"] forState:UIControlStateSelected];
        self.loveBtn.selected = self.isLove;
        self.collectionBtn.selected = self.isCollect;
        [self.shareBtn setTitle:self.shareNum forState:UIControlStateNormal];
        [self.loveBtn setTitle:self.loveNum forState:UIControlStateNormal];
        [self.commentBtn setTitle:self.commentNum forState:UIControlStateNormal];
        [self.collectionBtn setTitle:self.collNum forState:UIControlStateNormal];
        [self.downloadBtn setTitle:self.downloadNum forState:UIControlStateNormal];

        
    }
//    [self.bottomView makeInsetShadowWithRadius:5.0 Color:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.1] Directions:[NSArray arrayWithObjects:@"top", nil]];
    self.titleLabel.text = self.topic;
    self.nameLabel.text = self.nickname;
    self.timeLabel.text = [self.time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.contentLabel.text = self.content;
    CGRect rect = [self.content boundingRectWithSize:CGSizeMake(KMainScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    CGFloat height = rect.size.height+self.contentLabel.frame.origin.y;
    if (height>KMainScreenHeight) {
        self.scrollView.scrollEnabled = YES;
        self.viewHeightCons.constant = height+50;
    }else{
        self.scrollView.scrollEnabled = NO;
        self.viewHeightCons.constant = KMainScreenHeight;
    }
    [self.player pause];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postNotifi:) name:@"DownloadVideo" object:nil];
}
-(void)postNotifi:(NSNotification *)nofi{
    NSDictionary * dict = [nofi object];
    [self download:dict[@"URL"] andTitle:@"title"];

}
-(void)getDetailData{
    WeakSelf;
    NSDictionary * params = @{@"userId":self.userId,@"activesId":self.idStr};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,THREEdetailurl] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"三分钟教学详情：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            
        }else{
            NSNumber * code = data[@"code"];
            NSDictionary * dict = data[@"data"];
            if ([code intValue] == 200) {
                weakSelf.shareNum = [NSString stringWithFormat:@"%@",dict[@"shareNumber"]];
                weakSelf.loveNum = [NSString stringWithFormat:@"%@",dict[@"likes"]];
                weakSelf.commentNum = [NSString stringWithFormat:@"%@",dict[@"commentNumber"]];
                weakSelf.collNum = [NSString stringWithFormat:@"%@",dict[@"collectionNumber"]];
                weakSelf.downloadNum = [NSString stringWithFormat:@"%@",dict[@"downloadNumber"]];
            }else{
                [weakSelf showMessage:@"三分钟教学详情失败！"];
            }
        }
    }];

}
-(void)setPlayer:(NSURL *)url anImage:(UIImage *)image{
    self.player = [WMPlayer new];
    self.player.placeholderImage = image;
    self.player.titleLabel.text = self.topic;
    self.player.delegate = self;
//    NSString * str = [url absoluteString];
//    NSSLog(@"%@",str);
    [self.player setURLString:[url absoluteString]];
    [self toCell];

}
#pragma mark-play
//播放视频
- (IBAction)playClick:(id)sender {
    self.playBtn.selected = YES;
    if (self.player == nil) {
        if (self.isLook || self.isDown) {
            
            [self setPlayer:self.localUrl anImage:self.firstImg];

        }else{
            [self setPlayer:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.videoUrl]]] anImage:self.firstImage.image];
        }
    }
    [self.player play];
    //手势让playBtn显示和隐藏
    [self.playBtn.superview sendSubviewToBack:self.playBtn];
    self.player.bottomView.hidden = NO;

}
//返回
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
- (IBAction)shareClick:(id)sender {
    [self share];
}
-(void)share{
    //平台活动图片
    NSArray * imageArr = @[[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.firstUrl]]];
    //平台活动的路径
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.titleLabel.text
                                     images:imageArr
                                        url:[NSURL URLWithString:@""]
                                      title:@"三分钟教学"
                                       type:SSDKContentTypeAuto];
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetShareFlags:@[@"来自社群联盟平台"]];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    WeakSelf;
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           NSSLog(@"分享成功");
                           //发送请求
                           [weakSelf download:@"9" andMsg:@"分享计数失败！" andIsDown:@"2"];
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
//点赞
- (IBAction)loveClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    NSDictionary * params = @{@"userId":self.userId,@"articleId":self.idStr,@"type":@"9",@"status":self.loveBtn.selected?@"1":@"0"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ZanURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"平台点赞失败：%@",error);
            weakSelf.loveBtn.selected = NO;
            [self showMessage:@"服务器出错咯！"];
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                if (self.loveBtn.selected) {
                    self.loveNum = [NSString stringWithFormat:@"%ld",[self.loveNum integerValue]+1];
                }else{
                    self.loveNum = [NSString stringWithFormat:@"%ld",[self.loveNum integerValue]-1];
                }
                [weakSelf.loveBtn setTitle:self.loveNum forState:UIControlStateNormal];
                
            }else if ([code intValue] == 1029){
                weakSelf.loveBtn.selected = NO;
                [self showMessage:@"多次点赞失败"];
                
            }else{
                weakSelf.loveBtn.selected = NO;
                [self showMessage:@"点赞失败"];
            }
        }
        
    }];
 
}
//评论
- (IBAction)judgeClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
    PlatformCommentController * comment = [sb instantiateViewControllerWithIdentifier:@"PlatformCommentController"];
    comment.idStr = self.idStr;
    comment.type = 9;
    comment.headUrl = self.headUrl;
    comment.content = self.topic;
    [self.navigationController pushViewController:comment animated:YES];

}
//收藏
- (IBAction)collectionClick:(id)sender {
    self.collectionBtn.selected = !self.collectionBtn.selected;
    NSDictionary * params = @{@"userId":self.userId,@"articleId":self.idStr,@"type":@"9",@"status":self.collectionBtn.selected?@"1":@"0"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CollectURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"平台点赞失败：%@",error);
            weakSelf.collectionBtn.selected = NO;
            weakSelf.isCollect = NO;
            [self showMessage:@"服务器出错咯！"];
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                if (self.collectionBtn.selected) {
                    self.collNum = [NSString stringWithFormat:@"%ld",[self.collNum integerValue]+1];
                }else{
                    self.collNum = [NSString stringWithFormat:@"%ld",[self.collNum integerValue]-1];
                }
                [weakSelf.collectionBtn setTitle:self.collNum forState:UIControlStateNormal];
                weakSelf.isCollect = YES;
            }else if ([code intValue] == 1031){
                [self showMessage:@"已收藏"];
                weakSelf.isCollect = YES;
            }else{
                weakSelf.collectionBtn.selected = NO;
                weakSelf.isCollect = NO;

                [self showMessage:@"收藏失败"];
            }
        }
        
    }];
}
//下载
- (IBAction)downloadClick:(id)sender {
    self.downView.hidden = NO;
}
-(void)showMessage:(NSString *)msg{
    UIView * msgView = [UIView showViewTitle:msg];
    [self.view addSubview:msgView];
    [UIView animateWithDuration:1.0 animations:^{
        msgView.frame = CGRectMake(20, KMainScreenHeight-150, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
        //完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}
#pragma mark-播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    NSLog(@"didClickedCloseButton");
   //小屏显示
    [self toCell];
}
//全屏
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (fullScreenBtn.isSelected) {//全屏显示
        self.player.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toCell];
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    NSSLog(@"didSingleTaped");
    if (self.player.isFullscreen) {
        self.player.bottomView.hidden = NO;
        self.player.topView.hidden = NO;
    }else{
        self.player.bottomView.hidden = NO;

    }

}
//双击播放
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSSLog(@"didDoubleTaped");
    if (self.player.isFullscreen) {
        self.player.bottomView.hidden = NO;
        self.player.topView.hidden = NO;
    }else{
        self.player.bottomView.hidden = NO;
        
    }
    [self.player play];
}

///播放失败状态
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSSLog(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSSLog(@"wmplayerDidReadyToPlay");
}
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSSLog(@"wmplayerDidFinishedPlay");
    //播放完成显示小屏 显示播放按钮隐藏bottom
    self.player.bottomView.hidden = YES;
    [self.playBtn.superview bringSubviewToFront:self.playBtn];
    self.playBtn.selected = NO;
    [self.player resetWMPlayer];
//    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)showBackViewUI:(NSString *)title{
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.backView = [UIView sureViewTitle:title andTag:144 andTarget:self andAction:@selector(buttonAction:)];
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
    if (btn.tag == 144) {
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
//计数
-(void)download:(NSString *)type andMsg:(NSString *)msg andIsDown:(NSString *)status{
    NSDictionary * params = @{@"articleId":self.idStr,@"type":type,@"status":status};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,SHAREURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        
        if (error) {
            NSSLog(@"下载三分钟教学计数：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if ([status isEqualToString:@"1"]) {
                weakSelf.loadBtn.hidden = YES;
                weakSelf.loadingLabel.hidden = YES;
            }
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                if ([status isEqualToString:@"1"]) {
                    weakSelf.loadBtn.hidden = NO;
                    weakSelf.loadingLabel.hidden = NO;
                    //手动计数
                    self.downloadNum = [NSString stringWithFormat:@"%ld",[self.downloadNum integerValue]+1];
                    [weakSelf.downloadBtn setTitle:self.downloadNum forState:UIControlStateNormal];
                    NSString * str = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.videoUrl]];
                    NSURL *URL = [NSURL URLWithString:str];
                    [weakSelf download:URL andTitle:self.titleLabel.text];
                   
                }else{
                  //分享计数
                    self.shareNum = [NSString stringWithFormat:@"%ld",[self.shareNum integerValue]+1];
                    [weakSelf.shareBtn setTitle:self.shareNum forState:UIControlStateNormal];
                }
            }else{
                if ([status isEqualToString:@"1"]) {
                    weakSelf.loadBtn.hidden = YES;
                    weakSelf.loadingLabel.hidden = YES;
                }
                [weakSelf showMessage:msg];
            }
            
        }
    }];
}
#pragma mark-下载视频并保存到数据库
-(void)download:(NSURL *)URL andTitle:(NSString *)title{
    WeakSelf;
    [[SRDownloadManager sharedManager]downloadURL:URL destPath:nil andTitle:title state:^(SRDownloadState state) {
        //下载状态
        switch (state) {
            case SRDownloadStateWaiting:
            {
                weakSelf.loadBtn.enabled = YES;
            }
                break;
            case SRDownloadStateRunning:
            {
                weakSelf.loadBtn.enabled = YES;
            }
                break;
            case SRDownloadStateSuspended:
            {
                weakSelf.loadBtn.enabled = YES;
            }
                break;
            case SRDownloadStateCanceled:
            {
                weakSelf.loadBtn.enabled = YES;
            }
                break;
            case SRDownloadStateCompleted:
            {
                weakSelf.loadBtn.enabled = NO;
                
            }
                break;
            case SRDownloadStateFailed:
            {
                weakSelf.loadBtn.hidden = YES;
            }
                break;
        }
    } progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        //进程
//        NSSLog(@"%.2f",progress);
    } completion:^(BOOL success, NSString *filePath, NSError *error) {
        if (!success) {
            NSSLog(@"%@",error.userInfo);
            [weakSelf showMessage:@"下载失败"];
        }else{
            NSData * video = [NSData dataWithContentsOfFile:filePath];
            float realMB = video.length/1024.00/1024.00;
            NSData * headData = UIImagePNGRepresentation(weakSelf.headImageView.image);
            NSData * firstData = UIImagePNGRepresentation(weakSelf.firstImage.image);
            NSDictionary * dict = @{@"activesId":weakSelf.idStr,@"nickname":weakSelf.nickname,@"title":weakSelf.topic,@"content":weakSelf.content,@"time":weakSelf.time,@"likesStatus":weakSelf.isLove?@"1":@"0",@"checkCollect":weakSelf.isCollect?@"1":@"0",@"mbStr":[NSString stringWithFormat:@"%.2fMB",realMB],@"firstImage":firstData,@"headImage":headData,@"videoUrl":[URL absoluteString]};
            VideoDownloadListModel * model = [VideoDownloadListModel new];
            [model setValuesForKeysWithDictionary:dict];
            [[VideoDatabaseSingleton shareDatabase]insertDatabase:model];
            weakSelf.loadingLabel.hidden = YES;
            weakSelf.loadBtn.enabled = NO;
            
        }
        
    }];
}
- (IBAction)closeClick:(id)sender {
    self.downView.hidden = YES;
}
//管理下载
- (IBAction)managerClick:(id)sender {
//    [self releaseWMPlayer];
    [self.player resetWMPlayer];
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Education" bundle:nil];
    ManagerDownloadController * down = [sb instantiateViewControllerWithIdentifier:@"ManagerDownloadController"];
    down.topic = self.topic;
    [self.navigationController pushViewController:down animated:YES];
    
  
}
//显示下载图片
- (IBAction)showClick:(id)sender {
//    self.showBtn.selected = YES;
    /*1.先查数据库是否已添加到下载列表
     1>已下载提示用户到我的下载里面查看
     2>等待中或者暂停 、下载失败提示用户已添加到下载列表 然后开始自动下载
     3>
    */
    //相同视频 提示用户已经下载 用枚举状态查数据库
    NSArray * arr1 = [[VideoDatabaseSingleton shareDatabase]searchDatabaseModel:self.idStr];
    if (arr1.count != 0) {
        //查到了数据库中含有该视频
        [self showMessage:@"您已经下载过该视频，请到我的下载查看"];
        return;
    }
//    BOOL isDownload = [[SRDownloadManager sharedManager]isDownloadCompletedOfURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.videoUrl]]]];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.videoUrl]]];
    NSArray * arr = [SRDownloadManager sharedManager].allArray;
    int i = 0;
    if (arr.count != 0) {
        for (SRDownloadModel * model in arr) {
            NSSLog(@"%@===%@",url,model.URL);
            if ([model.URL isEqual:url]) {
                i++;
                if (model.status == SRDownloadStateCompleted) {
                    [self showMessage:@"您已经下载过该视频，请到我的下载查看"];
                }else if (model.status == SRDownloadStateWaiting){
                    [self showMessage:@"已加入下载列表"];
                }else if (model.status == SRDownloadStateFailed||model.status == SRDownloadStateSuspended){
                    //下载视频或者提示用户到管理下载里面重新下载
                    [[SRDownloadManager sharedManager]resumeDownloadOfURL:url];
                    [self showMessage:@"正在重新下载"];
                }else if (model.status == SRDownloadStateRunning){
                    [self showMessage:@"正在下载中"];
                }else if (model.status == SRDownloadStateCanceled){
                    [self download:@"9" andMsg:@"下载失败！" andIsDown:@"1"];
                }
                break;
            }
        }
    
    }
    if (i == 0) {
       
        [self download:@"9" andMsg:@"下载失败！"andIsDown:@"1"];
    }
   
}

//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}
-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player resetWMPlayer];
}

@end
