//
//  GroupNoticeViewController.m
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GroupNoticeViewController.h"

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
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:self.rightStr andLeft:15  andTarget:self Action:@selector(rightItemClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
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
        [self showMessage:@"请输入内容"];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            //请求网络数据成功弹出框
            [weakSelf showBackViewUI];
        });
        
    }
}
-(void)showBackViewUI{
    
    self.backView = [UIView sureViewTitle:@"你的反馈信息已经收到了，我们会尽快处理" andTag:70 andTarget:self andAction:@selector(buttonAction:)];
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
    [self hideViewAction];
}
-(void)hideViewAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backView.hidden = YES;

    });
}
-(void)createNotice{
    NSMutableDictionary * mDic = [NSMutableDictionary new];
    [mDic setValue:self.groupId forKey:@"groupId"];
    [mDic setValue:self.hostId forKey:@"userId"];
    [mDic setValue:self.noticeTV.text forKey:@"niteceContent"];
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,NoticeURL] andParams:mDic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"创建公告失败：%@",error);
            [weakSelf showMessage:@"服务器出问题咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                weakSelf.hostDelegate.publicNotice = self.noticeTV.text;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [weakSelf showMessage:@"创建公告失败"];
            }
            }

    }];
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
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
