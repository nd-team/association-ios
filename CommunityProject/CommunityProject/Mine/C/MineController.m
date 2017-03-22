//
//  MineController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MineController.h"

@interface MineController ()

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ self.navigationController.navigationBar setShadowImage : [UIImage new]];
    //解决Bar与tableView对导航栏的影响
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nagivationBar.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
