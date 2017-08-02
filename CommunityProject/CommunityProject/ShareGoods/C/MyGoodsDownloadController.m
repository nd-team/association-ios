//
//  MyGoodsDownloadController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyGoodsDownloadController.h"
#import "MyGoodsDownloadCell.h"
#import "MyGoodsDownloadModel.h"
#import "GoodsListDatabaseSingleton.h"

@interface MyGoodsDownloadController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MyGoodsDownloadController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"下载";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;

    //下载完成的数据
    [self.dataArr addObjectsFromArray:[[GoodsListDatabaseSingleton shareDatabase]searchDatabase]];
    if (self.dataArr.count != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGoodsDownloadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyGoodsDownloadCell"];
    cell.downloadModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
//阅读
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
