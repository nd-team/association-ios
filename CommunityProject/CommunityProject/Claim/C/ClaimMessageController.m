//
//  ClaimMessageController.m
//  CommunityProject
//
//  Created by bjike on 17/5/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ClaimMessageController.h"
#import "OthersClaimSuccessCell.h"
#import "MeClaimSuccessCell.h"
#import "OthersClaimModel.h"

#define ConfirmURL @"appapi/app/claimConfirm"
#define ClaimMessageURL @"appapi/app/allNews"
@interface ClaimMessageController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataOneArr;
@property (nonatomic,strong)NSMutableArray * dataTwoArr;
@property (nonatomic,strong)NSIndexPath *selectPath;
@property (nonatomic,strong)NSString * userId;

@end

@implementation ClaimMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMessage];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getMessage];
    });
//接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(agreeOrDisagree:) name:@"AgreeClaimOther" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(agreeOrDisagree:) name:@"DisAgreeClaimOther" object:nil];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AgreeClaimOther" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DisAgreeClaimOther" object:nil];

}
-(void)agreeOrDisagree:(NSNotification *)nofi{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ConfirmURL] andParams:[nofi object] returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"确认认领、拒绝认领请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
               //刷新列表
                [weakSelf getMessage];
               
            }else if ([code intValue] == 1021){
                [weakSelf showMessage:@"用户已被认领"];
            }else if ([code intValue] == 1022){
                [weakSelf showMessage:@"用户未填写认领问题"];
            }
        }
    }];

}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)getMessage{
    WeakSelf;
    NSDictionary * params = @{@"userId":self.userId,@"type":@"1"};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ClaimMessageURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"消息数据请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            if (self.tableView.mj_header.isRefreshing||self.dataOneArr.count != 0 ||self.dataTwoArr.count != 0) {
                
                [weakSelf.dataOneArr removeAllObjects];
                [weakSelf.dataTwoArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * jsonDic = data[@"data"];
                //认领别人成功的数据
                NSArray * first = jsonDic[@"beClaim"];
                if (first.count != 0) {
                    for (NSDictionary * subDic in first) {
                        OthersClaimModel * claiming = [[OthersClaimModel alloc]initWithDictionary:subDic error:nil];
                        [self.dataTwoArr addObject:claiming];
                    }
                }
                NSArray * claimArr = jsonDic[@"claimMsg"];
                for (NSDictionary * subDic in claimArr) {
                    //别人认领当前用户成功的数据 （只有一条）
                    OthersClaimModel * other = [[OthersClaimModel alloc]initWithDictionary:subDic error:nil];
                    [self.dataOneArr addObject:other];
                    
                }
            }else{
                [weakSelf showMessage:@"加载认领消息失败，下拉刷新重试"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            });
            

        }
    }];

}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            OthersClaimSuccessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OthersClaimSuccessCell"];
            cell.otherModel = self.dataOneArr[indexPath.row];
            return cell;
        }
           
        default:
        {
            MeClaimSuccessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MeClaimSuccessCell"];
            cell.otherModel = self.dataTwoArr[indexPath.row];
            return cell;
        }
          
    }
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0://
            return self.dataOneArr.count;
        default://
            return self.dataTwoArr.count;
    }
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
-(NSMutableArray *)dataOneArr{
    if (!_dataOneArr) {
        _dataOneArr = [NSMutableArray new];
    }
    return _dataOneArr;
}
-(NSMutableArray *)dataTwoArr{
    if (!_dataTwoArr) {
        _dataTwoArr = [NSMutableArray new];
    }
    return _dataTwoArr;
}
@end
