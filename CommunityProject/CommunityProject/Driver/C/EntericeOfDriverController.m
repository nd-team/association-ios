//
//  EntericeOfDriverController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/4.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "EntericeOfDriverController.h"
#import "CheckDriverDetailController.h"

@interface EntericeOfDriverController ()

@end

@implementation EntericeOfDriverController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)lookProgressClick:(id)sender {
    NSInteger  driver = [DEFAULTS integerForKey:@"checkCar"];
    if (driver == 1) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Driver" bundle:nil];
        CheckDriverDetailController * comment = [sb instantiateViewControllerWithIdentifier:@"CheckDriverDetailController"];
        [self.navigationController pushViewController:comment animated:YES];
    }else{
        [self showMessage:@"您还不是司机，请先填写申请表申请成为司机"];
    }
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
@end
