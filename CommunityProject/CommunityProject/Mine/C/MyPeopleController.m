//
//  MyPeopleController.m
//  CommunityProject
//
//  Created by bjike on 17/4/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyPeopleController.h"
#import "MyPeopleCell.h"
#import "MyPeopleDetailController.h"

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
    self.dataArr = @[@"亲人",@"同事",@"校友",@"同乡",@"同行"];
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
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    MyPeopleDetailController * people = [sb instantiateViewControllerWithIdentifier:@"MyPeopleDetailController"];
    people.name = self.dataArr[indexPath.row];
    people.type = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    [self.navigationController pushViewController:people animated:YES];
    
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];

}
- (IBAction)segClick:(id)sender {
    
    
}

@end
