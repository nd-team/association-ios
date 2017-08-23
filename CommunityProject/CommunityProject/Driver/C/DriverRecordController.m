//
//  DriverRecordController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "DriverRecordController.h"
#import "DriverRecordModel.h"
#import "DriverRecordCell.h"

#define DriverURL @"appapi/app/selectOrder"
@interface DriverRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;

@property (nonatomic,assign)int page;

@end

@implementation DriverRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的记录";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.page = 1;
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getDriverRecordListData];
    });
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [weakSelf getDriverRecordListData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [weakSelf getDriverRecordListData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
}
-(void)getDriverRecordListData{
    NSMutableDictionary * params = [NSMutableDictionary new];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userId forKey:@"page"];
    [params setValue:@"2" forKey:@"type"];
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,DriverURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"我的评价失败;%@",error);
            [weakSelf showMessage:@"服务器出问题咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            if (weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }else{
            if (!weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                if (arr.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    for (NSDictionary * dict in arr) {
                        DriverRecordModel * model = [[DriverRecordModel alloc]initWithDictionary:dict error:nil];
                        [self.dataArr addObject:model];
                        
                    }
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                if (weakSelf.tableView.mj_footer.isRefreshing) {
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
            });
        }
    }];

}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DriverRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DriverRecordCell"];
    cell.recordModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

@end
