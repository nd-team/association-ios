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
//
@interface ChatDetailController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,RCChatSessionInputBarControlDelegate,RCLocationPickerViewControllerDelegate,RCRealTimeLocationObserver,
RealTimeLocationStatusViewDelegate>
@property (nonatomic,strong) UIView * backView;

@property (nonatomic,strong)UIWindow * window;
@property(nonatomic, weak) id<RCRealTimeLocationProxy> realTimeLocation;
@property(nonatomic, strong) RealTimeLocationStatusView *realTimeLocationStatusView;

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
    //右上角显示未读消息数
    self.enableUnreadMessageIcon = YES;
    //右下角显示新消息未读数
    self.enableNewComingMessageIcon = YES;
    //开启语音连续播放
    self.enableContinuousReadUnreadVoice = YES;
    //聊天界面背景色
    self.conversationMessageCollectionView.backgroundColor = UIColorFromRGB(0xeceef0);
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
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
    //照片100 101 102 PLUGIN_BOARD_ITEM_VIDEO_VOIP_TAG
//    [self.chatSessionInputBarControl.pluginBoardView removeAllItems];
//    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:0 image:[UIImage imageNamed:@"photos.png"] title:@"照片"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemWithTag:1001 image:[UIImage imageNamed:@"photos.png"] title:@"照片"];
//    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"photos.png"] title:@"照片" atIndex:0 tag:PLUGIN_BOARD_ITEM_ALBUM_TAG];
//    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"camera.png"] title:@"拍摄" atIndex:1 tag:PLUGIN_BOARD_ITEM_CAMERA_TAG];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:1 image:[UIImage imageNamed:@"camera.png"] title:@"拍摄"];

    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"videoChat.png"] title:@"视频聊天" atIndex:4 tag:PLUGIN_BOARD_ITEM_VIDEO_VOIP_TAG];

    //红包PLUGIN_BOARD_ITEM_EVA_TAG 103
//    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"redPacket.png"] title:@"红包" atIndex:3 tag:PLUGIN_BOARD_ITEM_EVA_TAG];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:3 image:[UIImage imageNamed:@"redPacket.png"] title:@"红包"];

    //位置PLUGIN_BOARD_ITEM_LOCATION_TAG 104
//    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"location.png"] title:@"位置" atIndex:4 tag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:2 image:[UIImage imageNamed:@"location.png"] title:@"位置"];

    //单聊
    if (self.conversationType == 1) {
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:-30 image:@"person.png"  and:self Action:@selector(singlePersonChatClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
        //群聊
    }else{
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:-30 image:@"group.png"  and:self Action:@selector(groupChatClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"groupAct.png"] title:@"群活动" atIndex:5 tag:105];

        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"groupVote.png"] title:@"群投票" atIndex:6 tag:106];
//107
        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"file.png"] title:@"文件" atIndex:7 tag:PLUGIN_BOARD_ITEM_FILE_TAG];

    }
    
    [self setImage];

    [self.chatSessionInputBarControl.additionalButton setImage:[UIImage imageNamed:@"addtion.png"] forState:UIControlStateNormal];
    [self.chatSessionInputBarControl.additionalButton setImage:[UIImage imageNamed:@"addtion.png"] forState:UIControlStateHighlighted];
    /*
    //emoji_hover
    [self.chatSessionInputBarControl.emojiButton setImage:[UIImage imageNamed:@"emoji_hover.png"] forState:UIControlStateNormal];
    [self.chatSessionInputBarControl.emojiButton setImage:[UIImage imageNamed:@"emoji_hover.png"] forState:UIControlStateHighlighted];
     */
    self.chatSessionInputBarControl.inputTextView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    self.chatSessionInputBarControl.inputTextView.layer.borderWidth = 0;
}

