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
//https://sq.bjike.com http://192.168.0.104:90/appapi/app
#define NetURL @"https://sq.bjike.com/%@"
#define JAVAURL @"http://192.168.0.123:8080/%@"
//#define kisNilString(__String) (__String==nil || __String == (id)[NSNull null] || ![__String isKindOfClass:[NSString class]] || [__String isEqualToString:@""] || [[__String stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[__String lowercaseString] isEqualToString:@"nil"] || [[__String lowercaseString] isEqualToString:@"null"] || [[__String lowercaseString] isEqualToString:@"(null)"])
#endif /* CommonHeader_h */
