//
//  AddFriendController.m
//  CommunityProject
//
//  Created by bjike on 17/3/27.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AddFriendController.h"

#define AddFriendURL @"http://192.168.0.209:90/appapi/app/addfriendRequest"

@interface AddFriendController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (nonatomic,copy)NSString * userId;

@end

@implementation AddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    self.navigationItem.title = @"申请留言";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addFriendClick:(id)sender {
    [self postAddFriend];
}
-(void)postAddFriend{
    WeakSelf;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [userDefaults objectForKey:@"nickname"];
    NSDictionary * params = @{@"userId":self.userId,@"nickname":userName,@"friendUserid":self.friendId,@"status":@"0"};
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setValuesForKeysWithDictionary:params];
    [dic setValue:self.contentTV.text forKey:@"addFriendMessage"];
    [AFNetData postDataWithUrl:AddFriendURL andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"添加好友失败：%@",error);
//            [weakSelf showMessage:@"添加好友失败"];
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
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
