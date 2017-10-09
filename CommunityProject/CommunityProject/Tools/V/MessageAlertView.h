//
//  MessageAlertView.h
//  ISSP
//
//  Created by bjike on 16/10/21.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>
//AlertView两个按钮的封装iOS8.0以及iOS8.0以下

typedef void(^actionBlock)(NSInteger indexpath);
@interface MessageAlertView : NSObject<UIAlertViewDelegate>

+(void)alertViewWithTitle:(NSString *)title message:(NSString *)msg buttonTitle:(NSArray *)buttonTitles Action:(actionBlock)actionBlock viewController:(UIViewController *)vc;

@end
