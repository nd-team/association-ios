//
//  ChatDetailController.m
//  CommunityProject
//
//  Created by bjike on 17/3/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ChatDetailController.h"
#import "GroupActivityListController.h"
#import <UIImage+GIF.h>
#import "MyLocationViewController.h"
#import "UIView+ChatMoreView.h"
#import "RealTimeLocationEndCell.h"
#import "RealTimeLocationStartCell.h"
#import "RealTimeLocationStatusView.h"
#import "RealTimeLocationViewController.h"
#import "FriendDetailController.h"
#import "UnknownFriendDetailController.h"
#import "SetPersonController.h"
#import "GroupMemberInfoController.h"
#import "GroupHostInfoController.h"
#import "VoteListController.h"

#define FriendDetailURL @"appapi/app/selectUserInfo"
//判断是否是好友
#define TESTURL @"appapi/app/CheckMobile"

#define GroupInfoURL @"appapi/app/groupInfo"
@interface ChatDetailController ()<RCLocationPickerViewControllerDelegate,RCRealTimeLocationObserver,
RealTimeLocationStatusViewDelegate,MapLocationPickerViewControllerDelegate>
@property (nonatomic,strong) UIView * backView;

@property (nonatomic,strong)UIWindow * window;
@property(nonatomic, weak) id<RCRealTimeLocationProxy> realTimeLocation;
@property(nonatomic, strong) RealTimeLocationStatusView *realTimeLocationStatusView;
//用户ID
@property (nonatomic,copy)NSString * userId;
@property (nonatomic,strong)UIBarButtonItem * rightItemOne;
@property (nonatomic,strong)UIBarButtonItem * rightItemTwo;

@end

@implementation ChatDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
}
-(void)setUI{
    //本地存图片
//self.enableSaveNewPhotoToLocalSystem
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x121212);
    //设置聊天室历史消息20条
    self.defaultHistoryMessageCountOfChatRoom = 20;
    //右上角显示未读消息数
    self.enableUnreadMessageIcon = YES;
    //右下角显示新消息未读数
    self.enableNewComingMessageIcon = YES;
    //开启语音连续播放
    self.enableContinuousReadUnreadVoice = YES;
    //聊天界面背景色
    self.conversationMessageCollectionView.backgroundColor = UIColorFromRGB(0xeceef0);
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    /*******************实时地理位置共享***************/
    [self registerClass:[RealTimeLocationStartCell class]
        forMessageClass:[RCRealTimeLocationStartMessage class]];
    [self registerClass:[RealTimeLocationEndCell class]
        forMessageClass:[RCRealTimeLocationEndMessage class]];
    WeakSelf;
    [[RCRealTimeLocationManager sharedManager]
     getRealTimeLocationProxy:self.conversationType
     targetId:self.targetId
     success:^(id<RCRealTimeLocationProxy> realTimeLocation) {
         weakSelf.realTimeLocation = realTimeLocation;
         [weakSelf.realTimeLocation addRealTimeLocationObserver:self];
         [weakSelf updateRealTimeLocationStatus];
     }
     error:^(RCRealTimeLocationErrorCode status) {
         NSLog(@"get location share failure with code %d", (int)status);
     }];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];

    //如何在会话页面插入提醒消息
    /*
    RCInformationNotificationMessage *warningMsg =
    [RCInformationNotificationMessage
     notificationWithMessage:@"请不要轻易给陌生人汇钱！" extra:nil];
    BOOL saveToDB = YES;  //是否保存到数据库中
    RCMessage *savedMsg ;
    if (saveToDB) {
        savedMsg = [[RCIMClient sharedRCIMClient]
                    insertOutgoingMessage:self.conversationType targetId:self.targetId
                    sentStatus:SentStatus_SENT content:warningMsg];
    } else {
        savedMsg =[[RCMessage alloc] initWithType:self.conversationType
                                         targetId:self.targetId direction:MessageDirection_SEND messageId:-1
                                          content:warningMsg];//注意messageId要设置为－1
    }
    [self appendAndDisplayMessage:savedMsg];
*/
    //+区域共有功能
    //照片 PLUGIN_BOARD_ITEM_ALBUM_TAG
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:0 image:[UIImage imageNamed:@"photos.png"] title:@"照片"];
     //PLUGIN_BOARD_ITEM_CAMERA_TAG
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:1 image:[UIImage imageNamed:@"camera.png"] title:@"拍摄"];

    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"videoChat.png"] title:@"视频聊天" atIndex:4 tag:PLUGIN_BOARD_ITEM_VIDEO_VOIP_TAG];

    //位置PLUGIN_BOARD_ITEM_LOCATION_TAG
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:2 image:[UIImage imageNamed:@"location.png"] title:@"位置"];
    //红包PLUGIN_BOARD_ITEM_EVA_TAG
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:3 image:[UIImage imageNamed:@"redPacket.png"] title:@"红包"];
    //单聊
    if (self.conversationType == 1) {
        self.rightItemOne = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:-30 image:@"person.png"  and:self Action:@selector(singlePersonChatClick)];
        self.navigationItem.rightBarButtonItem = self.rightItemOne;
        //群聊
    }else if(self.conversationType == 3){
        self.rightItemTwo = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:-30 image:@"group.png"  and:self Action:@selector(groupChatClick)];
        self.navigationItem.rightBarButtonItem = self.rightItemTwo;
        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"groupAct.png"] title:@"群活动" atIndex:5 tag:105];

        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"groupVote.png"] title:@"群投票" atIndex:6 tag:106];
