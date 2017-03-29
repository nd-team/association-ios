//
//  NameViewController.m
//  CommunityProject
//
//  Created by bjike on 17/3/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "NameViewController.h"
//修改好友备注
#define ChangeNameURL @"http://192.168.0.209:90/appapi/app/editFriendName"
//修改群名
#define ChangeGroupNameURL @"http://192.168.0.209:90/appapi/app/changeGroupName"
//修改群昵称
#define ChangeNickNameURL @"http://192.168.0.209:90/appapi/app/changeUserName"

@interface NameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
//当前用户ID
@property (nonatomic,copy)NSString * userId;

@end

@implementation NameViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBar];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 50)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    self.nameTF.leftView = backView;
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    self.nameTF.placeholder = self.placeHolder;
    self.nameTF.text = self.content;
}
-(void)setBar{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefaults objectForKey:@"userId"];
    self.navigationItem.title = self.name;
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 30) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIButton * rightBtn = [UIButton CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) andBackgroundColor:UIColorFromRGB(0xffffff) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:@"保存"];
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    //手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];

}
-(void)tapClick{
    [self.nameTF resignFirstResponder];
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemClick{
    [self tapClick];
    if (self.nameTF.text.length != 0) {
        //好友昵称修改
        if (self.titleCount == 1) {
            NSDictionary * params = @{@"userId":self.userId,@"friendUserid":self.friendId};
            NSMutableDictionary * dic = [NSMutableDictionary new];
            [dic setValuesForKeysWithDictionary:params];
            [dic setValue:self.nameTF.text forKey:@"displayname"];
            [self changeDisplayName:dic andUrl:ChangeNameURL andSymbol:1];
            //群昵称
        }else if (self.titleCount == 2){
            NSDictionary * params = @{@"userId":self.userId,@"groupId":self.groupId};
            NSMutableDictionary * dic = [NSMutableDictionary new];
            [dic setValuesForKeysWithDictionary:params];
            [dic setValue:self.nameTF.text forKey:@"groupName"];
            [self changeDisplayName:dic andUrl:ChangeNickNameURL andSymbol:2];

            //群名称
        }else if (self.titleCount == 3){
            NSDictionary * params = @{@"userId":self.userId,@"groupId":self.groupId};
            NSMutableDictionary * dic = [NSMutableDictionary new];
            [dic setValuesForKeysWithDictionary:params];
            [dic setValue:self.nameTF.text forKey:@"groupName"];
            [self changeDisplayName:dic andUrl:ChangeGroupNameURL andSymbol:3];
        }
    }else{
        [self leftClick];
    }
   
}
-(void)changeDisplayName:(NSMutableDictionary *)mDic andUrl:(NSString *)url andSymbol:(int)symbol{
    
    WeakSelf;
    [AFNetData postDataWithUrl:url andParams:mDic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"修改备注失败%@",error);
//            [weakSelf showMessage:@"修改备注失败"];
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSSLog(@"%@",jsonDic);
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                if (symbol == 1) {
                    weakSelf.friendDelegate.display = self.nameTF.text;
                }else if (symbol == 2){
                    weakSelf.hostDelegate.nickname = self.nameTF.text;
                    weakSelf.memberDelegate.nickname = self.nameTF.text;
                }else{
                    //群名修改完要刷新SDK
                    RCGroup * group = [[RCGroup alloc]initWithGroupId:self.groupId groupName:self.nameTF.text portraitUri:self.headUrl];
                    [[RCIM sharedRCIM]refreshGroupInfoCache:group withGroupId:self.groupId];
                    weakSelf.hostDelegate.groupName = self.nameTF.text;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else{
//                [weakSelf showMessage:@"修改备注失败"];
            }
        }
    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self tapClick];
    return YES;
}
@end
