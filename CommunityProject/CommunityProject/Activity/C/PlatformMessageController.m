//
//  PlatformMessageController.m
//  CommunityProject
//
//  Created by bjike on 17/5/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PlatformMessageController.h"
#import "AllMessageCell.h"
#import "AllMessageModel.h"

#define MessageURL @"appapi/app/allNews"

@interface PlatformMessageController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * userId;

@end

@implementation PlatformMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x121212);
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 40, 40) andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"AllMessageCell" bundle:nil] forCellReuseIdentifier:@"AllMessageCell"];
    self.userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMessage];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self getMessage];
}
-(void)getMessage{
    WeakSelf;
    NSDictionary * params = @{@"userId":self.userId,@"type":[NSString stringWithFormat:@"%d",self.type]};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MessageURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"消息数据请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            if (self.tableView.mj_header.isRefreshing) {
                [self.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * jsonArr = data[@"data"];
                for (NSDictionary * dic in jsonArr) {
                    AllMessageModel * model = [[AllMessageModel alloc]initWithDictionary:dic error:nil];
                    [self.dataArr addObject:model];
                }
            }else{
                [weakSelf showMessage:@"加载消息失败，下拉刷新重试"];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    }];
    
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AllMessageCell"];
    cell.model = self.dataArr[indexPath.row];
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

@end