//107
        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"file.png"] title:@"文件" atIndex:7 tag:PLUGIN_BOARD_ITEM_FILE_TAG];

    }
    self.chatSessionInputBarControl.inputTextView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    self.chatSessionInputBarControl.inputTextView.layer.borderWidth = 0;
    //发送那栏空白view颜色改变
    self.chatSessionInputBarControl.emojiBoardView.backgroundColor = UIColorFromRGB(0xeceef0);
}
-(void)leftBarButtonItemPressed:(id)sender{
    [super leftBarButtonItemPressed:sender];
    [self.navigationController popViewControllerAnimated:YES];

}
//点击更多操作
-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    switch (tag) {            
        case PLUGIN_BOARD_ITEM_VIDEO_VOIP_TAG:
            //视频
            [MessageAlertView alertViewWithTitle:@"温馨提示" message:@"此功能正在完善" buttonTitle:@[@"确定"] Action:^(NSInteger indexpath) {
                NSSLog(@"消息提示");
            } viewController:self];
            break;
        case PLUGIN_BOARD_ITEM_LOCATION_TAG:
            //位置
        { //只有单聊和讨论组可位置共享
            if (self.conversationType == 1) {
                WeakSelf;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf showBackViewUI];
                });
            }else{
                [self pushLocationUI];
            }
            
        }
            break;
        case 105:
        {
            //群活动
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
            GroupActivityListController * act = [sb instantiateViewControllerWithIdentifier:@"GroupActivityListController"];
            act.groupID = self.targetId;
            [self.navigationController pushViewController:act animated:YES];
            
        }
            break;
           case 106:
            //群投票
        {
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
            VoteListController * voteList = [sb instantiateViewControllerWithIdentifier:@"VoteListController"];
            voteList.groupId = self.targetId;
            voteList.groupName = self.title;
            [self.navigationController pushViewController:voteList animated:YES];

        }
            break;
        default:
            //红包，文件，相机和相册
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];

            break;
    }
}

