//
//  TrafficDetailController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/7.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "TrafficDetailController.h"
#import "PlatformCommentController.h"
#import "TrafficeUploadNet.h"
#import "TrafficListController.h"
#import "TrafficPayController.h"

#define ZanURL @"appapi/app/userPraise"
#define SHAREURL @"appapi/app/updateInfo"
#define TrafficURL @"appapi/app/selectDealBuy"
#define SendURL @"appapi/app/dealBuy"

@interface TrafficDetailController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *hiddenView;

@property (weak, nonatomic) IBOutlet UIImageView *soldImageView;
//出售的文字和图片
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;
@property (weak, nonatomic) IBOutlet UIView *noSoldView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *soldImageHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hiddenHeightCons;

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
@end

@implementation TrafficDetailController
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
    //购买成功刷新详情
    if (self.isRef) {
        [self requestData];
    }
}
-(void)finishAction{
    [self showBackViewUI:@"确定发布内容？"];
}
-(void)showBackViewUI:(NSString *)title{
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.backView = [UIView sureViewTitle:title andTag:160 andTarget:self andAction:@selector(buttonAction:)];
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
    if (btn.tag == 160) {
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf send];
        });
    }
    [self hideViewAction];
}
-(void)hideViewAction{
    self.backView.hidden = YES;
}
-(void)send{
    NSDictionary *dict = @{@"userId":self.userId,@"title":self.titleStr,@"content":self.content,@"dealContent":self.buyContent,@"status":self.status,@"dealContribution":self.contributeCount};
    UIImage * image;
    if (self.buyImage) {
        image = self.buyImage;
    }else{
        image = nil;
    }
    WeakSelf;
    [TrafficeUploadNet postDataWithUrl:[NSString stringWithFormat:NetURL,SendURL] andParams:dict andFirstImage:self.backImageView.image andSecondImage:image getBlock:^(NSURLResponse *response, NSError *error, id data) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (error) {
            NSSLog(@"发布灵感失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
               //发送通知返回首页
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTrafficList" object:@"1"];
                for (UIViewController* vc in self.navigationController.viewControllers) {
                    
                    if ([vc isKindOfClass:[TrafficListController class]]) {
                        
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf getDetailData];
    });

}
-(void)setUI{
    self.titleLabel.text = self.titleStr;
    [self.headImageView zy_cornerRadiusRoundingRect];
    //    [self.bottomView makeInsetShadowWithRadius:5.0 Color:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.1] Directions:[NSArray arrayWithObjects:@"top", nil]];
    self.nameLabel.text = self.nickname;
    self.timeLabel.text = [self.time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.contentLabel.text = self.content;
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart.png"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateSelected];
    self.loveBtn.selected = self.isLove;
    [self.shareBtn setTitle:self.shareNum forState:UIControlStateNormal];
    [self.loveBtn setTitle:self.likes forState:UIControlStateNormal];
    [self.commentBtn setTitle:self.commentNum forState:UIControlStateNormal];
    self.hiddenView.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.hiddenView.layer.borderWidth = 1;
    self.noSoldView.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.noSoldView.layer.borderWidth = 1;
    //设置默认
    self.hiddenView.hidden = YES;
    self.noSoldView.hidden = NO;
    CGFloat height1 = [ImageUrl boundingRectWithString:self.titleLabel.text width:(KMainScreenWidth-20) height:MAXFLOAT font:19].height;

    CGFloat height2 = [ImageUrl boundingRectWithString:self.contentLabel.text width:(KMainScreenWidth-20) height:MAXFLOAT font:13].height;
    if (self.isLook) {
        self.bottomView.hidden = YES;
        self.backImageHeightCons.constant = 168;
        self.allHeight = 248+height1+height2;
        //全部展示
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"default"]];
        self.backImageView.image = self.backImage;
        self.hiddenView.hidden = NO;
        self.noSoldView.hidden = YES;
        //计算label高度变化view高度
        self.soldLabel.text = self.buyContent;
        //余出50滑动方便
        CGFloat height = [ImageUrl boundingRectWithString:self.soldLabel.text width:(KMainScreenWidth-20) height:MAXFLOAT font:13].height;
        if (self.buyImage) {
            self.soldImageHeightCons.constant = 140;
            //隐藏view的高度
            self.hiddenHeightCons.constant = 175+height;
            self.viewHeightCons.constant = self.allHeight+self.hiddenHeightCons.constant;
            self.soldImageView.image = self.buyImage;
            
        }else{
            self.soldImageHeightCons.constant = 0;
            self.hiddenHeightCons.constant = 35+height;
            self.viewHeightCons.constant = self.allHeight+self.hiddenHeightCons.constant;
            
        }


    }else{
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.backUrl]]] placeholderImage:[UIImage imageNamed:@"banner"]];

        self.backImageHeightCons.constant = 232.5;
        self.allHeight = 312.5+height1+height2;
        self.bottomView.hidden = NO;
        [self requestData];

    }
    

}
-(void)getDetailData{
    WeakSelf;
    NSDictionary * params = @{@"userId":self.userId,@"articleId":self.idStr};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,TrafficURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (error) {
            NSSLog(@"灵感贩卖详情：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            
        }else{
            NSNumber * code = data[@"code"];
            NSDictionary * dict = data[@"data"];
            if ([code intValue] == 200) {
                self.shareNum = [NSString stringWithFormat:@"%@",dict[@"shareNumber"]];
                self.commentNum = [NSString stringWithFormat:@"%@",dict[@"commentNumber"]];
                [self.commentBtn setTitle:self.commentNum forState:UIControlStateNormal];
                [self.shareBtn setTitle:self.shareNum forState:UIControlStateNormal];
                self.likes =  [NSString stringWithFormat:@"%@",dict[@"likes"]];
                [self.loveBtn setTitle:self.likes forState:UIControlStateNormal];
                self.soldLabel.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
                CGFloat height3 = [ImageUrl boundingRectWithString:self.soldLabel.text width:(KMainScreenWidth-20) height:MAXFLOAT font:13].height;
                self.allHeight = self.allHeight+height3;
                self.isLove = [dict[@"statusLikes"] boolValue];
                if(self.isLove){
                    self.loveBtn.selected = YES;
                }else{
                    self.loveBtn.selected = NO;
                }

                self.payCount = [NSString stringWithFormat:@"%@",dict[@"dealContribution"]];
                if ([[dict allKeys] containsObject:@"dealContent"]||[[dict allKeys] containsObject:@"dealImage"]) {
                    self.hiddenView.hidden = NO;
                    self.noSoldView.hidden = YES;
                    //计算label高度变化view高度
                    self.soldLabel.text = [NSString stringWithFormat:@"%@",dict[@"dealContent"]];
                    //余出50滑动方便
                    CGFloat height = [ImageUrl boundingRectWithString:self.soldLabel.text width:(KMainScreenWidth-20) height:MAXFLOAT font:13].height;
                    if (![ImageUrl isEmptyStr:dict[@"dealImage"]]) {
                        self.soldImageHeightCons.constant = 140;
                        //隐藏view的高度
                        self.hiddenHeightCons.constant = 175+height;
                        self.viewHeightCons.constant = self.allHeight+self.hiddenHeightCons.constant;
                        [self.soldImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"dealImage"]]]] placeholderImage:[UIImage imageNamed:@"banner3"]];

                    }else{
                        self.soldImageHeightCons.constant = 0;
                        self.hiddenHeightCons.constant = 35+height;
                        self.viewHeightCons.constant = self.allHeight+self.hiddenHeightCons.constant;

                    }
                }else{
                    self.hiddenView.hidden = YES;
                    self.noSoldView.hidden = NO;
                    self.viewHeightCons.constant = self.allHeight+80;
                }
               
            }else{
                [weakSelf showMessage:@"灵感贩卖详情失败！"];
            }
        }
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//购买
- (IBAction)buyClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"TrafficeOfInsporation" bundle:nil];
    TrafficPayController * pay = [sb instantiateViewControllerWithIdentifier:@"TrafficPayController"];
    pay.headUrl = self.headUrl;
    pay.content = self.titleStr;
    pay.dealContribution = self.payCount;
    pay.articalId = self.idStr;
    pay.userId = self.userId;
    pay.delegate = self;
    [self.navigationController pushViewController:pay animated:YES];

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
    [shareParams SSDKSetupShareParamsByText:self.titleLabel.text
                                     images:imageArr
                                        url:[NSURL URLWithString:@""]
                                      title:@"灵感贩卖"
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
    NSDictionary * params = @{@"articleId":self.idStr,@"type":@"5",@"status":@"2"};
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
    NSDictionary * params = @{@"userId":self.userId,@"articleId":self.idStr,@"type":@"5",@"status":self.loveBtn.selected?@"1":@"0"};
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
    comment.type = 5;
    comment.headUrl = self.headUrl;
    comment.content = self.content;
    [self.navigationController pushViewController:comment animated:YES];

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
