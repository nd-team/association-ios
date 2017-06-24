//
//  MyEducationController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyEducationController.h"
#import "EducationListModel.h"
#import "EducationListCell.h"
#import "EducationDetailController.h"

#define MyEducationURL @"appapi/app/selectMyVideo"
@interface MyEducationController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MyEducationController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"EducationListCell" bundle:nil] forCellReuseIdentifier:@"MyCollectionCell"];
//    self.page = 1;
    self.segControl.selectedSegmentIndex = 0;
    NSDictionary * params = @{@"userId":self.userId};
    WeakSelf;
    /*
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getEducationListData];
    }];
     */
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
        if (self.segControl.selectedSegmentIndex == 0) {
            //我的教学
            [weakSelf getEducationListData:params];

        }else{
            //收藏教学
            [weakSelf getEducationListData:@{@"userId":self.userId,@"type":@"9"}];

        }
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getEducationListData:params];
    });
    
}
-(void)getEducationListData:(NSDictionary *)params{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MyEducationURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"三分钟教学：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            if (!weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
//                if (arr.count == 0) {
//                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                }else{
                    for (NSDictionary * dic in arr) {
                        EducationListModel * list = [[EducationListModel alloc]initWithDictionary:dic error:nil];
                        [weakSelf.dataArr addObject:list];
                    }
//                }
            }else{
                [weakSelf showMessage:@"加载三分钟教学失败，下拉刷新重试！"];
                
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            //                    [weakSelf.tableView.mj_footer endRefreshing];

        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EducationListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectionCell"];
    cell.listModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EducationListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Education" bundle:nil];
    EducationDetailController * education = [sb instantiateViewControllerWithIdentifier:@"EducationDetailController"];
    education.userId = self.userId;
    education.firstUrl = model.imageUrl;
    education.videoUrl = model.videoUrl;
    education.nickname = model.nickname;
    education.headUrl = model.userPortraitUrl;
    education.idStr = model.idStr;
    education.topic = model.title;
    education.time = model.time;
    education.content = model.content;
    education.loveNum = model.likes;
    education.commentNum = model.commentNumber;
    education.collNum = model.collectionNumber;
    education.downloadNum = model.downloadNumber;
    education.shareNum = model.shareNumber;
    if (model.likesStatus == 0) {
        education.isLove = NO;
    }else{
        education.isLove = YES;
    }
    if (model.checkCollect == 0) {
        education.isCollect = NO;
    }else{
        education.isCollect = YES;
    }
    [self.navigationController pushViewController:education animated:YES];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)segClick:(id)sender {
    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
    if (self.segControl.selectedSegmentIndex == 0) {
       //我的教学
        [self getEducationListData:@{@"userId":self.userId}];
 
    }else{
       //收藏教学
        [self getEducationListData:@{@"userId":self.userId,@"type":@"9"}];

    }
}
-(void)showMessage:(NSString *)msg{
    UIView * msgView = [UIView showViewTitle:msg];
    [self.view addSubview:msgView];
    [UIView animateWithDuration:1.0 animations:^{
        msgView.frame = CGRectMake(20, KMainScreenHeight-150, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
        //完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
