//
//  ChatDetailCell.h
//  CommunityProject
//
//  Created by bjike on 17/3/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface ChatDetailCell : RCMessageBaseCell


/*!
 消息发送者的用户头像
 */
@property(nonatomic, strong) RCloudImageView *portraitImageView;

/*!
 消息发送者的用户名称
 */
@property(nonatomic, strong) UILabel *nicknameLabel;

/*!
 消息内容的View
 */
@property(nonatomic, strong) RCContentView *messageContentView;

/*!
 背景View
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;
/*!
 显示发送状态的View
 
 @discussion 其中包含messageFailedStatusView子View。
 */
//@property(nonatomic, strong) UIView *statusContentView;

/*!
 显示发送失败状态的View
 */
//@property(nonatomic, strong) UIButton *messageFailedStatusView;

/*!
 消息发送指示View
 */
//@property(nonatomic, strong) UIActivityIndicatorView *messageActivityIndicatorView;

/*!
 消息内容的View的宽度
 */
@property(nonatomic, readonly) CGFloat messageContentViewWidth;

/*!
 显示的用户头像形状
 */
@property(nonatomic, assign, setter=setPortraitStyle:) RCUserAvatarStyle portraitStyle;

/*!
 显示消息已阅读状态的View
 */
//@property(nonatomic, strong) UIView *messageHasReadStatusView;

/*!
 显示是否消息回执的Button
 
 @discussion 仅在群组和讨论组中显示
 */
@property(nonatomic, strong) UIButton *receiptView;

/*!
 消息阅读人数的Label
 
 @discussion 仅在群组和讨论组中显示
 */
@property(nonatomic, strong) UILabel *receiptCountLabel;

/*!
 显示消息发送成功状态的View
 */
@property(nonatomic, strong) UIView *messageSendSuccessStatusView;

/*!
 设置当前消息Cell的数据模型
 
 @param model 消息Cell的数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;

/*!
 更新消息发送状态
 
 @param model 消息Cell的数据模型
 */
- (void)updateStatusContentView:(RCMessageModel *)model;
/*!
 根据消息内容获取显示的尺寸
 
 @param message 消息内容
 
 @return 显示的View尺寸
 */
+ (CGSize)getBubbleBackgroundViewSize:(RCMessage *)message;

@end
