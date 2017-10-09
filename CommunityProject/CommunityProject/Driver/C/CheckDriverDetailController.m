//
//  CheckDriverDetailController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/9.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CheckDriverDetailController.h"

#define StatusURL @"appapi/app/selectDriverRegister"

@interface CheckDriverDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UILabel *submitTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkingLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkingDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkedLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkedDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkedTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@end

@implementation CheckDriverDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"审核详情";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;

    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getDriverCheckStatus];
    });

}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getDriverCheckStatus{
    WeakSelf;
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,StatusURL] andParams:@{@"userId":userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
        if (error) {
            NSSLog(@"查看司机申请状态失败：%@",error);
            [weakSelf showMessage:@"服务器连接失败咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * jsonDic = data[@"data"];
                NSNumber * status = jsonDic[@"status"];
                if ([status intValue] == 0) {
                    //审核中
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.submitTimeLabel.text = jsonDic[@"time"];
                        self.checkingTimeLabel.text = jsonDic[@"time"];
                        self.checkingLabel.textColor = UIColorFromRGB(0x10db9f);
                        self.checkingDetailLabel.textColor = UIColorFromRGB(0x666666);
                        self.checkingTimeLabel.textColor = UIColorFromRGB(0x666666);
                        self.checkedLabel.textColor = UIColorFromRGB(0xc0c0c0);
                        self.secondView.backgroundColor = UIColorFromRGB(0x10db9f);
                        self.secondImage.image = [UIImage imageNamed:@"checking"];
                    });

                }else if ([status intValue] == 0){
                    //审核通过
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.submitTimeLabel.text = jsonDic[@"time"];
                        self.checkingTimeLabel.text = jsonDic[@"time"];
                        self.checkingLabel.textColor = UIColorFromRGB(0x10db9f);
                        self.checkingDetailLabel.textColor = UIColorFromRGB(0x666666);
                        self.checkingTimeLabel.textColor = UIColorFromRGB(0x666666);
                        self.checkedLabel.textColor = UIColorFromRGB(0x10db9f);
                        self.checkedDetailLabel.textColor = UIColorFromRGB(0x666666);
                        self.checkedTimeLabel.textColor = UIColorFromRGB(0x666666);
                        self.checkedTimeLabel.text = jsonDic[@"endTime"];
                        self.checkedDetailLabel.text = @"审核成功，恭喜您成为我们司机的一员！";
                        self.secondView.backgroundColor = UIColorFromRGB(0x10db9f);
                        self.secondImage.image = [UIImage imageNamed:@"checking"];
                        self.thirdImage.image = [UIImage imageNamed:@"checking"];

                    });
                }else{
                    //审核不通过
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.submitTimeLabel.text = jsonDic[@"time"];
                        self.checkingTimeLabel.text = jsonDic[@"time"];
                        self.checkingLabel.textColor = UIColorFromRGB(0x10db9f);
                        self.checkingDetailLabel.textColor = UIColorFromRGB(0x666666);
                        self.checkingTimeLabel.textColor = UIColorFromRGB(0x666666);
                        self.checkedLabel.textColor = UIColorFromRGB(0x10db9f);
                        self.checkedDetailLabel.textColor = UIColorFromRGB(0x666666);
                        self.checkedTimeLabel.textColor = UIColorFromRGB(0x666666);
                        self.checkedTimeLabel.text = jsonDic[@"endTime"];
                        self.checkedDetailLabel.text = @"审核不通过，您可以重新申请一次！";
                        self.secondView.backgroundColor = UIColorFromRGB(0x10db9f);
                        self.secondImage.image = [UIImage imageNamed:@"checking"];
                        self.thirdImage.image = [UIImage imageNamed:@"checking"];
                        
                    });
                }
            }else{
                [weakSelf showMessage:@"查看审核详情失败！"];
            }
        }
    }];
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}

@end
