//
//  DriverReceivableController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "DriverReceivableController.h"
#import "UserAndDriverCommentController.h"

#define MoneyURL @"appapi/app/driverArriveAddress"
@interface DriverReceivableController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *kilomileLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *overKilomileLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *overMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleMoneyLabel;
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong)UIWindow * window;
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@end

@implementation DriverReceivableController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联盟打车";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self setUI];
    
}

-(void)setUI{
    self.whiteView.layer.cornerRadius = 2;
    [self.headImageView zy_cornerRadiusRoundingRect];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default.png"]];
    
    self.startAddressLabel.text = self.startArea;
    self.endAddressLabel.text = self.endArea;
    NSString * allMoney = [NSString stringWithFormat:@"金额 %@ 元",self.money];
    self.allMoneyLabel.attributedText = [ImageUrl messageTextColor:allMoney andFirstString:@"金额 " andFirstColor:UIColorFromRGB(0x333333) andFirstFont:[UIFont boldSystemFontOfSize:17] andSecondStr:self.money andSecondColor:UIColorFromRGB(0xff931f) andSecondFont:[UIFont boldSystemFontOfSize:35] andThirdStr:@" 元" andThirdColor:UIColorFromRGB(0x333333) andThirdFont:[UIFont boldSystemFontOfSize:17]];
    //根据轨迹纠偏计算总运动里程
    self.kilomileLabel.text = [NSString stringWithFormat:@"里程 %@公里",self.motionKilo];
    float overKi = [self.motionKilo floatValue] - [self.kilomile floatValue];
    self.overKilomileLabel.text = [NSString stringWithFormat:@"超里程 %.1f公里",overKi];
    self.timeLabel.text = [NSString stringWithFormat:@"时长 %@分钟",self.time];
    self.singleMoneyLabel.text = self.timeCha;
    
}
- (IBAction)callPhoneClick:(id)sender {
    NSURL * urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phone]];
    [[UIApplication sharedApplication]openURL:urlStr];
}
//发起收款
- (IBAction)sendMoneyClick:(id)sender {
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showBackViewUI:@"请确认费用无误，提示乘客付款后下车"];
    });
}
-(void)showBackViewUI:(NSString *)title{
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.backView = [UIView sureViewTitle:title andTag:303 andTarget:self andAction:@selector(buttonAction:)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewAction)];
    
    [self.backView addGestureRecognizer:tap];
    
    [self.window addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(-64);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(KMainScreenWidth);
        make.height.mas_equalTo(KMainScreenHeight);
    }];
}
-(void)buttonAction:(UIButton *)btn{
    if (btn.tag == 303) {
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf postMoney];
        });
    }
    [self hideViewAction];

}
-(void)hideViewAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backView.hidden = YES;
    });
}
-(void)postMoney{
    NSMutableDictionary * params = [NSMutableDictionary new];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:self.orderId forKey:@"orderId"];
    [params setValue:self.motionKilo forKey:@"kilometre"];
    [params setValue:self.money forKey:@"money"];
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MoneyURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"发起付款失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];

        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //评价界面
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Driver" bundle:nil];
                    UserAndDriverCommentController * comment = [sb instantiateViewControllerWithIdentifier:@"UserAndDriverCommentController"];
                    comment.type = @"2";
                    comment.orderId = self.orderId;
                    [self.navigationController pushViewController:comment animated:YES];
                });

            }else{
                [weakSelf showMessage:@"发起收款失败！"];
            }
        }
    }];

}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
