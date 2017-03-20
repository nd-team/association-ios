//
//  ChatDetailController.m
//  CommunityProject
//
//  Created by bjike on 17/3/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ChatDetailController.h"
//#import "ChatDetailCell.h"
#import <JrmfPacketKit/JrmfPacketKit.h>
#import "GroupActivityListController.h"

@interface ChatDetailController ()

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
    //注册cell RCMessageContent消息的基类

//    [self registerClass:[ChatDetailCell class] forMessageClass:[RCMessageContent class]];
    
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x121212);
    //右上角显示未读消息数
    self.enableUnreadMessageIcon = YES;
    //右下角显示新消息未读数
    self.enableNewComingMessageIcon = YES;
    //聊天界面背景色
    self.conversationMessageCollectionView.backgroundColor = UIColorFromRGB(0xeceef0);
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40) image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
   
    //+区域共有功能
    //照片1001 1002
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:0 image:[UIImage imageNamed:@"photos.png"] title:@"照片"];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:1];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];

    //视频聊天
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"videoChat.png"] title:@"视频聊天" atIndex:1 tag:100];

    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"location.png"] title:@"位置" atIndex:2 tag:101];
    //1004
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:3 image:[UIImage imageNamed:@"redPacket.png"] title:@"红包"];
    //单聊
    if (self.conversationType == 1) {
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40) image:@"person.png"  and:self Action:@selector(singlePersonChatClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
        //群聊
    }else{
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40) image:@"group.png"  and:self Action:@selector(groupChatClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"groupAct.png"] title:@"群活动" atIndex:4 tag:102];

        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"groupVote.png"] title:@"群投票" atIndex:5 tag:103];

        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"file.png"] title:@"文件" atIndex:6 tag:104];

    }
}
//点击更多操作
-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    if (tag == 100) {

    }else if(tag == 101){
        
    }else if(tag == 102){
       //群活动
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
        GroupActivityListController * act = [sb instantiateViewControllerWithIdentifier:@"GroupActivityListController"];
        act.groupID = self.targetId;
        [self.navigationController pushViewController:act animated:YES];

    }else if(tag == 103){
        
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
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        
        RCTextMessageCell * realCell = (RCTextMessageCell *)cell;
        UILabel * realLabel = (UILabel *)realCell.textLabel;
        realLabel.textColor = UIColorFromRGB(0x333333);
        realLabel.font = [UIFont systemFontOfSize:14];
        RCMessageModel * model = self.conversationDataRepository[indexPath.row];
        RCUserInfo * userInfo = model.userInfo;
        NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
        NSString * nickname = [userDef objectForKey:@"nickname"];
        //用户自己
        if ([userInfo.name isEqualToString:nickname]) {
            realCell.bubbleBackgroundView.image = [UIImage imageNamed:@"mineImg.png"];
        }else{
            realCell.bubbleBackgroundView.image = [UIImage imageNamed:@"othersImg.png"];
        }
    }
}
//点击电话号码回调 打电话
-(void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber model:(RCMessageModel *)model{
    NSURL * urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    [[UIApplication sharedApplication]openURL:urlStr];
}
@end
