//
//  ChatDetailController.m
//  CommunityProject
//
//  Created by bjike on 17/3/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ChatDetailController.h"
#import "GroupActivityListController.h"
#import "ChangeImageView.h"

@interface ChatDetailController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)ChangeImageView *changeView;

@end

@implementation ChatDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
   
    //+区域共有功能
    //照片1001 1002

    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:0 image:[UIImage imageNamed:@"photos.png"] title:@"照片"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:1 image:[UIImage imageNamed:@"camera.png"] title:@"拍摄"];
    //视频聊天1003
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:2 image:[UIImage imageNamed:@"videoChat.png"] title:@"视频聊天"];
    //红包1004
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:3 image:[UIImage imageNamed:@"redPacket.png"] title:@"红包"];
    //位置
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"location.png"] title:@"位置" atIndex:4 tag:100];
    //单聊
    if (self.conversationType == 1) {
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:-30 image:@"person.png"  and:self Action:@selector(singlePersonChatClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
        //群聊
    }else{
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:-30 image:@"group.png"  and:self Action:@selector(groupChatClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"groupAct.png"] title:@"群活动" atIndex:5 tag:101];

        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"groupVote.png"] title:@"群投票" atIndex:6 tag:102];

        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"file.png"] title:@"文件" atIndex:7 tag:103];

    }
    
    [self.chatSessionInputBarControl.additionalButton setImage:[UIImage imageNamed:@"addtion.png"] forState:UIControlStateNormal];
    self.changeView = [[ChangeImageView alloc]initWithFrame:self.chatSessionInputBarControl.frame withContainerView:self.chatSessionInputBarControl controlType:0 controlStyle:0 defaultInputType:0];
    [self.changeView containerViewWillAppear];
    self.chatSessionInputBarControl.inputTextView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    self.chatSessionInputBarControl.inputTextView.layer.borderWidth = 0;
}
//点击更多操作
-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    //视频
    if (tag == 1003) {

    }//位置
    else if(tag == 100){
        
    }//红包
    else if(tag == 1004){
       
    }
    else if(tag == 101){
       //群活动
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
        GroupActivityListController * act = [sb instantiateViewControllerWithIdentifier:@"GroupActivityListController"];
        act.groupID = self.targetId;
        [self.navigationController pushViewController:act animated:YES];

    }else if(tag == 102){
        //群投票
        
    }
    else if(tag == 103){
        //文件
        
    }else if(tag == 1001){
        //照片
        [self showPickerUI:1001];
    }else if(tag == 1002){
        //照相机
        [self showPickerUI:1002];
    }
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
        }else{
            voiceCell.bubbleBackgroundView.image = [UIImage imageNamed:@"othersImg.png"];
        }
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
-(void)sendMessage{
}
@end