-(void)showBackViewUI{
    
    self.backView = [UIView locationViewFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) andTarget:self andAction:@selector(buttonAction:)];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewAction)];
    
    [self.backView addGestureRecognizer:tap];
    
    [self.window addSubview:self.backView];
    
}
-(void)hideViewAction{
    
    self.backView.hidden = YES;
    
}
-(void)buttonAction:(UIButton *)btn{
    switch (btn.tag) {
        case 41:
            [self showRealTimeLocationViewController];
            self.backView.hidden = YES;
            break;
        case 42:
            //发送位置
        {
            [self pushLocationUI];
            self.backView.hidden = YES;
        }
            break;
           //共享
        default:
        {
            self.backView.hidden = YES;
        }
            break;
    }

}
/*******************实时地理位置共享***************/
- (void)showRealTimeLocationViewController {
    RealTimeLocationViewController *lsvc =
    [[RealTimeLocationViewController alloc] init];
    lsvc.realTimeLocationProxy = self.realTimeLocation;
    if ([self.realTimeLocation getStatus] ==
        RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        [self.realTimeLocation joinRealTimeLocation];
    } else if ([self.realTimeLocation getStatus] ==
               RC_REAL_TIME_LOCATION_STATUS_IDLE) {
        [self.realTimeLocation startRealTimeLocation];
    }
    [self.navigationController presentViewController:lsvc
                                            animated:YES
                                          completion:^{
                                              
                                          }];
}
- (void)updateRealTimeLocationStatus {
    if (self.realTimeLocation) {
        [self.realTimeLocationStatusView updateRealTimeLocationStatus];
        __weak typeof(&*self) weakSelf = self;
        NSArray *participants = nil;
        switch ([self.realTimeLocation getStatus]) {
            case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
                [self.realTimeLocationStatusView updateText:@"你正在共享位置"];
                break;
            case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
            case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
                participants = [self.realTimeLocation getParticipants];
                if (participants.count == 1) {
                    NSString *userId = participants[0];
                    [weakSelf.realTimeLocationStatusView
                     updateText:[NSString
                                 stringWithFormat:@"user<%@>正在共享位置", userId]];
                    [[RCIM sharedRCIM]
                     .userInfoDataSource
                     getUserInfoWithUserId:userId
                     completion:^(RCUserInfo *userInfo) {
                         if (userInfo.name.length) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [weakSelf.realTimeLocationStatusView
                                  updateText:[NSString stringWithFormat:
                                              @"%@正在共享位置",
                                              userInfo.name]];
                             });
                         }
                     }];
                } else {
                    if (participants.count < 1)
                        [self.realTimeLocationStatusView removeFromSuperview];
                    else
                        [self.realTimeLocationStatusView
                         updateText:[NSString stringWithFormat:@"%d人正在共享地理位置",
                                     (int)participants.count]];
                }
                break;
            default:
                break;
        }
    }
}

