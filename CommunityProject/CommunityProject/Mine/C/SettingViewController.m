//
//  SettingViewController.m
//  ISSP
//
//  Created by bjike on 16/10/21.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginController.h"

//#define iOS9 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *msgBtn;

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10DB9F);
    [self.msgBtn setBackgroundImage:[UIImage imageNamed:@"switchOff.png"] forState:UIControlStateNormal];
    [self.msgBtn setBackgroundImage:[UIImage imageNamed:@"switchOn.png"] forState:UIControlStateSelected];
    BOOL isTop = [DEFAULTS boolForKey:@"MessageNotice"];
    self.msgBtn.selected = isTop;
    

}
- (IBAction)messageClick:(id)sender {
    [MessageAlertView alertViewWithTitle:@"温馨提示" message:@"此功能下个版本见" buttonTitle:@[@"确定"] Action:^(NSInteger indexpath) {
        NSSLog(@"消息提示");
    } viewController:self];
    /*
    self.msgBtn.selected = !self.msgBtn.selected;
    //保存状态
    [DEFAULTS setBool:self.msgBtn.selected forKey:@"MessageNotice"];
    [DEFAULTS synchronize];
     */
}

- (IBAction)exitClick:(id)sender {
    //退出登录
    WeakSelf;
    [MessageAlertView alertViewWithTitle:@"温馨提示" message:@"君上，确定要退出登录吗？" buttonTitle:@[@"取消",@"确定"] Action:^(NSInteger indexpath) {
        if (indexpath == 1) {
            [weakSelf exit];
        }else{
            
            NSLog(@"取消");
        }
    } viewController:self];

    
}
-(void)exit{
    NSString * path = [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:path];
    //断开连接并不接收远程推送
    [[RCIMClient sharedRCIMClient]logout];
    //清空融云SDK
    [[RCIM sharedRCIM]clearUserInfoCache];
    [[RCIM sharedRCIM]clearGroupInfoCache];
    //清空本地文件
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * addressPath = [NSHomeDirectory()stringByAppendingString:@"/Documents"];
    [fileManager removeItemAtPath:addressPath error:nil];
    //解决启动页问题
    NSString *firstPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"1.txt"];
    
    NSFileManager * file= [NSFileManager defaultManager];
    //创建文件
    [file createFileAtPath:firstPath contents:nil attributes:nil];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginController * login = [sb instantiateViewControllerWithIdentifier:@"LoginController"];
    [self presentViewController:login animated:YES completion:nil];

}

@end
