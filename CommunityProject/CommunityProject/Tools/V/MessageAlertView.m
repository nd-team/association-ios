//
//  MessageAlertView.m
//  ISSP
//
//  Created by bjike on 16/10/21.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "MessageAlertView.h"

@implementation MessageAlertView

+(void)alertViewWithTitle:(NSString *)title message:(NSString *)msg buttonTitle:(NSArray *)buttonTitles Action:(actionBlock)actionBlock viewController:(UIViewController *)vc{
    
    MessageAlertView * alert = [self new];
    
    [alert alertViewWithTitle:title message:msg buttonTitle:buttonTitles Action:actionBlock viewController:vc];
    
}
-(void)alertViewWithTitle:(NSString *)title message:(NSString *)msg buttonTitle:(NSArray *)buttonTitles Action:(actionBlock)actionBlock viewController:(UIViewController *)vc{
        
    
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        int indexPath = 0;
        
        for (NSString * mes in buttonTitles) {
            
            [alertVC addAction:[UIAlertAction actionWithTitle:mes style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (actionBlock) {
                    actionBlock(indexPath);
                }
            }]];
            
            indexPath++;
        }
        
        [vc presentViewController:alertVC animated:YES completion:nil];
    
}

@end

