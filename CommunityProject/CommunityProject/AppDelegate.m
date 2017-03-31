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

#define LoginURL @"http://192.168.0.209:90/appapi/app/login"
#define MemberURL @"http://192.168.0.209:90/appapi/app/groupMember"
#define FriendListURL @"http://192.168.0.209:90/appapi/app/friends"
#define GroupURL @"http://192.168.0.209:90/appapi/app/group_data"

@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,RCIMConnectionStatusDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //融云
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
    //设置头像为矩形 会话界面
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_RECTANGLE;
    //会话界面和列表头像大小
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(50, 50);
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(62, 61.5);
    [RCIM sharedRCIM].portraitImageViewCornerRadius = 5;
    //会话列表头像globalConversationPortraitSize
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_RECTANGLE;
    
    //设置当前用户
    [self netWork];
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];//nagivationBar.png
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].translucent = NO;
    [RCIM sharedRCIM].globalNavigationBarTintColor = UIColorFromRGB(0x121212);
  
    return YES;
}
-(void)netWork{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"token"];
    NSString * phone = [userDefaults objectForKey:@"userId"];
    NSString * password = [userDefaults objectForKey:@"password"];
    if (token != nil && phone != nil && password != nil) {
        [self loginRongServicer:token andPhone:phone andPassword:password];
    }else{
        [self login];
    }
}
//@功能实现给融云提供群成员 本地
-(void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [userDefaults objectForKey:@"userId"];
    //用groupID查找用户ID
    NSDictionary * dict = @{@"groupId":groupId,@"userId":userId};
    [AFNetData postDataWithUrl:MemberURL andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取群成员失败%@",error);
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            NSMutableArray * ret = [NSMutableArray new];
            if ([code intValue] == 200) {
                NSArray * array = jsonDic[@"data"];
                for (NSDictionary * dic in array) {
                    MemberListModel * member = [[MemberListModel alloc]initWithDictionary:dic error:nil];
                    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:member.userId name:member.userName portrait:[NSString stringWithFormat:@"http://192.168.0.209:90/%@",[ImageUrl changeUrl:member.userPortraitUrl]]];
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
                    userInfo2.portraitUri = [NSString stringWithFormat:@"http://192.168.0.209:90/%@",[ImageUrl changeUrl:list.userPortraitUrl]];
                    
                }
              return  completion(userInfo2);
            }
        }

    }else{
        NSString * nickname = [DEFAULTS objectForKey:@"nickname"];
        NSString * head = [DEFAULTS objectForKey:@"userPortraitUrl"];
        NSString * email = [DEFAULTS objectForKey:@"email"];
        //从服务器获取好友列表
        [AFNetData postDataWithUrl:FriendListURL andParams:@{@"userId":userID} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
            if (error) {
                NSSLog(@"获取好友列表失败：%@",error);
            }else{
                AddressDataBaseSingleton * single = [AddressDataBaseSingleton shareDatabase];
                NSArray * arr1 = [single searchDatabase];
                for (FriendsListModel * list in arr1) {
                    [[AddressDataBaseSingleton shareDatabase]deleteDatabase:list];
                }
                NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSNumber * code = jsonDic[@"code"];
                if ([code intValue] == 200) {
                    NSArray * arr = jsonDic[@"data"];
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
                            userInfo2.portraitUri = [NSString stringWithFormat:@"http://192.168.0.209:90/%@",[ImageUrl changeUrl:search.userPortraitUrl]];
                        }
                        return completion(userInfo2);
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
                group.portraitUri = [NSString stringWithFormat:@"http://192.168.0.209:90/%@",[ImageUrl changeUrl:model.groupPortraitUrl]];
              return  completion(group);
            }
        }
    }else{
        NSString * userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
        [AFNetData postDataWithUrl:GroupURL andParams:@{@"userId":userID} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
            if (error) {
                NSSLog(@"获取群组列表失败%@",error);
            }else{
                NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSNumber * code = jsonDic[@"code"];
                if ([code intValue] == 200) {
                    NSArray * arr = jsonDic[@"data"];
                    for (NSDictionary * dic in arr) {
                        GroupModel * model = [[GroupModel alloc]initWithDictionary:dic error:nil];
                        RCGroup * group = [RCGroup new];
                        group.groupId = model.groupId;
                        group.groupName = model.groupName;
                        group.portraitUri = [NSString stringWithFormat:@"http://192.168.0.209:90/%@",[ImageUrl changeUrl:model.groupPortraitUrl]];
                        return  completion(group);
                    }
                }
                
            }
        }];
    }
}

