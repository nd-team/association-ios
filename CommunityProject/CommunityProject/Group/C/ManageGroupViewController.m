//
//  ManageGroupViewController.m
//  CommunityProject
//
//  Created by bjike on 17/3/31.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ManageGroupViewController.h"
#import "ChooseFriendsController.h"

@interface ManageGroupViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewOne;
@end

@implementation ManageGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"群管理";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;

}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chooseClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    ChooseFriendsController * choose = [sb instantiateViewControllerWithIdentifier:@"ChooseFriendsController"];
    choose.groupId = self.groupId;
    choose.name = @"选择副群主";
    choose.dif = 1;
    choose.hostId = self.hostId;
    [self.navigationController pushViewController:choose animated:YES];

}

@end
