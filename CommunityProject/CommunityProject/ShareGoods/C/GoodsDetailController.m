//
//  GoodsDetailController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/11.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GoodsDetailController.h"
#import "TrafficeUploadNet.h"
#import "GoodsListController.h"
#import "PlatformCommentController.h"

#define SendURL @"appapi/app/addShare"
#define GoodsDetailURL @"appapi/app/shareDetails"
#define ZanURL @"appapi/app/userPraise"
#define SHAREURL @"appapi/app/updateInfo"
#define CollectURL @"appapi/app/articleCollection"

@interface GoodsDetailController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@property (weak, nonatomic) IBOutlet UIImageView *soldImageView;
//出售的文字和图片
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *soldImageHeightCons;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImageHeightCons;

@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong)UIWindow * window;
@property (nonatomic,copy)NSString * userId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
//计算总高度
@property (nonatomic,assign)CGFloat allHeight;
//需要的贡献币
@property (nonatomic,copy)NSString * payCount;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIView *darkView;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *showDownBtn;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIView *downloadView;


@end

@implementation GoodsDetailController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    if (self.isLook) {
        self.navigationController.navigationBar.hidden = NO;
        self.navigationItem.title = @"预览";
        self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"发布" andLeft:15 andTarget:self Action:@selector(finishAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.backBtn.hidden = YES;
        
    }else{
        self.navigationController.navigationBar.hidden = YES;
    }
}
-(void)finishAction{
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showBackViewUI:@"确定发布内容？"];
    });
}
-(void)showBackViewUI:(NSString *)title{
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.backView = [UIView sureViewTitle:title andTag:176 andTarget:self andAction:@selector(buttonAction:)];
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
    if (btn.tag == 176) {
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf send];
        });
    }
    [self hideViewAction];
}
-(void)hideViewAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backView.hidden = YES;
    });
}
-(void)send{
    NSDictionary *dict = @{@"userId":self.userId,@"arctitle":self.titleStr,@"synopsis":self.content,@"shareContent":self.buyContent,@"status":self.status,@"isDownload":self.isDown};
    UIImage * image;
    if (self.buyImage) {
        image = self.buyImage;
    }else{
        image = nil;
    }
    WeakSelf;
    [TrafficeUploadNet postDataWithUrl:[NSString stringWithFormat:NetURL,SendURL] andParams:dict andFirstImage:self.backImage andSecondImage:image getBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"发布灵感失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //发送通知返回首页
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshGoodsList" object:@"1"];
                for (UIViewController* vc in self.navigationController.viewControllers) {
                    
                    if ([vc isKindOfClass:[GoodsListController class]]) {
                        
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                    }
                }
            }else{
                [weakSelf showMessage:@"发布灵感失败！"];
            }
        }
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [DEFAULTS objectForKey:@"userId"];
    [self setUI];
    
}
-(void)requestData{
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getDetailData];
    });
    
}
-(void)setUI{
    //下载界面数据初始化
    NSInteger  checkVIP = [DEFAULTS integerForKey:@"checkVip"];
    if (checkVIP == 1) {
        self.downloadBtn.hidden = NO;
    }else{
        self.downloadBtn.hidden = YES;
    }    
    self.darkView.hidden = YES;
    self.darkView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.whiteView.layer.cornerRadius = 5;
    self.downloadView.layer.cornerRadius = 5;
    self.downloadView.layer.borderWidth = 1;
    self.downloadView.layer.borderColor = UIColorFromRGB(0xa6a6a6).CGColor;
    self.titleNameLabel.text = self.titleStr;
    self.showDownBtn.hidden = YES;
    [self.showDownBtn setImage:[UIImage imageNamed:@"pinkLoad"] forState:UIControlStateNormal];
    //下载完成不可用
    [self.showDownBtn setImage:[UIImage imageNamed:@"loadFinish"] forState:UIControlStateDisabled];
    self.countLabel.layer.cornerRadius = 12;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.hidden = YES;
    //详情数据初始化
    self.titleLabel.text = self.titleStr;
    [self.headImageView zy_cornerRadiusRoundingRect];
    //    [self.bottomView makeInsetShadowWithRadius:5.0 Color:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.1] Directions:[NSArray arrayWithObjects:@"top", nil]];
    self.nameLabel.text = self.nickname;
    self.timeLabel.text = [self.time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.contentLabel.text = self.content;
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart.png"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateSelected];
    [self.collectBtn setImage:[UIImage imageNamed:@"collection.png"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"selCollection.png"] forState:UIControlStateSelected];
    self.loveBtn.selected = self.isLove;
    [self.shareBtn setTitle:self.shareNum forState:UIControlStateNormal];
    [self.loveBtn setTitle:self.likes forState:UIControlStateNormal];
    [self.commentBtn setTitle:self.commentNum forState:UIControlStateNormal];
    CGFloat height1 = [ImageUrl boundingRectWithString:self.titleLabel.text width:(KMainScreenWidth-20) height:MAXFLOAT font:19].height;
    
    CGFloat height2 = [ImageUrl boundingRectWithString:self.contentLabel.text width:(KMainScreenWidth-20) height:MAXFLOAT font:13].height;
    
    if (self.isLook) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.bottomView.hidden = YES;
            self.backImageHeightCons.constant = 200;
            //计算label高度变化view高度
            self.soldLabel.text = self.buyContent;
            CGFloat height3 = [ImageUrl boundingRectWithString:self.soldLabel.text width:(KMainScreenWidth-20) height:MAXFLOAT font:13].height;
            
            self.allHeight = 248+height1+height2+height3;
            //全部展示
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"default"]];
            self.backImageView.image = self.backImage;
            
            if (self.buyImage) {
                self.soldImageHeightCons.constant = 145;
                self.viewHeightCons.constant = self.allHeight+145;
                self.soldImageView.image = self.buyImage;
                
            }else{
                self.soldImageHeightCons.constant = 0;
                self.viewHeightCons.constant = self.allHeight;
            }
        });

    }else{
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.backUrl]]] placeholderImage:[UIImage imageNamed:@"banner"]];
        
        self.backImageHeightCons.constant = 230;
        self.allHeight = 312+height1+height2;
        self.bottomView.hidden = NO;
        [self requestData];
    }
    
    
}
-(void)getDetailData{
    WeakSelf;
    NSDictionary * params = @{@"userId":self.userId,@"shareId":self.idStr};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,GoodsDetailURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"干货分享详情：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            
        }else{
            NSNumber * code = data[@"code"];
            NSDictionary * dict = data[@"data"];
            if ([code intValue] == 200) {
                self.collectNum = [NSString stringWithFormat:@"%@",dict[@"collectionNumber"]];
                self.downloadNum = [NSString stringWithFormat:@"%@",dict[@"downloadNumber"]];
                self.commentNum = [NSString stringWithFormat:@"%@",dict[@"commentNumber"]];
                [self.commentBtn setTitle:self.commentNum forState:UIControlStateNormal];
                self.shareNum = [NSString stringWithFormat:@"%@",dict[@"shareNumber"]];
                [self.shareBtn setTitle:self.shareNum forState:UIControlStateNormal];
                self.likes =  [NSString stringWithFormat:@"%@",dict[@"likes"]];
                [self.loveBtn setTitle:self.likes forState:UIControlStateNormal];
                [self.downloadBtn setTitle:self.downloadNum forState:UIControlStateNormal];
                [self.collectBtn setTitle:self.collectNum forState:UIControlStateNormal];
                self.soldLabel.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGFloat height3 = [ImageUrl boundingRectWithString:self.soldLabel.text width:(KMainScreenWidth-20) height:MAXFLOAT font:13].height;
                    self.allHeight = self.allHeight+height3;
                    NSNumber * isColl = dict[@"checkCollect"];
                    if([isColl integerValue] == 1){
                        self.collectBtn.selected = YES;
                    }else{
                        self.collectBtn.selected = NO;
                    }
                    self.isLove = [dict[@"likesStatus"] boolValue];
                    if(self.isLove){
                        self.loveBtn.selected = YES;
                    }else{
                        self.loveBtn.selected = NO;
                    }
                    if ([[dict allKeys] containsObject:@"contentImages"]) {
                        if (![ImageUrl isEmptyStr:dict[@"contentImages"]]) {
                            self.soldImageHeightCons.constant = 145;
                            self.viewHeightCons.constant = self.allHeight+self.soldImageHeightCons.constant;
                            [self.soldImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"contentImages"]]]] placeholderImage:[UIImage imageNamed:@"banner3"]];
                            
                        }else{
                            self.soldImageHeightCons.constant = 0;
                            self.viewHeightCons.constant = self.allHeight;
                            
                        }
                    }else{
                        
                        self.viewHeightCons.constant = self.allHeight;
                    }
                });
            }else{
                [weakSelf showMessage:@"干货分享详情失败！"];
            }
        }
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
- (IBAction)shareClick:(id)sender {
    [self share];
}
-(void)share{
    //平台活动图片
    NSArray * imageArr = @[[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.backUrl]]];
    //平台活动的路径
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //http://192.168.0.104:90/home/share/info?id=24
    NSString * url = [NSString stringWithFormat:@"home/share/info?id=%@",self.idStr];

    [shareParams SSDKSetupShareParamsByText:self.titleLabel.text
                                     images:imageArr
                                        url:[NSURL URLWithString:[NSString stringWithFormat:NetURL,url]]
                                      title:@"干货分享"
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
                           [weakSelf download];
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
-(void)download{
    NSDictionary * params = @{@"articleId":self.idStr,@"type":@"3",@"status":@"2"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,SHAREURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        
        if (error) {
            NSSLog(@"灵感贩卖失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [weakSelf showMessage:@"分享成功"];
                
            }else{
                [weakSelf showMessage:@"分享失败"];
            }
            
        }
    }];
}

