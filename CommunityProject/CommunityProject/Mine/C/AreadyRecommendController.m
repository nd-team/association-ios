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
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
//                NSSLog(@"%@",arr);
                for (NSDictionary * dic in arr) {
                    AlreadyRecommendModel * recommend = [[AlreadyRecommendModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:recommend];
                }
                [weakSelf.tableView reloadData];
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
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

@end