-(void)loginNet:(NSString *)phone andPassword:(NSString *)password{
    WeakSelf;
    NSDictionary * dic = @{@"mobile":phone,@"password":password};
    [AFNetData postDataWithUrl:LoginURL andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"登录失败：%@",error);
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                //成功
                NSDictionary * msg = jsonDic[@"data"];
                //保存用户数据
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:msg[@"userId"] forKey:@"userId"];
                //昵称
                [userDefaults setValue:msg[@"nickname"] forKey:@"nickname"];
                //头像
                NSString * url = [NSString stringWithFormat:@"http://192.168.0.209:90/%@",[ImageUrl changeUrl:msg[@"userPortraitUrl"]]];

                [userDefaults setValue:url forKey:@"userPortraitUrl"];
                //token
                [userDefaults setValue:msg[@"token"] forKey:@"token"];
                //sex
                NSNumber * sex = msg[@"sex"];
                [userDefaults setInteger:[sex integerValue] forKey:@"sex"];
                if (![msg[@"age"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setInteger:[msg[@"age"] integerValue]forKey:@"age"];
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
                if (![msg[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"recommendUserId"] forKey:@"recommendUserId"];
                }
                if (![msg[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"claimUserId"] forKey:@"claimUserId"];
                }
                [userDefaults synchronize];
                //设置当前用户的用户信息
                RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:msg[@"userId"] name:msg[@"nickname"] portrait:url];
                [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
                [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:msg[@"userId"]];
                [weakSelf loginMain];
            }else if ([code intValue] == 0){
                NSSLog(@"账号不存在！");
                [weakSelf login];
                
            }else if ([code intValue] == 1000){
                NSSLog(@"账号禁止登录！");
                [weakSelf login];
                
            }else if ([code intValue] == 1001){
                NSSLog(@"密码错误！");
                [weakSelf login];
                //传账号
                
            }else{
                NSSLog(@"登录失败！");
                
            }
        }
    }];
}
//登录融云服务器
-(void)loginRongServicer:(NSString *)token andPhone:(NSString *)phone andPassword:(NSString *)password{
    WeakSelf;
    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
        NSSLog(@"登录成功%@",userId);
        [weakSelf loginNet:phone andPassword:password];
    } error:^(RCConnectErrorCode status) {
        NSSLog(@"错误码：%ld",(long)status);
        //SDK自动重新连接
        [[RCIM sharedRCIM]setConnectionStatusDelegate:self];
    } tokenIncorrect:^{
        NSSLog(@"token错误");
        [weakSelf loginMain];
    }];
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == ConnectionStatus_Connected) {
            [RCIM sharedRCIM].connectionStatusDelegate = (id<RCIMConnectionStatusDelegate>)[UIApplication sharedApplication].delegate;
        } else if (status == ConnectionStatus_NETWORK_UNAVAILABLE) {
//            [weakSelf showMessage:@"网络进入异次元，请检查！"];
            [weakSelf loginMain];
        } else if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
//            [self showMessage:@"您的帐号在别的设备上登录，您被迫下线！"];
            [weakSelf login];
        } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
            NSSLog(@"Token无效");
//            [self showMessage:@"无法连接到服务器！"];
            [weakSelf loginMain];
        } else {
            NSLog(@"RCConnectErrorCode is %zd", status);
        }
    });
}
-(void)loginMain{
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        
    });
}
-(void)login{
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
        
    });
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
