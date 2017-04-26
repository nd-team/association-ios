//
//  NameViewController.m
//  CommunityProject
//
//  Created by bjike on 17/3/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "NameViewController.h"
#import "ChatMainController.h"

//修改好友备注
#define ChangeNameURL @"appapi/app/editFriendName"
//修改群名
#define ChangeGroupNameURL @"appapi/app/changeGroupName"
//修改群昵称
#define ChangeNickNameURL @"appapi/app/changeUserName"
//创建群聊
#define CreateGroup @"appapi/app/createGroup"

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
    [self.nameTF becomeFirstResponder];
}
-(void)setBar{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefaults objectForKey:@"userId"];
    self.navigationItem.title = self.name;
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 30) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:self.rightStr andLeft:15 andTarget:self Action:@selector(rightItemClick)];

//    UIButton * rightBtn = [UIButton CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) andBackgroundColor:UIColorFromRGB(0xffffff) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:self.rightStr];
//    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
//    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];

}
-(void)tapClick{
    [self.nameTF resignFirstResponder];
}
-(void)leftClick{
    [self back];
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
            [self changeDisplayName:dic andUrl:[NSString stringWithFormat:NetURL,ChangeNameURL] andSymbol:1];
            //群昵称
        }else if (self.titleCount == 2){
            NSDictionary * params = @{@"userId":self.userId,@"groupId":self.groupId};
            NSMutableDictionary * dic = [NSMutableDictionary new];
            [dic setValuesForKeysWithDictionary:params];
            [dic setValue:self.nameTF.text forKey:@"groupName"];
            [self changeDisplayName:dic andUrl:[NSString stringWithFormat:NetURL,ChangeNickNameURL] andSymbol:2];

            
        }else if (self.titleCount == 3){
            if (self.isChangeGroupName) {
                //群名称
                NSDictionary * params = @{@"userId":self.userId,@"groupId":self.groupId};
                NSMutableDictionary * dic = [NSMutableDictionary new];
                [dic setValuesForKeysWithDictionary:params];
                [dic setValue:self.nameTF.text forKey:@"groupName"];
                [self changeDisplayName:dic andUrl:[NSString stringWithFormat:NetURL,ChangeGroupNameURL] andSymbol:3];
            }else{
                //新建群聊
                NSDictionary * params = @{@"groupUser":self.userStr,@"userId":self.userId};
                NSMutableDictionary * dic = [NSMutableDictionary new];
                [dic setValuesForKeysWithDictionary:params];
                [dic setValue:self.nameTF.text forKey:@"groupName"];
                [self changeDisplayName:dic andUrl:[NSString stringWithFormat:NetURL,CreateGroup] andSymbol:3];
 
            }
           
        }else if (self.titleCount == 4){
            self.createDelegate.name = self.nameTF.text;
            [self back];
            
        }else if (self.titleCount == 5){
            self.createDelegate.limitPeople = self.nameTF.text;
            [self back];
        }else if (self.titleCount == 6){
            //新建兴趣联盟
            NSDictionary * params = @{@"groupUser":self.userStr,@"userId":self.userId,@"hobbyId":self.hobbyId};
            NSMutableDictionary * dic = [NSMutableDictionary new];
            [dic setValuesForKeysWithDictionary:params];
            [dic setValue:self.nameTF.text forKey:@"groupName"];
            [self changeDisplayName:dic andUrl:[NSString stringWithFormat:NetURL,CreateGroup] andSymbol:3];
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
            //[weakSelf showMessage:@"修改备注失败"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                if (symbol == 1) {
                    //好友昵称修改
                    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:weakSelf.friendId name:self.nameTF.text portrait:self.headUrl];
                    [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:weakSelf.friendId];
                    weakSelf.friendDelegate.display = self.nameTF.text;
                    [self back];
                }else if (symbol == 2){
                    weakSelf.hostDelegate.nickname = self.nameTF.text;
                    weakSelf.memberDelegate.nickname = self.nameTF.text;
                    [self back];
                }else{
                    if (self.isChangeGroupName) {
                        //群名修改完要刷新SDK
                        RCGroup * group = [[RCGroup alloc]initWithGroupId:weakSelf.groupId groupName:weakSelf.nameTF.text portraitUri:weakSelf.headUrl];
                        [[RCIM sharedRCIM]refreshGroupInfoCache:group withGroupId:weakSelf.groupId];
                        weakSelf.hostDelegate.groupName = weakSelf.nameTF.text;
                        [self back];
                    }else{
                        //创建群聊 返回聊天
                        //发送消息可以聊天了
                        NSDictionary * group = data[@"data"];
                        RCTextMessage * textMsg = [RCTextMessage messageWithContent:@"创建了群聊，大家一起交流吧！"];
                        [[RCIM sharedRCIM]sendMessage:ConversationType_GROUP targetId:group[@"groupId"] content:textMsg pushContent:nil pushData:nil success:^(long messageId) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                for (UIViewController* vc in weakSelf.navigationController.viewControllers) {
                                    
                                    if ([vc isKindOfClass:[ChatMainController class]]) {
                                        
                                        [weakSelf.navigationController popToViewController:vc animated:YES];
                                    }
                                }
                            });
                        } error:^(RCErrorCode nErrorCode, long messageId) {
                            //        [weakSelf showMessage:@"发送消息失败"];
                            
                        }];
                       
                    }
                    
                }
            }else{
                //                [weakSelf showMessage:@"修改备注失败"];
            }
        }
    }];
    
}
-(void)back{
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self tapClick];
    return YES;
}
@end
