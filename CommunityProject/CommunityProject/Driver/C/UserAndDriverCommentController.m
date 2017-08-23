//
//  UserAndDriverCommentController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/14.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "UserAndDriverCommentController.h"

#define CommentURL @"appapi/app/userEvaluate"

@interface UserAndDriverCommentController ()
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;
@property (weak, nonatomic) IBOutlet UIButton *fifthBtn;
@property (weak, nonatomic) IBOutlet UITextView *commentTV;
@property (nonatomic,copy)NSString * score;

@end

@implementation UserAndDriverCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"提交" andLeft:15 andTarget:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.whiteView.layer.cornerRadius = 5;
    [self.headImageView zy_cornerRadiusRoundingRect];
    [self setButton:self.firstBtn];
    [self setButton:self.secondBtn];
    [self setButton:self.thirdBtn];
    [self setButton:self.fourthBtn];
    [self setButton:self.fifthBtn];
    self.score = @"1";
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];

}
-(void)tapClick{
    [self.commentTV resignFirstResponder];
}
-(void)setButton:(UIButton *)btn{
    [btn setBackgroundImage:[UIImage imageNamed:@"bigDarkStar"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"bigStar"] forState:UIControlStateSelected];
    
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//提交评价
-(void)rightClick{
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf postMoney];
    });
}
-(void)postMoney{
    NSMutableDictionary * params = [NSMutableDictionary new];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:self.orderId forKey:@"orderId"];
    [params setValue:self.commentTV.text forKey:@"content"];
    [params setValue:self.score forKey:@"starNumber"];
    [params setValue:self.type forKey:@"type"];

    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CommentURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"评价失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [weakSelf showMessage:@"评价成功！"];

            }else{
                [weakSelf showMessage:@"评价失败！"];
            }
        }
    }];
    
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
- (IBAction)firstClick:(id)sender {
    self.score = @"1";
    self.firstBtn.selected = YES;
    self.secondBtn.selected = NO;
    self.thirdBtn.selected = NO;
    self.fourthBtn.selected = NO;
    self.fifthBtn.selected = NO;
}
- (IBAction)secondClick:(id)sender {
    self.score = @"2";
    self.firstBtn.selected = YES;
    self.secondBtn.selected = YES;
    self.thirdBtn.selected = NO;
    self.fourthBtn.selected = NO;
    self.fifthBtn.selected = NO;
}
- (IBAction)thirdClick:(id)sender {
    self.score = @"3";
    self.firstBtn.selected = YES;
    self.secondBtn.selected = YES;
    self.thirdBtn.selected = YES;
    self.fourthBtn.selected = NO;
    self.fifthBtn.selected = NO;

}
- (IBAction)fourthClick:(id)sender {
    self.score = @"4";
    self.firstBtn.selected = YES;
    self.secondBtn.selected = YES;
    self.thirdBtn.selected = YES;
    self.fourthBtn.selected = YES;
    self.fifthBtn.selected = NO;

}
- (IBAction)fifthClick:(id)sender {
    self.score = @"5";
    self.firstBtn.selected = YES;
    self.secondBtn.selected = YES;
    self.thirdBtn.selected = YES;
    self.fourthBtn.selected = YES;
    self.fifthBtn.selected = YES;
}


@end
