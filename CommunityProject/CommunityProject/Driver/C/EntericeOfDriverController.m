//
//  EntericeOfDriverController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/4.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "EntericeOfDriverController.h"

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

- (IBAction)applicationDriverClick:(id)sender {
    
}
- (IBAction)lookProgressClick:(id)sender {
    
}
- (IBAction)backClick:(id)sender {
}

@end