//点击更多操作
-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    switch (tag) {
        case 1001:
            //照片
            [self showPickerUI:1001];
            break;
        case 1002:
            //照相机
            [self showPickerUI:1002];
            break;
            
        case PLUGIN_BOARD_ITEM_VIDEO_VOIP_TAG:
            //视频
            
            break;
        case PLUGIN_BOARD_ITEM_LOCATION_TAG:
            //位置
        {
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
        case PLUGIN_BOARD_ITEM_FILE_TAG:
            
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
            
            break;
        default:
            
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
    MyLocationViewController * location = [MyLocationViewController new];
    location.delegate = self;
    [self.navigationController pushViewController:location animated:YES];
}
-(void)singlePersonChatClick{
    
}
-(void)groupChatClick{
    
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    RCMessageModel * model = self.conversationDataRepository[indexPath.row];
    RCUserInfo * userInfo = model.userInfo;
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell * realCell = (RCTextMessageCell *)cell;
        UILabel * realLabel = (UILabel *)realCell.textLabel;
        realLabel.textColor = UIColorFromRGB(0x333333);
        realLabel.font = [UIFont systemFontOfSize:14];
        if (model.messageDirection == 1) {
            realCell.bubbleBackgroundView.image = [UIImage imageNamed:@"mineImg.png"];
        }else{
            realCell.bubbleBackgroundView.image = [UIImage imageNamed:@"othersImg.png"];
            
        }
    }
    else if ([cell isMemberOfClass:[RCTipMessageCell class]]){
        //提示信息label
        RCTipMessageCell * otherCell = (RCTipMessageCell *)cell;
        UILabel * label = (UILabel *)otherCell.tipMessageLabel;
        label.font = [UIFont systemFontOfSize:11];
        label.backgroundColor = UIColorFromRGB(0xb5b7b8);
        label.attributedText = [ImageUrl changeTextColor:otherCell.tipMessageLabel.text andRangeStr:userInfo.name];

    }else if ([cell isMemberOfClass:[RCFileMessageCell class]]){
        RCFileMessageCell * fileCell = (RCFileMessageCell *)cell;
        if (model.messageDirection == 1) {
            fileCell.bubbleBackgroundView.image = [UIImage imageNamed:@"mineImg.png"];
        }else{
            fileCell.bubbleBackgroundView.image = [UIImage imageNamed:@"othersImg.png"];
        }
    }
    else if ([cell isMemberOfClass:[RCVoiceMessageCell class]]){
        RCVoiceMessageCell * voiceCell = (RCVoiceMessageCell *)cell;
        if (model.messageDirection == 1) {
            voiceCell.bubbleBackgroundView.image = [UIImage imageNamed:@"mineImg.png"];
            voiceCell.voiceDurationLabel.textColor = UIColorFromRGB(0xffffff);
            voiceCell.playVoiceView.image = [UIImage sd_animatedGIFNamed:@"record1"];
            voiceCell.voiceUnreadTagView.image = [UIImage imageNamed:@"record-1"];
            voiceCell.playVoiceView.image = [UIImage imageNamed:@"record-1"];

        }else{
            voiceCell.bubbleBackgroundView.image = [UIImage imageNamed:@"othersImg.png"];
            voiceCell.voiceDurationLabel.textColor = UIColorFromRGB(0xbbbbbb);
        }
    }//图文混合
    else if ([cell isMemberOfClass:[RCRichContentMessageCell class]]){
        RCRichContentMessageCell * textCell = (RCRichContentMessageCell *)cell;
        if (model.messageDirection == 1) {
            textCell.bubbleBackgroundView.image = [UIImage imageNamed:@"mineImg.png"];
        }else{
            textCell.bubbleBackgroundView.image = [UIImage imageNamed:@"othersImg.png"];
        }
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
        RealTimeLocationStartCell * startCell = (RealTimeLocationStartCell *)cell;
        if (model.messageDirection == 1) {
            startCell.bubbleBackgroundView.image = [UIImage imageNamed:@"mineImg.png"];
        }else{
            startCell.bubbleBackgroundView.image = [UIImage imageNamed:@"othersImg.png"];
        }
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
//点击电话号码回调 打电话
-(void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber model:(RCMessageModel *)model{
    NSURL * urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    [[UIApplication sharedApplication]openURL:urlStr];
}

#pragma mark-拍照和照片
-(void)showPickerUI:(int) tagValue{
    
    UIImagePickerController * picker = [UIImagePickerController new];
    
    picker.delegate = self;
    
    if (tagValue == 1002) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    [self presentViewController:picker animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    
    RCImageMessage * image = [RCImageMessage messageWithImage:originalImage];
    [self sendMediaMessage:image pushContent:@"对方处于离线状态哦~" appUpload:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
 
/*
-(void)chatInputBar:(RCChatSessionInputBarControl *)chatInputBar shouldChangeFrame:(CGRect)frame{
    CGFloat height = KMainScreenHeight-50;
    if (self.chatSessionInputBarControl.recordButton.hidden&&self.chatSessionInputBarControl.frame.origin.y != height) {
        [self setImage];
    }
//    if (self.chatSessionInputBarControl.frame.origin.y == (KMainScreenHeight-50) || self.chatSessionInputBarControl.frame.origin.y == (KMainScreenHeight-50-258)) {
//        [self.chatSessionInputBarControl.emojiButton setBackgroundImage:[UIImage imageNamed:@"smail.png"] forState:UIControlStateNormal];
//    }
//    unsigned int count = 0;
//    Ivar * members = class_copyIvarList([chatInputBar.emojiButton class], &count);
//    for (int i = 0; i<count; i++) {
//        Ivar var = members[i];
//        const char * memberAddress = ivar_getName(var);
//        const char * memberType = ivar_getTypeEncoding(var);
//        NSString * test = [NSString stringWithUTF8String:memberType];
//        if ([test containsString:NSStringFromClass([UIImageView class])]) {
//            UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.chatSessionInputBarControl.emojiButton.imageView.frame];
//            imageView.image = [UIImage imageNamed:@"smail.png"];
//            Ivar m_address = members[i];
//            object_setIvar(self.chatSessionInputBarControl.emojiButton, m_address, imageView);
//            [self.chatSessionInputBarControl.emojiButton setBackgroundImage:[UIImage imageNamed:@"smail.png"] forState:UIControlStateNormal];
//            NSSLog(@"%s",memberAddress);
//            break;
//        }
//    }
    [self scrollToBottomAnimated:YES];

}
*/
-(void)setImage{
    [self.chatSessionInputBarControl.switchButton setImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateNormal];
    [self.chatSessionInputBarControl.switchButton setImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateHighlighted];
}
-(void)presentViewController:(UIViewController *)viewController functionTag:(NSInteger)functionTag{
    
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
@end
