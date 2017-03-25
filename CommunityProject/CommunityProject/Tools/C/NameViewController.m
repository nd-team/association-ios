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

@interface NameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
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
    
    
}
-(void)setBar{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefaults objectForKey:@"userId"];
    self.navigationItem.title = self.name;
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
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
            [self changeDisplayName];
            //群昵称
        }else if (self.titleCount == 2){
            
            //群名称
        }else if (self.titleCount == 3){
            
        }
    }else{
        
    }
   
}
-(void)changeDisplayName{
    NSDictionary * params = @{@"userId":self.userId,@"friendUserid":self.friendId};
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setValuesForKeysWithDictionary:params];
    [dic setValue:self.nameTF.text forKey:@"displayname"];
    WeakSelf;
    [AFNetData postDataWithUrl:ChangeNameURL andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"修改备注失败%@",error);
//            [weakSelf showMessage:@"修改备注失败"];
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSSLog(@"%@",jsonDic);
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                weakSelf.friendDelegate.display = self.nameTF.text;
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
