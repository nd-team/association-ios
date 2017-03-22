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
@end
