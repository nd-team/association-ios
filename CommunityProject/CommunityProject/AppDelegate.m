//
//  AppDelegate.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LoginController.h"
#import "FriendsListModel.h"
#import "AddressDataBaseSingleton.h"
#import "GroupModel.h"
#import "GroupDatabaseSingleton.h"
#import "MemberListModel.h"
#import "ViewController.h"
//短信
#import <SMS_SDK/SMSSDK.h>
//ShareSDK
#import <ShareSDKConnector/ShareSDKConnector.h>
//QQ
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//wechat
#import "WXApi.h"
//新浪微博
#import "WeiboSDK.h"
#import "ConfirmInfoController.h"
#import "SRDownloadManager.h"

#define LoginURL @"appapi/app/login"
#define MemberURL @"appapi/app/groupMember"
#define FriendListURL @"appapi/app/friends"
#define GroupURL @"appapi/app/groupData"

@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>
@property (nonatomic,strong) UIImageView * imageView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //新的window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //融云tdrvipkstdnk5  x4vkb1qpx0tmk
    [[RCIM sharedRCIM]initWithAppKey:@"tdrvipkstdnk5"];
    //应用的Scheme
    [[RCIM sharedRCIM]setScheme:@"CommunityRedPacket" forExtensionModule:@"JrmfPacketManager"];
    //设置会话列表头像和会话界面头像
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    //设置用户和数组数据持续化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //设置头像和昵称
    [RCIM sharedRCIM].userInfoDataSource = self;
    [RCIM sharedRCIM].groupInfoDataSource = self;
    //开启发送已读回执
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_GROUP),@(ConversationType_PRIVATE)];
    //开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    //群成员数据源
    [RCIM sharedRCIM].groupMemberDataSource = self;
    //开启消息@功能
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    //开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    [RCIM sharedRCIM].maxRecallDuration = 180;
    //本地持久化保存
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //多端同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    //设置头像为矩形 会话界面
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_RECTANGLE;
    //会话界面和列表头像大小
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(50, 50);
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(62, 61.5);
    [RCIM sharedRCIM].portraitImageViewCornerRadius = 5;
    //会话列表头像globalConversationPortraitSize
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_RECTANGLE;
    //shareSDK  @(SSDKPlatformTypeRenren)
   //Mob分享
    [ShareSDK registerApp:@"1d7a4e9e033cd" activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                                                @(SSDKPlatformTypeMail),
                                                @(SSDKPlatformTypeSMS),
                                                @(SSDKPlatformTypeCopy),
                                                @(SSDKPlatformTypeWechat),
                                                @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
                                                    switch (platformType)
                                                    {
                                                        case SSDKPlatformTypeWechat:
                                                            [ShareSDKConnector connectWeChat:[WXApi class]];
                                                            break;
                                                        case SSDKPlatformTypeQQ:
                                                            [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                            break;
                                                        case SSDKPlatformTypeSinaWeibo:
                                                            [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                            break;
//                                                        case SSDKPlatformTypeRenren:
//                                                            [ShareSDKConnector connectRenren:[RennClient class]];
//                                                            break;
                                                        default:
                                                            break;
                                                    }
                                                } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                                    switch (platformType)
                                                    {
                                                        case SSDKPlatformTypeSinaWeibo:
                                                            //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                                            [appInfo SSDKSetupSinaWeiboByAppKey:@"2851807147"
                                                                                      appSecret:@"5baea328af2e0d4f4ab9185b746db408"
                                                                                    redirectUri:@"http://www.sharesdk.cn"
                                                                                       authType:SSDKAuthTypeBoth];
                                                            break;
                                                        case SSDKPlatformTypeWechat:
                                                            [appInfo SSDKSetupWeChatByAppId:@"wx99349512bda3fee4"
                                                                                  appSecret:@"f3e9340c0e75f9d18bdf4e063191b4d0"];
                                                            break;
                                                        case SSDKPlatformTypeQQ:
                                                            [appInfo SSDKSetupQQByAppId:@"1106057589"
                                                                                 appKey:@"YBWSnpD1KCgvNW5B"
                                                                               authType:SSDKAuthTypeBoth];
                                                            break;
//                                                        case SSDKPlatformTypeRenren:
//                                                            [appInfo        SSDKSetupRenRenByAppId:@"226427"
//                                                                                            appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                                                                                         secretKey:@"f29df781abdd4f49beca5a2194676ca4"
//                                                                                          authType:SSDKAuthTypeBoth];
//                                                            break;
                                                        case SSDKPlatformTypeGooglePlus:
                                                            [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                                                                      clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                                                                       redirectUri:@"http://localhost"];
                                                            break;
                                                        default:
                                                            break;
                                                    }
                                                }];
    //高德地图
    [AMapServices sharedServices].apiKey = @"a6bca6b19ec2f4c52428fd977fd553d8";
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    //设置当前用户
    [self netWork];
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];//nagivationBar.png
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].translucent = NO;
    [RCIM sharedRCIM].globalNavigationBarTintColor = UIColorFromRGB(0x121212);
    [UITabBar appearance].tintColor = UIColorFromRGB(0x10db9f);
    // 短信验证码
    [SMSSDK registerApp:@"1e627fcacd326" withSecret:@"7e94ccd2d1cb86aabc324432786514a3"];
    [SRDownloadManager sharedManager].maxConcurrentCount = 3;
    //下载文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CustomDownloadDirectory"];
    [SRDownloadManager sharedManager].saveFilesDirectory = path;

    return YES;
}
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    //如果是系统消息 通知发现显示小红点
    if ([message.content isMemberOfClass:[RCCommandNotificationMessage class]]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SystemMessage" object:nil];
        
    }else if([message.content isMemberOfClass:[RCContactNotificationMessage class]]){
        //好友请求消息类
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FriendsMessage" object:nil];

    }
}
-(void)netWork{
    NSString * token = [DEFAULTS objectForKey:@"token"];
    NSString * phone = [DEFAULTS objectForKey:@"userId"];
    NSString * password = [DEFAULTS objectForKey:@"password"];
    NSString * nickname = [DEFAULTS objectForKey:@"nickname"];
    NSString * userPortraitUrl = [DEFAULTS objectForKey:@"userPortraitUrl"];
    NSString * status = [DEFAULTS objectForKey:@"status"];
    BOOL isTruing = [DEFAULTS boolForKey:@"isRuning"];
    if (isTruing) {
        //VIP未确认信息到确认信息界面
        if (token != nil && phone != nil && password != nil) {
            //
            if ([status integerValue] == 1) {
                //非VIP或者VIP已经确认过信息
                [self loginMain];
                //设置当前用户的用户信息
                RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:phone name:nickname portrait:userPortraitUrl];
                [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
                [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:phone];
                [self loginRongServicer:token andPhone:phone andPassword:password];
            }else{
                //进入登录界面
                [self login];
 
            }
           
        }else{
            [self login];
        }
    }else{
        //创建文件
        ViewController * vc = [ViewController new];
        self.window.rootViewController = vc;
    }

   
}
//@功能实现给融云提供群成员 本地
-(void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [userDefaults objectForKey:@"userId"];
    //用groupID查找用户ID
    NSDictionary * dict = @{@"groupId":groupId,@"userId":userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MemberURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取群成员失败%@",error);
        }else{
            NSNumber * code = data[@"code"];
            NSMutableArray * ret = [NSMutableArray new];
            if ([code intValue] == 200) {
                NSArray * array = data[@"data"];
                for (NSDictionary * dic in array) {
                    MemberListModel * member = [[MemberListModel alloc]initWithDictionary:dic error:nil];
                    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:member.userId name:member.userName portrait:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:member.userPortraitUrl]]];
                    //刷新群组成员的信息
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:member.userId];
                    [ret addObject:dic[@"userId"]];
                }
                resultBlock(ret);
            }
            
        }
    }];
}
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    NSInteger status = [[RCIMClient sharedRCIMClient]getCurrentNetworkStatus];
    NSString * userID = [DEFAULTS objectForKey:@"userId"];
    if (status == 0) {
        //无网
        AddressDataBaseSingleton * single = [AddressDataBaseSingleton shareDatabase];
        NSArray * arr = [single searchDatabase];
        for (FriendsListModel * list in arr) {
            if ([list.userId isEqualToString:userId]) {
                RCUserInfo * userInfo2 = [RCUserInfo new];
                userInfo2.userId = list.userId;
                if (list.displayName.length != 0) {
                    userInfo2.name = list.displayName;
                }else{
                    userInfo2.name = list.nickname;
                }
                if ([list.userId isEqualToString:userID]) {
                    userInfo2.portraitUri = list.userPortraitUrl;
                    
                }else{
                    userInfo2.portraitUri = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:list.userPortraitUrl]];
                    
                }
              return  completion(userInfo2);
            }
        }

    }else{
        NSString * nickname = [DEFAULTS objectForKey:@"nickname"];
        NSString * head = [DEFAULTS objectForKey:@"userPortraitUrl"];
        NSString * email = [DEFAULTS objectForKey:@"email"];
        //从服务器获取好友列表
        [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendListURL] andParams:@{@"userId":userID} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
            if (error) {
                NSSLog(@"获取好友列表失败：%@",error);
            }else{
                AddressDataBaseSingleton * single = [AddressDataBaseSingleton shareDatabase];
                NSArray * arr1 = [single searchDatabase];
                for (FriendsListModel * list in arr1) {
                    [[AddressDataBaseSingleton shareDatabase]deleteDatabase:list];
                }
                NSNumber * code = data[@"code"];
                if ([code intValue] == 200) {
                    NSArray * arr = data[@"data"];
                    NSMutableArray * array = [NSMutableArray new];
                    NSMutableDictionary * mutDic = [NSMutableDictionary new];
                    NSDictionary * dict = @{@"userId":userID,@"nickname":nickname,@"userPortraitUrl":head,@"mobile":userID};
                    [mutDic setValuesForKeysWithDictionary:dict];
                    [mutDic setValue:email forKey:@"email"];
                    [array addObjectsFromArray:@[mutDic]];
                    [array addObjectsFromArray:arr];
                    for (NSDictionary * dic in array) {
                        FriendsListModel * search = [[FriendsListModel alloc]initWithDictionary:dic error:nil];
                        [[AddressDataBaseSingleton shareDatabase]insertDatabase:search];
                        if ([search.userId isEqualToString:userId]) {
                            RCUserInfo * userInfo2 = [RCUserInfo new];
                            userInfo2.userId = search.userId;
                            if (search.displayName.length != 0) {
                                userInfo2.name = search.displayName;
                            }else{
                                userInfo2.name = search.nickname;
                            }
                            if ([search.userId isEqualToString:userID]) {
                                userInfo2.portraitUri = search.userPortraitUrl;
                            }else{
                                userInfo2.portraitUri = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:search.userPortraitUrl]];
                            }
                            return completion(userInfo2);

                        }
                    }
                }else if ([code intValue] == 0){
                    NSSLog(@"获取失败");
                }
            }
            
        }];
    }
}
//群组头像和昵称
-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
    NSInteger status = [[RCIMClient sharedRCIMClient]getCurrentNetworkStatus];
    if (status == 0) {
        //无网
        GroupDatabaseSingleton * single = [GroupDatabaseSingleton shareDatabase];
        NSArray * arr = [single searchDatabase];
        for (GroupModel * model in arr) {
            if ([model.groupId isEqualToString:groupId]) {
                RCGroup * group = [RCGroup new];
                group.groupId = model.groupId;
                group.groupName = model.groupName;
                group.portraitUri = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:model.groupPortraitUrl]];
              return  completion(group);
            }
        }
    }else{
        NSString * userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
        [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,GroupURL] andParams:@{@"userId":userID} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
            if (error) {
                NSSLog(@"获取群组列表失败%@",error);
            }else{
                NSNumber * code = data[@"code"];
                if ([code intValue] == 200) {
                    NSArray * arr = data[@"data"];
                    for (NSDictionary * dic in arr) {
                        GroupModel * model = [[GroupModel alloc]initWithDictionary:dic error:nil];
                        if ([model.groupId isEqualToString:groupId]) {
                            RCGroup * group = [RCGroup new];
                            group.groupId = model.groupId;
                            group.groupName = model.groupName;
                            group.portraitUri = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:model.groupPortraitUrl]];
                            return  completion(group);
                        }
                    }
                }
                
            }
        }];
    }
}

