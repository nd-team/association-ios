//
//  CommonHeader.h
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h

/*
 * 屏幕宽度
 */
#define KMainScreenWidth  [UIScreen mainScreen].bounds.size.width
/*
 *屏幕高度
 */
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height
//RGB颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define WeakSelf __weak __typeof(self) weakSelf = self

#define DEFAULTS [NSUserDefaults standardUserDefaults]

#define NetURL @"http://192.168.0.101:90/%@"
#endif /* CommonHeader_h */
