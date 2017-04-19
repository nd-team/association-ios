//
//  CircleMessageController.m
//  CommunityProject
//
//  Created by bjike on 17/4/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CircleMessageController.h"
#import "CircleMessageCell.h"

@interface CircleMessageController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CircleMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x121212);
    self.navigationItem.title = @"消息";
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) titleColor:UIColorFromRGB(0x121212) font:16 andTitle:@"清空" and:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;

}
-(void)rightClick{
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleMessageCell"];
    
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // self.dataArr.count
    return 10;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //回复评论
    
}

@end
