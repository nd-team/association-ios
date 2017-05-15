//
//  AddFriendController.m
//  CommunityProject
//
//  Created by bjike on 17/3/27.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AddFriendController.h"

#define AddFriendURL @"appapi/app/addfriendRequest"

@interface AddFriendController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (nonatomic,copy)NSString * userId;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation AddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    self.navigationItem.title = @"申请留言";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.addBtn setTitle:self.buttonName forState:UIControlStateNormal];
    [self.contentTV becomeFirstResponder];
    //手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];

    [self.view addGestureRecognizer:tap];
}
-(void)tapClick{
    [self.contentTV resignFirstResponder];
}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addFriendClick:(id)sender {
    [self tapClick];
    WeakSelf;
    [MessageAlertView alertViewWithTitle:@"确定申请吗？" message:nil buttonTitle:@[@"取消",@"确定"] Action:^(NSInteger indexpath) {
        if (indexpath == 1) {
            if ([self.buttonName isEqualToString:@"申请加群"]) {
                NSDictionary * params = @{@"userId":self.userId,@"groupId":self.groupId,@"status":@"1"};
                NSMutableDictionary * dic = [NSMutableDictionary new];
                [dic setValuesForKeysWithDictionary:params];
                [dic setValue:self.contentTV.text forKey:@"addFriendMessage"];
                [weakSelf postAddFriend:dic];

            }else{
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                NSString * userName = [userDefaults objectForKey:@"nickname"];
                NSDictionary * params = @{@"userId":self.userId,@"nickname":userName,@"friendUserid":self.friendId,@"status":@"0"};
                NSMutableDictionary * dic = [NSMutableDictionary new];
                [dic setValuesForKeysWithDictionary:params];
                [dic setValue:self.contentTV.text forKey:@"addFriendMessage"];
                [weakSelf postAddFriend:dic];
            }
        }
    } viewController:self];
}
-(void)postAddFriend:(NSMutableDictionary *)mDic{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,AddFriendURL] andParams:mDic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"添加好友失败：%@",error);
//            [weakSelf showMessage:@"添加好友失败"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else if ([code intValue] == 11){
//                [weakSelf showMessage:@"已经是好友了"];
            }else if ([code intValue] == 0){
//                [weakSelf showMessage:@"好友申请失败"];
            }
        }
    }];
}

@end
