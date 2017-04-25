//
//  GroupNoticeViewController.m
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GroupNoticeViewController.h"
#import "UIView+ChatMoreView.h"

#define NoticeURL @"appapi/app/groupNotice"
@interface GroupNoticeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *noticeTV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conHeightCons;
@property (nonatomic,strong) UIView * backView;

@property (nonatomic,strong)UIWindow * window;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end

@implementation GroupNoticeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBar];
}
-(void)setBar{
    
    self.navigationItem.title = self.name;
    if (self.dif == 2) {
        self.conHeightCons.constant = 227.5;
    }else{
        self.conHeightCons.constant = 260;
    }
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10DB9F);
    if (self.dif == 1 || self.dif == 2) {
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:self.rightStr and:self Action:@selector(rightItemClick)];
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
    if (self.dif == 2) {
        self.placeLabel.hidden = NO;
    }else{
        self.placeLabel.hidden = YES;
  
    }
    //手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    
}
-(void)rightItemClick{
    [self tapClick];
    if (self.noticeTV.text.length == 0) {
        return;
    }
    WeakSelf;
    if (self.dif == 1) {
        [MessageAlertView alertViewWithTitle:@"君上，确定新建公告吗？" message:nil buttonTitle:@[@"取消",@"确定"] Action:^(NSInteger indexpath) {
            if (indexpath == 1) {
                [weakSelf createNotice];
            }
        } viewController:self];
        
 
    }else{
       
        //请求网络数据成功弹出框
        [self showBackViewUI];
        
        
    }
}
-(void)showBackViewUI{
    
    self.backView = [UIView sureViewTitle:@"你的反馈信息已经收到了，我们会尽快处理" andTag:70 andTarget:self andAction:@selector(buttonAction:)];
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
    [self hideViewAction];
}
-(void)hideViewAction{
    self.backView.hidden = YES;
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
-(void)textViewDidChange:(UITextView *)textView{
    if (self.dif == 2) {
        if (textView.text.length == 0) {
            self.placeLabel.hidden = NO;
        }else{
            self.placeLabel.hidden = YES;
        }
    }
   
}
@end