-(void)pushLocationUI{
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"WeChat" bundle:nil];
    MyLocationViewController * location = [sb instantiateViewControllerWithIdentifier:@"MyLocationViewController"];
    location.delegate = self;
    location.isAct = NO;
    [self.navigationController pushViewController:location animated:YES];
}
-(void)singlePersonChatClick{
    //进入个人设置
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    SetPersonController * friend = [sb instantiateViewControllerWithIdentifier:@"SetPersonController"];
    friend.friendId = self.targetId;
    friend.conversationType = self.conversationType;
    friend.nickname = self.title;
    [self.navigationController pushViewController:friend animated:YES];

}
//进入群信息
-(void)groupChatClick{
    self.rightItemTwo.enabled = NO;
    //请求群信息
    [self postGroupInfomation];
}
-(void)postGroupInfomation{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,GroupInfoURL] andParams:@{@"groupId":self.targetId,@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取群组信息失败：%@",error);
            weakSelf.rightItemTwo.enabled = YES;

        }else{
            NSNumber * code = data[@"code"];
//            NSSLog(@"%@",data);
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                int  role = [[NSString stringWithFormat:@"%@",dict[@"role"]]intValue];
                if (role == 0) {
                    //群员
                    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
                    GroupMemberInfoController * member = [sb instantiateViewControllerWithIdentifier:@"GroupMemberInfoController"];
                    member.groupId = self.targetId;
                    member.groupName = dict[@"groupName"];
                    if (![dict[@"noticeContent"] isKindOfClass:[NSNull class]]) {
                        member.publicNotice = [NSString stringWithFormat:@"%@",dict[@"noticeContent"]];
                    }
                    member.nickname = [NSString stringWithFormat:@"%@",dict[@"groupNickName"]];
                    member.userId = self.userId;
                    member.headUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:[NSString stringWithFormat:@"%@",dict[@"groupPortraitUrl"]]]];
                        member.hobby = [NSString stringWithFormat:@"%@",dict[@"hobbyName"]];              
                    if ([dict[@"hobbyName"] isEqualToString:@""]) {
                        member.isGroup = YES;
                    }else{
                        member.isGroup = NO;
                    }
                    [self.navigationController pushViewController:member animated:YES];

                }else{
                    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
                    GroupHostInfoController * host = [sb instantiateViewControllerWithIdentifier:@"GroupHostInfoController"];
                    host.groupId = self.targetId;
                    host.groupName = dict[@"groupName"];
                    if (![dict[@"noticeContent"] isKindOfClass:[NSNull class]]) {
                        host.publicNotice = [NSString stringWithFormat:@"%@",dict[@"noticeContent"]];
                    }
                    host.nickname = [NSString stringWithFormat:@"%@",dict[@"groupNickName"]];
                    host.userId = self.userId;
                    host.headUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:[NSString stringWithFormat:@"%@",dict[@"groupPortraitUrl"]]]];
                    if (role == 2) {
                        host.isHost = YES;
                        host.hostId = self.userId;
                    }else{
                        host.isHost = NO;
                    }
                        host.hobby = [NSString stringWithFormat:@"%@",dict[@"hobbyName"]];
                    
                    if ([dict[@"hobbyName"] isEqualToString:@""]) {
                        host.isGroup = YES;
                    }else{
                        host.isGroup = NO;
                    }
                    [self.navigationController pushViewController:host animated:YES];
                }
                weakSelf.rightItemTwo.enabled = YES;
            }
        }
    }];
}
-(void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    RCMessageModel * model = self.conversationDataRepository[indexPath.row];
    RCUserInfo * userInfo = model.userInfo;
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell * realCell = (RCTextMessageCell *)cell;
        UILabel * realLabel = (UILabel *)realCell.textLabel;
        realLabel.textColor = UIColorFromRGB(0x333333);
        realLabel.font = [UIFont systemFontOfSize:14];
    }
    else if ([cell isMemberOfClass:[RCTipMessageCell class]]){
        //提示信息label
        RCTipMessageCell * otherCell = (RCTipMessageCell *)cell;
        UILabel * label = (UILabel *)otherCell.tipMessageLabel;
        label.font = [UIFont systemFontOfSize:11];
        label.backgroundColor = UIColorFromRGB(0xb5b7b8);
        label.attributedText = [ImageUrl changeTextColor:otherCell.tipMessageLabel.text andColor:UIColorFromRGB(0xffffff) andRangeStr:userInfo.name andChangeColor:UIColorFromRGB(0xed0d0d)];
    }else if ([cell isMemberOfClass:[RCFileMessageCell class]]){
//        RCFileMessageCell * fileCell = (RCFileMessageCell *)cell;

    }
    else if ([cell isMemberOfClass:[RCVoiceMessageCell class]]){
        RCVoiceMessageCell * voiceCell = (RCVoiceMessageCell *)cell;
        if (model.messageDirection == 1) {
            voiceCell.voiceDurationLabel.textColor = UIColorFromRGB(0xffffff);
        }else{
            voiceCell.voiceDurationLabel.textColor = UIColorFromRGB(0xbbbbbb);
        }
    }//图文混合
    else if ([cell isMemberOfClass:[RCRichContentMessageCell class]]){
        RCRichContentMessageCell * textCell = (RCRichContentMessageCell *)cell;
        UILabel * titleLabel = (UILabel *)textCell.titleLabel;
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:14];
        UILabel * detailLabel = (UILabel *)textCell.digestLabel;
        detailLabel.textColor = UIColorFromRGB(0x666666);
        detailLabel.font = [UIFont systemFontOfSize:11];
    }
    else if ([cell isMemberOfClass:[RCLocationMessageCell class]]){
        RCLocationMessageCell * locationCell = (RCLocationMessageCell *)cell;
        UILabel * label = locationCell.locationNameLabel;
        label.textColor = UIColorFromRGB(0x333333);
        label.font =[UIFont systemFontOfSize:13];
        if (model.messageDirection == 1) {
            label.backgroundColor = UIColorFromRGB(0x3ED74C);
        }else{
            label.backgroundColor = UIColorFromRGB(0xffffff);
        }
    }
    else if ([cell isMemberOfClass:[RealTimeLocationStartCell class]]){
//        RealTimeLocationStartCell * startCell = (RealTimeLocationStartCell *)cell;

    }
    else if ([cell isMemberOfClass:[RealTimeLocationEndCell class]]){
        RealTimeLocationEndCell * endCell = (RealTimeLocationEndCell *)cell;
        UILabel * label = endCell.tipMessageLabel;
        label.font = [UIFont systemFontOfSize:11];
        label.backgroundColor = UIColorFromRGB(0xb5b7b8);
    }
    //提示时间label
    UILabel *label = (UILabel *)cell.messageTimeLabel;
    label.textColor = UIColorFromRGB(0xffffff);
    label.backgroundColor = UIColorFromRGB(0xb5b7b8);
    label.font = [UIFont systemFontOfSize:11];
}
//-(RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent{
//    return messageContent;
//}
//-(void)sendMediaMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent appUpload:(BOOL)appUpload{
//    
//}
//-(void)cancelUploadMedia:(RCMessageModel *)model{
//    
//}
-(void)locationPicker:(RCLocationPickerViewController *)locationPicker didSelectLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName mapScreenShot:(UIImage *)mapScreenShot{
    RCLocationMessage * locationMessage = [RCLocationMessage messageWithLocationImage:mapScreenShot location:location locationName:locationName];
    [self sendMessage:locationMessage pushContent:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - RealTimeLocationStatusViewDelegate
- (void)onJoin {
    [self showRealTimeLocationViewController];
}
- (RCRealTimeLocationStatus)getStatus {
    return [self.realTimeLocation getStatus];
}

- (void)onShowRealTimeLocationView {
    [self showRealTimeLocationViewController];
}
#pragma mark-点击头像的回调
-(void)didTapCellPortrait:(NSString *)userId{
    //私聊
    if (self.conversationType == 1) {
        [self pushFriendId:YES andUserId:userId];
       //群聊
    }else if (self.conversationType == 3){
        //请求网络 判断是否是好友 是就跳转好友发消息界面，否就跳转加好友界面
        //把请求回来的数据传参给下个界面
        //用户自己
        if ([userId isEqualToString:self.userId]) {
            [self pushFriendId:YES andUserId:userId];
        }else{
            [self testUserIsFriendMobile:userId];
  
        }
    }
    
}
//判断是否是好友
-(void)testUserIsFriendMobile:(NSString *)selectUserId{
    WeakSelf;

    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,TESTURL] andParams:@{@"userId":self.userId,@"mobile":selectUserId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"判断是否为好友失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                NSNumber * status = dict[@"status"];
                NSSLog(@"%@",data);
                if ([status intValue] == 1) {
                    //好友
                    [weakSelf pushFriendId:YES andUserId:selectUserId];
                }else{
                    //过滤系统账号
                    if (![dict[@"mobile"] isEqualToString:@"00001"]) {
                        [weakSelf pushFriendId:NO andUserId:selectUserId];
                    }
                }
            }
        }
    }];
}
//好友界面
-(void)pushFriendId:(BOOL)isFriend andUserId:(NSString *)userId{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendDetailURL] andParams:@{@"userId":[DEFAULTS objectForKey:@"userId"],@"otherUserId":userId,@"status":@"1"} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"好友详情请求失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
//                NSSLog(@"%@",dict);
                if (isFriend) {
                    //传参
                    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
                    FriendDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"FriendDetailController"];
                    detail.friendId = userId;
                    //请求网络数据获取用户详细资料
                    detail.name = dict[@"nickname"];
                    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]];
                    detail.url = encodeUrl;
                    if (![dict[@"age"] isKindOfClass:[NSNull class]]) {
                        detail.age = dict[@"age"];
                    }
                    if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                        detail.sex = [dict[@"sex"]intValue];
                    }
                    if (![dict[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                        detail.recomendPerson = dict[@"recommendUserId"];
                    }
                    if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                        detail.email = dict[@"email"];
                    }
                    if (![dict[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                        detail.lingPerson = dict[@"claimUserId"];
                    }
                    if (![dict[@"mobile"] isKindOfClass:[NSNull class]]) {
                        detail.phone = dict[@"mobile"];
                    }
                    if (![dict[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                        detail.contribute = [NSString stringWithFormat:@"%@",dict[@"contributionScore"]];
                    }
                    if (![dict[@"birthday"] isKindOfClass:[NSNull class]]) {
                        detail.birthday = dict[@"birthday"];
                    }
                    if (![dict[@"creditScore"] isKindOfClass:[NSNull class]]) {
                        detail.prestige = [NSString stringWithFormat:@"%@",dict[@"creditScore"]];
                    }
                    if (![dict[@"address"] isKindOfClass:[NSNull class]]) {
                        detail.areaStr = dict[@"address"];
                    }
                    NSInteger status = [[NSString stringWithFormat:@"%@",dict[@"status"]]integerValue];
                    //好友
                    NSString * name;
                    if (status == 1) {
                        if (![dict[@"friendNickname"] isEqualToString:@""]) {
                            detail.display = dict[@"friendNickname"];
                            name = dict[@"friendNickname"];
                        }
                        else{
                            detail.name = dict[@"nickname"];
                            name = dict[@"nickname"];
                            
                        }
                    }else if (status == 2){
                        //自己
                        detail.name = dict[@"nickname"];
                        name = dict[@"nickname"];
                    }
                    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:userId name:name portrait:encodeUrl];
                    [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:userId];
                    [weakSelf.navigationController pushViewController:detail animated:YES];
                }else{
                    //不是好友
                    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
                    UnknownFriendDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"UnknownFriendDetailController"];
                    detail.friendId = userId;
                    //请求网络数据获取用户详细资料
                    detail.name = dict[@"nickname"];
                    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]];
                    detail.url = encodeUrl;
                    if (![dict[@"age"] isKindOfClass:[NSNull class]]) {
                        detail.age = dict[@"age"];
                    }
                    if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                        detail.sex = [dict[@"sex"]intValue];
                    }
                    if (![dict[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                        detail.recomendPerson = dict[@"recommendUserId"];
                    }
                    if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                        detail.email = dict[@"email"];
                    }
                    if (![dict[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                        detail.lingPerson = dict[@"claimUserId"];
                    }
                    if (![dict[@"mobile"] isKindOfClass:[NSNull class]]) {
                        detail.phone = dict[@"mobile"];
                    }
                    if (![dict[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                        detail.contribute = [NSString stringWithFormat:@"%@",dict[@"contributionScore"]];
                    }
                    if (![dict[@"birthday"] isKindOfClass:[NSNull class]]) {
                        detail.birthday = dict[@"birthday"];
                    }
                    if (![dict[@"creditScore"] isKindOfClass:[NSNull class]]) {
                        detail.prestige = [NSString stringWithFormat:@"%@",dict[@"creditScore"]];
                    }
                    if (![dict[@"address"] isKindOfClass:[NSNull class]]) {
                        detail.areaStr = dict[@"address"];
                    }
                    detail.isRegister = YES;
                    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:userId name:dict[@"nickname"] portrait:encodeUrl];
                    [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:userId];
                    [weakSelf.navigationController pushViewController:detail animated:YES];

                }
            }
        }
    }];
  
}
//点击电话号码回调 打电话
-(void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber model:(RCMessageModel *)model{
    NSURL * urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    [[UIApplication sharedApplication]openURL:urlStr];
}
//位置发送实现功能 :(MyLocationViewController *)locationPicker d
-(void)locationDidSelectLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName mapScreenShot:(UIImage *)mapScreenShot{
    RCLocationMessage *locationMessage =
    [RCLocationMessage messageWithLocationImage:mapScreenShot
                                       location:location
                                   locationName:locationName];
    [self sendMessage:locationMessage pushContent:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
