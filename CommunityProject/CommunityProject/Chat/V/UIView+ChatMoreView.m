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
@end
