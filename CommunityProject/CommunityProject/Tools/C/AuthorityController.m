//
//  AuthorityController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AuthorityController.h"

@interface AuthorityController ()
@property (weak, nonatomic) IBOutlet UIImageView *oneImage;
@property (weak, nonatomic) IBOutlet UIImageView *twoImage;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;

@end

@implementation AuthorityController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"谁可以看";
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"完成" andLeft:15 andTarget:self Action:@selector(finishAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem * backItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x10DB9F) font:16 andTitle:@"取消" andLeft:-15 andTarget:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.oneBtn.selected = YES;
    if (self.oneBtn.selected) {
        [self common:NO];
    }
}
-(void)finishAction{
    if (self.oneBtn.selected) {
        switch (self.type) {
            case 1:
                self.delegate.authStr = @"公开";
                break;
            case 2:
                self.sendDelegate.authStr = @"公开";
                break;
            case 3:
                self.trafficDelegate.authStr = @"公开";
                break;
            default:
                break;
        }
        
        
    }else{
        switch (self.type) {
            case 1:
                self.delegate.authStr = @"非公开";
                break;
            case 2:
                self.sendDelegate.authStr = @"非公开";
                break;
            case 3:
                self.trafficDelegate.authStr = @"非公开";
                break;
            default:
                break;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)publicClick:(id)sender {
    self.oneBtn.selected = YES;
    if (self.oneBtn.selected) {
        self.twoBtn.selected = NO;
        [self common:NO];
    }
}
- (IBAction)noPublicClick:(id)sender {
    self.twoBtn.selected = YES;
    if (self.twoBtn.selected) {
        self.oneBtn.selected = NO;
        [self common:YES];
    }
    
}
-(void)common:(BOOL)isHidden{
    self.oneImage.hidden = isHidden;
    self.twoImage.hidden = !isHidden;
}

@end
