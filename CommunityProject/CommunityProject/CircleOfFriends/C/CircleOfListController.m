//
//  CircleOfListController.m
//  CommunityProject
//
//  Created by bjike on 17/4/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CircleOfListController.h"
#import "CircleCell.h"
#import "CircleListModel.h"

#define CircleListURL @"appapi/app/selectFriendsCircle"
@interface CircleOfListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)int page;
@end

@implementation CircleOfListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleCell" bundle:nil] forCellReuseIdentifier:@"CircleCell"];
    self.page = 1;
    WeakSelf;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getList:[NSString stringWithFormat:@"%d",self.page]];
    }];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getList:@"1"];
    }];
    [self getList:@"1"];
}
-(void)getList:(NSString *)status{
    WeakSelf;
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    NSDictionary * params = @{@"userId":userId,@"status":status,@"page":[NSString stringWithFormat:@"%d",self.page]};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CircleListURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"朋友圈：%@",error);
        }else{
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }else{
                NSNumber * code = data[@"code"];
                if ([code intValue] == 200) {
                    NSArray * arr = data[@"data"];
                    NSSLog(@"%@",arr);
                    for (NSDictionary * dic in arr) {
                        CircleListModel * list = [[CircleListModel alloc]initWithDictionary:dic error:nil];
                        [weakSelf.dataArr addObject:list];
                    }
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_header endRefreshing];
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
            }
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCell"];
    cell.circleModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    CircleCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    CircleListModel * model = self.dataArr[indexPath.row];
    CGFloat labelHeight = 0;
    CGFloat imageHeight = 0;
    //判断是否有文字
    if (model.content.length == 0) {
        labelHeight = 0;
        cell.conHeightCons.constant = 0;
    }else{
        cell.contentLabel.text = model.content;
        NSSLog(@"%@",cell.contentLabel.text);

        //取到label的高度
        CGSize size = [cell.contentLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        labelHeight = size.height;
        NSSLog(@"%f==%f",size.height,labelHeight);
        cell.conHeightCons.constant = labelHeight;
    }
    if (model.images.count == 0) {
        cell.collHeightCons.constant = 0;
    }else if(model.images.count <= 3){
        cell.collHeightCons.constant = 103;
    }else if(model.images.count <= 6){
        cell.collHeightCons.constant = 206;
    }else if(model.images.count <= 9){
        cell.collHeightCons.constant = 309;
    }
    [cell layoutIfNeeded];
    imageHeight = cell.collHeightCons.constant;
    NSSLog(@"%f===%f",imageHeight,cell.collHeightCons.constant);
    CGFloat height = 120+labelHeight+imageHeight;
    NSSLog(@"%f",height);
     */
    return 500;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入详情
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
