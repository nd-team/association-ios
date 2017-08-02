//
//  MyJoinPublicController.m
//  CommunityProject
//
//  Created by bjike on 17/5/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyJoinPublicController.h"
#import "PublicListModel.h"
#import "PublicListCell.h"

#define MyJoinURL @"appapi/app/selectJoinCommonwealActives"
@interface MyJoinPublicController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MyJoinPublicController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PublicListCell" bundle:nil] forCellReuseIdentifier:@"MyJoinPublicListCell"];
    self.navigationItem.title = @"我参与的公益";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x121212);
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 40, 40) andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getPublicListData];
    }];
    self.tableView.mj_footer.hidden = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getPublicListData];
    });

    
}
-(void)getPublicListData{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    NSDictionary * params = @{@"userId":userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MyJoinURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"公益活动数据请求失败：%@",error);
            [weakSelf showMessage:@"服务器出差错咯！"];
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
                for (NSDictionary * dict in arr) {
                    PublicListModel * model = [[PublicListModel alloc]initWithDictionary:dict error:nil];
                    [self.dataArr addObject:model];
                }
            }else{
                [weakSelf showMessage:@"加载公益活动数据失败"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            });
           
        }
    }];
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView-delegate and DataSources
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicListModel * model = self.dataArr[indexPath.row];
    if (model.height != 0) {
        return model.height;
    }
    return 366;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyJoinPublicListCell"];
    cell.publicModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
    
}
@end
