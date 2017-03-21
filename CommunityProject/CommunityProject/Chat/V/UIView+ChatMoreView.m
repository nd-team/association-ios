//
//  UIView+ChatMoreView.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "UIView+ChatMoreView.h"
#import "UIButton+button.h"

@implementation UIView (ChatMoreView)
+(UIView *)createViewFrame:(CGRect)frame andTarget:(id)target andSel:(SEL)action{
    NSArray *titleArr = @[@"聊天大厅",@"通讯录",@"发现",@"添加朋友/群",@"新建群聊",@"群列表",@"消息"];

    UIView * view = [[UIView alloc]initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.frame];
    imageView.image = [UIImage imageNamed:@"addMore.png"];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    for (int i = 0; i<titleArr.count; i++) {
        UIButton * button = [UIButton CreateTitleButtonWithFrame:CGRectMake(0, i*33, 113, 33) andBackgroundColor:UIColorFromRGB(0x1AE2A7)  titleColor:UIColorFromRGB(0x444343) font:14 andTitle:titleArr[i]];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        button.tag = 20+i;
        [imageView addSubview:button];
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(1.5, (i+1)*32, 111, 1)];
        lineView.backgroundColor = UIColorFromRGB(0x444343);
        [imageView addSubview:lineView];
    }
    return view;
}
@end
