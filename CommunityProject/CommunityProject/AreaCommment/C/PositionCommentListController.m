//
//  PositionCommentListController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PositionCommentListController.h"
#import "PositionCommentListCell.h"
#import "PositionCommentListModel.h"
#import "PositionCommentDetailController.h"

#define CommentList @"comment/list"

@interface PositionCommentListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * userId;

@end

@implementation PositionCommentListController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [DEFAULTS objectForKey:@"userId"];

    self.navigationItem.title = @"网友点评";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PositionCommentListCell" bundle:nil] forCellReuseIdentifier:@"PositionMoreCommentListCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 277;

    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCommentListData];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf getCommentListData];
    });
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getCommentListData{
    WeakSelf;
    [JavaGetNet getDataWithUrl:[NSString stringWithFormat:JAVAURL,CommentList] andParams:@{@"pointId":self.pointId} andHeader:self.userId getBlock:^(NSURLResponse *response, NSError *error, id data) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSSLog(@"评论列表失败%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            if (weakSelf.dataArr.count != 0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 0) {
                if ([[jsonDic allKeys] containsObject:@"data"]) {
                    NSArray * arr = jsonDic[@"data"];
                    NSSLog(@"%@",arr);
                    for (NSDictionary * dict in arr) {
                        PositionCommentListModel * model = [[PositionCommentListModel alloc]initWithDictionary:dict error:nil];
                        [weakSelf.dataArr addObject:model];
                    }
                }
            }else{
                [weakSelf showMessage:@"获取评论失败！"];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PositionCommentListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PositionMoreCommentListCell"];
    cell.commentModel = self.dataArr[indexPath.row];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PositionCommentListModel * model = self.dataArr[indexPath.row];
    if (model.height != 0) {
        return 300;
    }
    return 277;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
//评论详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PositionCommentListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Position" bundle:nil];
    PositionCommentDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"PositionCommentDetailController"];
    detail.headUrl = model.headPath;
    detail.nickname = model.nickname;
    detail.time = model.createTime;
    detail.score = model.scoreType;
    detail.comment = model.content;
    [detail.collectArr addObjectsFromArray: model.images];
    detail.isLove = model.alreadyLikes;
    detail.commentId = [NSString stringWithFormat:@"%zi",model.idStr];
    [self.navigationController pushViewController:detail animated:YES];

}

-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
