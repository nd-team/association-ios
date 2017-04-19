//
//  GroupNoticeViewController.m
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GroupNoticeViewController.h"

#define NoticeURL @"appapi/app/groupNotice"
@interface GroupNoticeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *noticeTV;

@end

@implementation GroupNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBar];
}
-(void)setBar{
    
    self.navigationItem.title = @"群公告";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 30) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    if (self.isHost) {
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,40, 30) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:@"创建" and:self Action:@selector(rightItemClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
//        UIButton * rightBtn = [UIButton CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) andBackgroundColor:UIColorFromRGB(0xffffff) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:@"创建"];
//        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
//        [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = rightItem;
        self.noticeTV.userInteractionEnabled = YES;
    }else{
        self.noticeTV.userInteractionEnabled = NO;
  
    }
    self.noticeTV.text = self.publicNotice;
    //手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemClick{
    WeakSelf;
    [MessageAlertView alertViewWithTitle:@"君上，确定新建公告吗？" message:nil buttonTitle:@[@"取消",@"确定"] Action:^(NSInteger indexpath) {
        if (indexpath == 1) {
            [weakSelf createNotice];
        }
    } viewController:self];

}
-(void)createNotice{
    NSMutableDictionary * mDic = [NSMutableDictionary new];
    [mDic setValue:self.groupId forKey:@"groupId"];
    [mDic setValue:self.hostId forKey:@"userId"];
    [mDic setValue:self.noticeTV.text forKey:@"niteceContent"];
    WeakSelf;
    [AFNetData postDataWithUrl:NoticeURL andParams:mDic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"创建公告失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                weakSelf.hostDelegate.publicNotice = self.noticeTV.text;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
            }

    }];
}
-(void)tapClick{
    [self.noticeTV resignFirstResponder];
}
@end