-(void)loginNet:(NSString *)phone andPassword:(NSString *)password{
    WeakSelf;
    NSDictionary * dic = @{@"mobile":phone,@"password":password};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,LoginURL] andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"登录失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //成功
                NSDictionary * msg = data[@"data"];
                //保存用户数据
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:msg[@"userId"] forKey:@"userId"];
                //昵称
                [userDefaults setValue:msg[@"nickname"] forKey:@"nickname"];
                //头像
                NSString * url = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:msg[@"userPortraitUrl"]]];

                [userDefaults setValue:url forKey:@"userPortraitUrl"];
                //token
                [userDefaults setValue:msg[@"token"] forKey:@"token"];
                //sex
                NSNumber * sex = msg[@"sex"];
                [userDefaults setInteger:[sex integerValue] forKey:@"sex"];

                if (![msg[@"favour"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"favour"] forKey:@"favour"];
                }
                if (![msg[@"checkVip"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setInteger:[msg[@"checkVip"] integerValue]forKey:@"checkVip"];
                }
                if (![msg[@"checkCar"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setInteger:[msg[@"checkCar"] integerValue]forKey:@"checkCar"];
                }

                if (![msg[@"birthday"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"birthday"] forKey:@"birthday"];
                }
                if (![msg[@"address"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"address"] forKey:@"address"];
                }
                if (![msg[@"email"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"email"] forKey:@"email"];
                }
                if (![msg[@"mobile"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"mobile"] forKey:@"mobile"];
                }
                if (![msg[@"numberId"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"numberId"] forKey:@"numberId"];
                }
                if (![msg[@"experience"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"experience"]] forKey:@"experience"];
                }
                if (![msg[@"creditScore"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"creditScore"]] forKey:@"creditScore"];
                }
                if (![msg[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"contributionScore"]] forKey:@"contributionScore"];
                }
                //VIP字段
                if ([[msg allKeys] containsObject:@"recommendUserId"]) {
                    if (![msg[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                        [userDefaults setValue:msg[@"recommendUserId"] forKey:@"recommendUserId"];
                    }
                }
                if ([[msg allKeys] containsObject:@"claimUserId"]) {
                    if (![msg[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                        [userDefaults setValue:msg[@"claimUserId"] forKey:@"claimUserId"];
                    }
                }
                if ([[msg allKeys] containsObject:@"status"]) {
                    [userDefaults setValue:msg[@"status"] forKey:@"status"];
                }
                [userDefaults synchronize];
                //设置当前用户
                RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:msg[@"userId"] name:msg[@"nickname"] portrait:url];
                [RCIM sharedRCIM].currentUserInfo = userInfo;
            }else if ([code intValue] == 0){
                [weakSelf showMessage:@"账号不存在,请退出！"];
                //清空本地数据库
            }else if ([code intValue] == 1002){
                [weakSelf showMessage:@"账号禁止登录！"];
            }else if ([code intValue] == 1003){
                [weakSelf showMessage:@"密码错误,请退出！"];
                //传账号
                
            }else{
//                [weakSelf showMessage:@"未知错误！"];
                NSSLog(@"登录失败！");
            }
        }
    }];
}
-(void)clear{
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
    [DEFAULTS setBool:YES forKey:@"isRuning"];
    [DEFAULTS synchronize];
}
-(void)showMessage:(NSString *)msg{
    NSString * token = [DEFAULTS objectForKey:@"token"];
    NSString * phone = [DEFAULTS objectForKey:@"userId"];
    NSString * password = [DEFAULTS objectForKey:@"password"];
    NSString * nickname = [DEFAULTS objectForKey:@"nickname"];
    NSString * userPortraitUrl = [DEFAULTS objectForKey:@"userPortraitUrl"];
    WeakSelf;
    [MessageAlertView alertViewWithTitle:@"温馨提示" message:msg buttonTitle:@[@"退出",@"重新登录"] Action:^(NSInteger indexpath) {
        if (indexpath == 1) {
            //重新登录融云和账号
            RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:phone name:nickname portrait:userPortraitUrl];
            [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
            [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:phone];
            [self loginRongServicer:token andPhone:phone andPassword:password];
        }else{
            if ([msg isEqualToString:@"账号不存在,请退出！"]) {
                [weakSelf clear];
            }
            [weakSelf login];
        }
        
    } viewController:self.window.rootViewController];
    
}
//登录融云服务器
-(void)loginRongServicer:(NSString *)token andPhone:(NSString *)phone andPassword:(NSString *)password{
    WeakSelf;
    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
        NSSLog(@"登录成功%@",userId);
        [weakSelf loginNet:phone andPassword:password];
    } error:^(RCConnectErrorCode status) {
        NSSLog(@"错误码：%ld",(long)status);
        [weakSelf loginMain];
        //SDK自动重新连接
        [[RCIM sharedRCIM]setConnectionStatusDelegate:self];
    } tokenIncorrect:^{
        NSSLog(@"token错误");
        [weakSelf loginNet:phone andPassword:password];
    }];
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == ConnectionStatus_Connected) {
            [RCIM sharedRCIM].connectionStatusDelegate = (id<RCIMConnectionStatusDelegate>)[UIApplication sharedApplication].delegate;
        } else if (status == ConnectionStatus_NETWORK_UNAVAILABLE) {
            [weakSelf loginMain];
        } else if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
            [weakSelf showMessage:@"您的帐号在别的设备上登录，您被迫下线！"];
        } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
            NSSLog(@"Token无效");
            //重连token
            NSString * token = [DEFAULTS objectForKey:@"token"];
            [[RCIM sharedRCIM] connectWithToken:token
                                        success:^(NSString *userId) {
                                            
                                        } error:^(RCConnectErrorCode status) {
                                            
                                        } tokenIncorrect:^{
                                            
                                        }];

        } else {
            NSLog(@"RCConnectErrorCode is %zd", status);
        }
    });
}
-(void)loginMain{
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;

}
-(void)login{
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
}
//红包需要实现的两个方法
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if ([[RCIM sharedRCIM]openExtensionModuleUrl:url]) {
        return YES;
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[RCIM sharedRCIM] openExtensionModuleUrl:url]) {
        return YES;
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CommunityProject"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
@end
