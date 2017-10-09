//
//  WordsDetailController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "WordsDetailController.h"

@interface WordsDetailController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@end

@implementation WordsDetailController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.name;
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"取消" andLeft:-15 andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"保存" andLeft:15 andTarget:self Action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.placeHolderLabel.text = self.place;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBoard)];
    [self.view addGestureRecognizer:tap];
}
-(void)hiddenBoard{
    [self.contentTV resignFirstResponder];
}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveInfo{
    [self.delegate.objectiveMArr addObject:self.contentTV.text];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
