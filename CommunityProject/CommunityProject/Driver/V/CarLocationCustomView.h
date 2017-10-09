//
//  CarLocationCustomView.h
//  CommunityProject
//
//  Created by bjike on 2017/8/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CarLocationCustomView : MAAnnotationView
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@end
