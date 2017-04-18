//
//  LookBigImageController.h
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookBigImageController : UIViewController
//图片数据
@property (nonatomic,strong)NSArray * imageArr;
//点击的第几个 scrollView滑到第几个
@property (nonatomic,assign)NSInteger count;
@end
