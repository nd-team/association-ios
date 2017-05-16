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
#import "WaitClaimCell.h"
#import "OthersClaimModel.h"

#define ConfirmURL @"appapi/app/claimConfirm"
#define ClaimMessageURL @"appapi/app/allNews"
@interface ClaimMessageController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataOneArr;
@property (nonatomic,strong)NSMutableArray * dataTwoArr;
@property (nonatomic,strong)NSMutableArray * dataThreeArr;
@property (nonatomic,strong)NSIndexPath *selectPath;
@property (nonatomic,strong)NSString * userId;

@end

@implementation ClaimMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 62;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMessage];
    }];
    [self getMessage];
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
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
               //刷新列表
                [weakSelf getMessage];
               
            }else if ([code intValue] == 100){
                NSSLog(@"用户已被认领");
            }else if ([code intValue] == 101){
                NSSLog(@"用户未填写认领问题");
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
        if (error) {
            NSSLog(@"消息数据请求失败：%@",error);
        }else{
            if (self.tableView.mj_header.isRefreshing||self.dataOneArr.count != 0 ||self.dataTwoArr.count != 0||self.dataThreeArr.count != 0) {
                
                [weakSelf.dataOneArr removeAllObjects];
                [weakSelf.dataTwoArr removeAllObjects];
                [weakSelf.dataThreeArr removeAllObjects];

            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * jsonDic = data[@"data"];
                NSSLog(@"%@",jsonDic);
                
                //别人认领当前用户成功的数据 （只有一条）
                NSDictionary * first = jsonDic[@"beClaim"];
                if (first.count != 0) {
                    OthersClaimModel * other = [[OthersClaimModel alloc]initWithDictionary:first error:nil];
                    [self.dataOneArr addObject:other];
                }
                NSArray * claimArr = jsonDic[@"claimMsg"];
                for (NSDictionary * subDic in claimArr) {
                    //认领别人成功的数据

                    if ([subDic[@"status"] intValue] == 1) {
                        OthersClaimModel * claiming = [[OthersClaimModel alloc]initWithDictionary:subDic error:nil];
                        [self.dataTwoArr addObject:claiming];
                    }else{
                        //须同意的认领数据
                        OthersClaimModel * wait = [[OthersClaimModel alloc]initWithDictionary:subDic error:nil];
                        [self.dataThreeArr addObject:wait];
                    }
                }
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }
        }
    }];

}
#pragma mark - tableView-delegate and DataSources
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 62;
         case 1:
            return 62;
        default:
        {
            WaitClaimCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.downHeightCons.constant == 0) {
                return 62;
            }else{
                return 105;
            }
        }
           
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            OthersClaimSuccessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OthersClaimSuccessCell"];
            cell.otherModel = self.dataOneArr[indexPath.row];
            return cell;
        }
           
        case 1:
        {
            MeClaimSuccessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MeClaimSuccessCell"];
            cell.otherModel = self.dataTwoArr[indexPath.row];
            return cell;
        }
          
        default:
        {
            WaitClaimCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WaitClaimCell"];
            cell.userId = self.userId;
            cell.tableView = self.tableView;
            cell.dataThreeArr = self.dataThreeArr;
            cell.otherModel = self.dataThreeArr[indexPath.row];
            cell.block = ^(){
                [self.tableView reloadData];
            };
            return cell;
        }
    }
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0://
            return self.dataOneArr.count;
        case 1://
            return self.dataTwoArr.count;
        default://
            return self.dataThreeArr.count;
    }
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
-(NSMutableArray *)dataThreeArr{
    if (!_dataThreeArr) {
        _dataThreeArr = [NSMutableArray new];
    }
    return _dataThreeArr;
}
@end
