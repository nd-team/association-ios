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

#define ZanURL @"appapi/app/userPraise"
#define CollectURL @"appapi/app/articleCollection"

@interface EducationDetailController ()
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

@end

@implementation EducationDetailController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
//发布三分钟
-(void)finishAction{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
}
-(void)setUI{
    [self.firstImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.firstUrl]]] placeholderImage:[UIImage imageNamed:@"banner3"]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    if (self.isLook) {
        self.bottomView.hidden = YES;
        self.imageHeightCons.constant = 200;
    }else{
        self.bottomView.hidden = NO;
        self.imageHeightCons.constant = 230;
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

    }
   
    self.titleLabel.text = self.topic;
    self.nameLabel.text = self.nickname;
    self.timeLabel.text = [self.time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.contentLabel.text = self.content;
}
//播放视频
- (IBAction)playClick:(id)sender {
    //进入播放界面进行播放
    
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
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}
@end