//文章点赞
- (IBAction)loveClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    NSDictionary * params = @{@"userId":self.userId,@"articleId":self.idStr,@"type":@"3",@"status":self.loveBtn.selected?@"1":@"0"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ZanURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"平台点赞失败：%@",error);
            weakSelf.loveBtn.selected = NO;
            [self showMessage:@"点赞失败"];
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                if (self.loveBtn.selected) {
                    self.likes = [NSString stringWithFormat:@"%zi",[self.likes integerValue]+1];
                }else{
                    self.likes = [NSString stringWithFormat:@"%zi",[self.likes integerValue]-1];
                }
                [weakSelf.loveBtn setTitle:self.likes forState:UIControlStateNormal];
                
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
- (IBAction)commentClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
    PlatformCommentController * comment = [sb instantiateViewControllerWithIdentifier:@"PlatformCommentController"];
    comment.idStr = self.idStr;
    comment.type = 3;
    comment.headUrl = self.headUrl;
    comment.content = self.content;
    [self.navigationController pushViewController:comment animated:YES];
    
}
//收藏
- (IBAction)collectClick:(id)sender {
    self.collectBtn.selected = !self.collectBtn.selected;
    NSDictionary * params = @{@"userId":self.userId,@"articleId":self.idStr,@"type":@"3",@"status":self.collectBtn.selected?@"1":@"0"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CollectURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"平台点赞失败：%@",error);
            weakSelf.collectBtn.selected = NO;
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                if (self.collectBtn.selected) {
                    self.collectNum = [NSString stringWithFormat:@"%zi",[self.collectNum integerValue]+1];
                }else{
                    self.collectNum = [NSString stringWithFormat:@"%zi",[self.collectNum integerValue]-1];
                }
                [weakSelf.collectBtn setTitle:self.collectNum forState:UIControlStateNormal];
            }else if ([code intValue] == 1031){
                weakSelf.collectBtn.selected = YES;
                [weakSelf showMessage:@"已收藏"];
            }else{
                weakSelf.collectBtn.selected = NO;
                [weakSelf showMessage:@"收藏失败"];
            }
        }
        
    }];

}
//下载
- (IBAction)downloadClick:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.darkView.hidden = NO;
    });
    
}
//下载文件
- (IBAction)realDownloadClick:(id)sender {
    
}
- (IBAction)closeClick:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.darkView.hidden = YES;
    });

}
//管理下载
- (IBAction)managerClick:(id)sender {
    
}

-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
    
}
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}



@end
