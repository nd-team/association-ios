//
//  ApplicationVipController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/1.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ApplicationVipController.h"
#import "ApplicationPersonVipController.h"

@interface ApplicationVipController ()

@end

@implementation ApplicationVipController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请VIP";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;

}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)enterpriceClick:(id)sender {
}
- (IBAction)otherEnterpriseClick:(id)sender {
}
- (IBAction)personClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    ApplicationPersonVipController * vip = [sb instantiateViewControllerWithIdentifier:@"ApplicationPersonVipController"];
    [self.navigationController pushViewController:vip animated:YES];
}


@end
