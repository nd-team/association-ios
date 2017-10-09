//
//  MyLoadListController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyLoadListController.h"
#import "MyDownloadCell.h"
#import "VideoDatabaseSingleton.h"
#import "VideoDownloadListModel.h"
#import "EducationDetailController.h"
#import "SRDownloadManager.h"

@interface MyLoadListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MyLoadListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的下载";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    
    [self getDatabaseData];
}

-(void)getDatabaseData{
    //下载完成的数据
    [self.dataArr addObjectsFromArray:[[VideoDatabaseSingleton shareDatabase]searchDatabase]];
    if (self.dataArr.count != 0) {
        [self.tableView reloadData];
    }
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDownloadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyDownloadCell"];
    cell.videoModel = self.dataArr[indexPath.row];

    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    VideoDownloadListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Education" bundle:nil];
    EducationDetailController * education = [sb instantiateViewControllerWithIdentifier:@"EducationDetailController"];
    education.userId = userId;
    education.firstImg = [UIImage imageWithData:model.firstImage];
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CustomDownloadDirectory"];
    [SRDownloadManager sharedManager].saveFilesDirectory = fullPath;
    NSString *filePath = [[SRDownloadManager sharedManager]fileFullPathOfURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:model.videoUrl]]]];
    education.localUrl = [NSURL fileURLWithPath:filePath];
    education.nickname = model.nickname;
    education.headData = model.headImage;
    education.idStr = model.activesId;
    education.topic = model.title;
    education.time = model.time;
    education.content = model.content;
    if ([model.likesStatus isEqualToString:@"0"]) {
        education.isLove = NO;
    }else{
        education.isLove = YES;
    }
    if ([model.checkCollect isEqualToString:@"0"]) {
        education.isCollect = NO;
    }else{
        education.isCollect = YES;
    }
    education.isDown = YES;
    [self.navigationController pushViewController:education animated:YES];

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
        //删除数据 并删除文件
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [[VideoDatabaseSingleton shareDatabase]deleteDatabase:model.activesId];
        //删除单例数据 
        [[SRDownloadManager sharedManager]deleteVideo:[NSURL URLWithString:model.videoUrl]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];

        });
    }
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}


@end
