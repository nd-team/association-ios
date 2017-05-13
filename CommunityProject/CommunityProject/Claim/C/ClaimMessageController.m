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

@interface ClaimMessageController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataOneArr;
@property (nonatomic,strong)NSMutableArray * dataTwoArr;
@property (nonatomic,strong)NSMutableArray * dataThreeArr;
@property (nonatomic,strong)NSIndexPath *selectPath;

@end

@implementation ClaimMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMessage];
    }];
    [self getMessage];

}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)getMessage{
    
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
            
            return cell;
        }
           
        case 1:
        {
            MeClaimSuccessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MeClaimSuccessCell"];
            
            return cell;
        }
          
        default:
        {
            WaitClaimCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WaitClaimCell"];
            
            return cell;
        }
    }
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0://self.dataOneArr.count
            return 1;
        case 1://self.dataTwoArr.count
            return 1;
        default://self.dataThreeArr.count
            return 1;
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
