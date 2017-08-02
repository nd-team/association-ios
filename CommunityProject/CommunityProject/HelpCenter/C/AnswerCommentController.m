//
//  AnswerCommentController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/5.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AnswerCommentController.h"

#define AnswerURL @"appapi/app/answerSeekHelp"

@interface AnswerCommentController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@property (nonatomic,copy) NSString * userId;

@end

@implementation AnswerCommentController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加回答";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"取消" andLeft:-15 andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"发布" andLeft:15 andTarget:self Action:@selector(sendClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.userId = [DEFAULTS objectForKey:@"userId"];

}
-(void)leftClick{
    [self.contentTV resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)sendClick{
    [self.contentTV resignFirstResponder];
    if (self.contentTV.text.length == 0) {
        [self showMessage:@"请填写回答内容"];
        return;
    }
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf send];
    });
}
-(void)send{
    WeakSelf;
    NSDictionary * dict = @{@"userId":self.userId,@"seekId":self.actID,@"content":self.contentTV.text};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,AnswerURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"采纳答案失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //刷新评论列表
                weakSelf.delegate.isRef = YES;
                [weakSelf leftClick];
            }else if ([code intValue] == 1025){
                [weakSelf showMessage:@"用户已回答"];
            }else{
                [weakSelf showMessage:@"评论失败"];
            }
        }
    }];
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
    }
}

@end
