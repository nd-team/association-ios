//
//  ManagerDownloadController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ManagerDownloadController.h"
#import "ManagerDownloadCell.h"
#import "VideoDownloadListModel.h"
#import "VideoDatabaseSingleton.h"


@interface ManagerDownloadController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation ManagerDownloadController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理下载";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);

   
    //数据源从数据库里获取
    [self.dataArr addObjectsFromArray:@[]];
    if (self.dataArr.count != 0) {
        [self.tableView reloadData];
    }

}


#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManagerDownloadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerDownloadCell"];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    [cell configureVideo:self.dataArr[indexPath.row]];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//左滑删除功能
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoDownloadListModel * model = self.dataArr[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除数据
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [[VideoDatabaseSingleton shareDatabase]deleteDatabase:model.activesId];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}


@end
