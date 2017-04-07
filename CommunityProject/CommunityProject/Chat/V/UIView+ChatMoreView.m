//
//  UIView+ChatMoreView.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "UIView+ChatMoreView.h"

@implementation UIView (ChatMoreView)
+(UIView *)createViewFrame:(CGRect)frame andTarget:(id)target andSel:(SEL)action{
    NSArray *titleArr = @[@"聊天大厅",@"通讯录",@"发现",@"添加朋友/群",@"新建群聊",@"群列表",@"消息"];
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    for (int i = 0; i<titleArr.count; i++) {
        UIButton * button = [UIButton CreateTitleButtonWithFrame:CGRectMake(3, i*33, 107, 33) andBackgroundColor:UIColorFromRGB(0x1AE2A7)  titleColor:UIColorFromRGB(0x444343) font:14 andTitle:titleArr[i]];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = UIColorFromRGB(0x1AE2A7);
        button.tag = 20+i;
        [view addSubview:button];
    }
    for (int i = 0; i<titleArr.count-1; i++) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(3, (i+1)*33, 107, 1)];
        lineView.backgroundColor = UIColorFromRGB(0x0f8d68);
        [view addSubview:lineView];
    }
    return view;
}
+(UIView *)locationViewFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)action{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    UIButton * button1  = [UIButton CreateMyButtonWithFrame:CGRectMake((KMainScreenWidth-330)/2, KMainScreenHeight-60, 330, 50) Image:@"whiteButton.png" SelectedImage:@"whiteButton.png" title:@"取消" color:UIColorFromRGB(0x333333) SelectColor:UIColorFromRGB(0x333333) font:17 and:target Action:action];
    button1.tag = 40;
    [view addSubview:button1];
    UIButton * button2  = [UIButton CreateMyButtonWithFrame:CGRectMake((KMainScreenWidth-330)/2, KMainScreenHeight-125, 330, 50) Image:@"whiteButton.png" SelectedImage:@"whiteButton.png" title:@"实时共享位置" color:UIColorFromRGB(0x333333) SelectColor:UIColorFromRGB(0x333333) font:17 and:target Action:action];
    button2.tag = 41;
    [view addSubview:button2];

    UIButton * button3  = [UIButton CreateMyButtonWithFrame:CGRectMake((KMainScreenWidth-330)/2, KMainScreenHeight-180, 330, 50) Image:@"whiteButton.png" SelectedImage:@"whiteButton.png" title:@"发送位置" color:UIColorFromRGB(0x333333) SelectColor:UIColorFromRGB(0x333333) font:17 and:target Action:action];
    button3.tag = 42;
    [view addSubview:button3];
    
    return view;
}
+(UIView *)sureViewTitle:(NSString *)title andTag:(CGFloat)tag andTarget:(id)target andAction:(SEL)action{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    UIView * smallView = [UIView new];
    smallView.backgroundColor = [UIColor whiteColor];
    smallView.layer.cornerRadius = 5;
    [view addSubview:smallView];
    [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(view);
        make.width.mas_equalTo(215);
        make.height.mas_equalTo(128);
    }];
    UILabel * label = [UILabel new];
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    label.text = title;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [smallView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(smallView);
        make.top.equalTo(smallView).offset(39.5);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(100);
    }];
    UIButton * sureBtn = [UIButton CreateMyButtonWithFrame:CGRectZero Image:@"greenSure" SelectedImage:@"greenSure" title:@"确定" color:UIColorFromRGB(0x333333) SelectColor:UIColorFromRGB(0x333333) font:15 and:target Action:action];
    sureBtn.tag = tag;
    [smallView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(smallView);
        make.left.equalTo(smallView);
        make.width.mas_equalTo(215);
        make.height.mas_equalTo(40);
    }];
    UIButton * closeBtn = [UIButton CreateImageButtonWithFrame:CGRectZero Image:@"close" SelectedImage:@"close" and:target Action:action];
    [view addSubview:closeBtn];
    closeBtn.tag = tag+1;
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sureBtn.mas_top).offset(-73);
        make.right.equalTo(view).offset(-(KMainScreenWidth-215)/2+15);
        make.width.height.mas_equalTo(30);
    }];
    return view;
}
+(UIView *)timeViewTag:(CGFloat)tag andTarget:(id)target andAction:(SEL)action{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    UIView * bottomView = [UIView new];
    bottomView.backgroundColor = UIColorFromRGB(0xebebeb);
    [view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KMainScreenWidth);
        make.height.mas_equalTo(230.5);
        make.bottom.equalTo(view);
        make.left.equalTo(view);
    }];
    UIButton * finishBtn = [UIButton CreateTitleButtonWithFrame:CGRectZero andBackgroundColor:UIColorFromRGB(0xebebeb) titleColor:UIColorFromRGB(0x27a9ec) font:17 andTitle:@"完成"];
    [finishBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    finishBtn.tag = tag;
    [bottomView addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.right.equalTo(bottomView);
        make.height.mas_equalTo(40);
        make.top.equalTo(bottomView);
    }];
    UIDatePicker * datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    datePicker.tag = tag+1;
    [bottomView addSubview:datePicker];
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KMainScreenWidth);
        make.height.mas_equalTo(190.5);
        make.bottom.equalTo(bottomView);
        make.left.equalTo(bottomView);
    }];
    
    return view;
}
@end
