//
//  AreadyRecommendController.m
//  CommunityProject
//
//  Created by bjike on 17/4/26.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AreadyRecommendController.h"
#import "AlreadyRecommendCell.h"
#import "AlreadyRecommendModel.h"

#define RecommendURL @"appapi/app/allRecommendsUsers"
@interface AreadyRecommendController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation AreadyRecommendController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"已推荐人";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self getRecommendData];
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getRecommendData];
    }];
    self.tableView.mj_footer.hidden = YES;
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getRecommendData{
    WeakSelf;
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    NSDictionary * params = @{@"userId":userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,RecommendURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"已推荐人请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            if (weakSelf.dataArr.count != 0 || weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    AlreadyRecommendModel * recommend = [[AlreadyRecommendModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:recommend];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            }else{
                [weakSelf showMessage:@"加载已推荐人失败"];
            }
            
        }
    }];

}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlreadyRecommendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AlreadyRecommendCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
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
