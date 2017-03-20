//
//  CreateActivityController.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CreateActivityController.h"

@interface CreateActivityController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *actImage;

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *startTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *endTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *endTF;
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
@property (weak, nonatomic) IBOutlet UITextField *limitTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImage;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbHeightContraints;

@end

@implementation CreateActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)moreClick:(id)sender {
}
- (IBAction)backClick:(id)sender {
}
- (IBAction)sendClick:(id)sender {
}

@end
