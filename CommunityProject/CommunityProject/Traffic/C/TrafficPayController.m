//
//  TrafficPayController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "TrafficPayController.h"
#import "UIView+ChatMoreView.h"

#define PayURL @"appapi/app/payDealBuy"

@interface TrafficPayController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *payCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *myCountLabel;
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong)UIWindow * window;

@property (nonatomic,copy)NSString * finishCount;

@end

@implementation TrafficPayController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    self.navigationItem.title = @"确认订单";
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];

    self.contentLabel.text = self.content;
    self.payCountLabel.text = [NSString stringWithFormat:@"贡献币 %@",self.dealContribution];
    NSString * contribute = [DEFAULTS objectForKey:@"contributionScore"];
    self.myCountLabel.text = [NSString stringWithFormat:@"贡献币 %@",contribute];
    NSInteger cha = [contribute integerValue]- [self.dealContribution integerValue];
    self.finishCount = [NSString stringWithFormat:@"%ld",cha];
}
//支付
- (IBAction)payClick:(id)sender {
    //提示用户贡献币不够
    NSInteger contribute = [[DEFAULTS objectForKey:@"contributionScore"] integerValue];
    if ([self.dealContribution integerValue]>contribute) {
        [self showMessage:@"sorry，你的贡献币不够！"];
        return;
    }
    [self showBackViewUI:@"确认购买吗？"];
}
-(void)showBackViewUI:(NSString *)title{
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.backView = [UIView sureViewTitle:title andTag:162 andTarget:self andAction:@selector(buttonAction:)];
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
    if (btn.tag == 162) {
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf pay];
        });
    }
    [self hideViewAction];
}
-(void)hideViewAction{
    self.backView.hidden = YES;
}
-(void)pay{
    WeakSelf;
    NSDictionary * dict = @{@"userId":self.userId,@"articleId":self.articalId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,PayURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
        if (error) {
            NSSLog(@"发布灵感失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                weakSelf.delegate.isRef = YES;
                //修改贡献值
                [DEFAULTS setValue:self.finishCount forKey:@"contributionScore"];
                [DEFAULTS synchronize];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showMessage:@"支付失败！"];
            }
        }
    }];
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
@end
