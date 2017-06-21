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
//#import "DetailViewController.h"

#define ZanURL @"appapi/app/userPraise"
#define CollectURL @"appapi/app/articleCollection"
#define SendURL @"appapi/app/releaseVideo"

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
    self.navigationController.navigationBarHidden = NO;
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];

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
        [self setNeedsStatusBarAppearanceUpdate];
        self.player.fullScreenBtn.selected = NO;
        self.player.FF_View.hidden = YES;
    }];
    NSSLog(@"%f=%f=%f=%f",self.firstImage.frame.size.width,self.player.frame.size.width,KMainScreenWidth,self.player.contentView.frame.size.width);
 
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
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(KMainScreenHeight);
        make.bottom.equalTo(self.player.contentView).with.offset(0);
    }];
    
    [self.player.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
        make.left.equalTo(self.player).with.offset(0);
        make.width.mas_equalTo(KMainScreenHeight);
    }];
    
    [self.player.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player.topView).with.offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.player).with.offset(20);
        
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
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf send];
    });
   
}
-(void)send{
    WeakSelf;
    NSDictionary *dict = @{@"userId":self.userId,@"title":self.topic,@"content":self.content,@"status":self.authStatus};
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
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
}
-(void)setUI{
    self.headImageView.layer.cornerRadius = 15;
    self.headImageView.layer.masksToBounds = YES;
    if ([self.headUrl containsString:NetURL]) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    }else{
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    }
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    if (self.isLook) {
        self.bottomView.hidden = YES;
        self.imageHeightCons.constant = 200;
        self.firstImage.image = self.firstImg;
        //播放本地视频
        [self setPlayer:self.localUrl anImage:self.firstImg];

    }else{
        self.bottomView.hidden = NO;
        self.imageHeightCons.constant = 230;
        [self.firstImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.firstUrl]]] placeholderImage:[UIImage imageNamed:@"banner3"]];
        [self.shareBtn setTitle:self.shareNum forState:UIControlStateNormal];
        [self.loveBtn setTitle:self.loveNum forState:UIControlStateNormal];
        [self.commentBtn setTitle:self.commentNum forState:UIControlStateNormal];
        [self.collectionBtn setTitle:self.collNum forState:UIControlStateNormal];
        [self.downloadBtn setTitle:self.downloadNum forState:UIControlStateNormal];
        [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart.png"] forState:UIControlStateNormal];
        [self.loveBtn setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateSelected];
        [self.collectionBtn setImage:[UIImage imageNamed:@"collection.png"] forState:UIControlStateNormal];
        [self.collectionBtn setImage:[UIImage imageNamed:@"selCollection.png"] forState:UIControlStateSelected];
        self.loveBtn.selected = self.isLove;
        self.collectionBtn.selected = self.isCollect;
        //播放网络视频
        [self setPlayer:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.videoUrl]]] anImage:self.firstImage.image];
        
    }
   
    self.titleLabel.text = self.topic;
    self.nameLabel.text = self.nickname;
    self.timeLabel.text = [self.time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.contentLabel.text = self.content;
}
-(void)setPlayer:(NSURL *)url anImage:(UIImage *)image{
    self.player = [WMPlayer new];
    self.player.placeholderImage = image;
    self.player.titleLabel.text = self.topic;
    [self.player setURLString:[url absoluteString]];
    [self toCell];
    [self.playBtn.superview bringSubviewToFront:self.playBtn];

}
//播放视频
- (IBAction)playClick:(id)sender {
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected) {
        [self.player player];
        //手势让playBtn显示和隐藏
        [self.playBtn.superview sendSubviewToBack:self.playBtn];
        self.player.bottomView.hidden = NO;
    }else{
        [self.player pause];
    }
    
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
            weakSelf.loveBtn.selected = NO;
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
                
            }else if ([code intValue] == 1031){
                [self showMessage:@"已收藏"];
                
            }else{
                weakSelf.loveBtn.selected = NO;
                [self showMessage:@"收藏失败"];
            }
        }
        
    }];
}
//下载
- (IBAction)downloadClick:(id)sender {
    
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
///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    NSLog(@"didClickedCloseButton");
    //播放按钮显示
    [self.playBtn.superview bringSubviewToFront:self.playBtn];

    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
    
}
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
    NSLog(@"didSingleTaped");
}
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}

///播放状态
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidReadyToPlay");
}
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerDidFinishedPlay");
    //播放按钮显示
    [self.playBtn.superview bringSubviewToFront:self.playBtn];
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}
/**
 *  释放WMPlayer
 */
-(void)releaseWMPlayer{
    //堵塞主线程
    //    [wmPlayer.player.currentItem cancelPendingSeeks];
    //    [wmPlayer.player.currentItem.asset cancelLoading];
    [self.player pause];
    
    
    [self.player removeFromSuperview];
    [self.player.playerLayer removeFromSuperlayer];
    [self.player.player replaceCurrentItemWithPlayerItem:nil];
    self.player.player = nil;
    self.player.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [self.player.autoDismissTimer invalidate];
    self.player.autoDismissTimer = nil;
    
    
    self.player.playOrPauseBtn = nil;
    self.player.playerLayer = nil;
    self.player = nil;
}
-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self releaseWMPlayer];
}
@end
