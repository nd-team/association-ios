//
//  MyPeopleController.m
//  CommunityProject
//
//  Created by bjike on 17/4/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyPeopleController.h"
#import "MyPeopleCell.h"

@interface MyPeopleController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSArray * dataArr;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCon;

@end

@implementation MyPeopleController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[@"同事",@"校友",@"同乡",@"亲人"];
    [self.tableView reloadData];
}

#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyPeopleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyPeopleCell"];
    cell.nameLabel.text = self.dataArr[indexPath.row];
    
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];

}
- (IBAction)segClick:(id)sender {
    
    
}

@end
