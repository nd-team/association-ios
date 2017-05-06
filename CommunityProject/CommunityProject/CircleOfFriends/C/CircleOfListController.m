//
//  CircleOfListController.m
//  CommunityProject
//
//  Created by bjike on 17/4/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CircleOfListController.h"
#import "CircleCell.h"
#import "ActivityRecommendController.h"
#import "CircleCommentController.h"
#import "CircleMessageController.h"

#define CircleListURL @"appapi/app/selectFriendsCircle"
#define ZanURL @"appapi/app/userPraise"

@interface CircleOfListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)int page;
@property (nonatomic,assign)CGFloat height;
@property (weak, nonatomic) IBOutlet UIButton *msgBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightCons;

@end

@implementation CircleOfListController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
    if (self.isRef) {
        self.page = 1;
//        [self.dataArr insertObject:self.model atIndex:0];
//        不受影响但是耗费性能 同时间别人发的不能刷新到
//        [self.tableView reloadData];
        [self.dataArr removeAllObjects];
        [self getList];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleCell" bundle:nil] forCellReuseIdentifier:@"CircleCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    //初始化传参过来的消息数据
    [self.tableView beginUpdates];
    CGRect frame = self.headerView.frame;
    if (self.msgArr.count == 0) {
        self.viewHeightCons.constant = 0;
        frame.size.height = 0;
        self.btnHeightCons.constant = 0;
        self.imageHeightCons.constant = 0;
        self.conViewHeightCons.constant = 0;
    }else{
        [self.msgBtn setTitle:[NSString stringWithFormat:@"%ld条新消息",self.msgArr.count] forState:UIControlStateNormal];
        //第一条数据的头像
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.firstHead] placeholderImage:[UIImage imageNamed:@"default"]];
        self.btnHeightCons.constant = 40;
        self.imageHeightCons.constant = 31;
        self.viewHeightCons.constant = 64;
        self.conViewHeightCons.constant = 40;
        frame.size.height = 64;
    }
    self.headerView.frame = frame;
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView layoutIfNeeded];
    [self.tableView endUpdates];

    self.page = 1;
    WeakSelf;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getList];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getList];
    }];
    [self getList];
}
-(void)getList{
    WeakSelf;
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    NSDictionary * params = @{@"userId":userId,@"status":@"1",@"page":[NSString stringWithFormat:@"%d",self.page]};
//    NSSLog(@"%@",params);
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CircleListURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"朋友圈：%@",error);
        }else{
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
//                NSSLog(@"%@",arr);
                for (NSDictionary * dic in arr) {
                    CircleListModel * list = [[CircleListModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:list];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return self.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCell"];
    cell.circleModel = self.dataArr[indexPath.row];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    WeakSelf;
    //cell高度变化
    CircleListModel * model = self.dataArr[indexPath.row];
    CGFloat labelHeight = 0;
    CGFloat imageHeight = 0;
    //判断是否有文字
    if (model.content.length == 0) {
        labelHeight = 0;
        cell.conHeightCons.constant = 0;
    }else{
        cell.contentLabel.text = model.content;        
        //取到label的高度
        CGRect rect = [cell.contentLabel.text boundingRectWithSize:CGSizeMake(KMainScreenWidth-37, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        labelHeight = rect.size.height;
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
    imageHeight = cell.collHeightCons.constant;
    self.height = 112+labelHeight+imageHeight;
    [cell layoutIfNeeded];
    //点赞请求
    cell.block = ^(NSDictionary *dic,NSIndexPath * index,BOOL isSel){
        [weakSelf userLike:dic andIndexPath:index andIsLove:isSel];
    };
    cell.pushBlock = ^(UIViewController * vc){
        UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
        weakSelf.navigationItem.backBarButtonItem = backItem;
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
    return cell;
    
    
}
-(void)userLike:(NSDictionary *)params andIndexPath:(NSIndexPath *)index andIsLove:(BOOL) isSel{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ZanURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"朋友圈点赞失败：%@",error);
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //+1刷新列表-1
                //刷新当前cell
                CircleListModel * list = self.dataArr[index.row];
                if (isSel) {
                    list.likeStatus = @"1";
                    list.likedNumber =  [NSString stringWithFormat:@"%d",[list.likedNumber intValue]+1];
                }else{
                    list.likeStatus = @"0";
                    list.likedNumber =  [NSString stringWithFormat:@"%d",[list.likedNumber intValue]-1];
                }
                [UIView performWithoutAnimation:^{
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }else if ([code intValue] == 100){
                
            }else if ([code intValue] == 101){
               
            }
        }
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleListModel * model = self.dataArr[indexPath.row];
    //进入详情
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    CircleCommentController * comment = [sb instantiateViewControllerWithIdentifier:@"CircleCommentController"];
    comment.headUrl = model.userPortraitUrl;
    comment.name = model.nickname;
    comment.time = model.releaseTime;
    comment.content = model.content;
    comment.collectionArr = model.images;
    comment.likeCount = model.likedNumber;
    comment.commentCount = model.commentNumber;
    comment.isLike = model.likeStatus;
    comment.idStr = [NSString stringWithFormat:@"%ld",model.id];
    comment.placeStr = [NSString stringWithFormat:@"评论%@",model.nickname];
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController: comment animated:YES];
}
- (IBAction)rightClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    ActivityRecommendController * recom = [sb instantiateViewControllerWithIdentifier:@"ActivityRecommendController"];
    recom.rightStr = @"发布";
    recom.name = @"";
    recom.type = 2;
    recom.circleDelegate = self;
    [self.navigationController pushViewController:recom animated:YES];
}
- (IBAction)msgClick:(id)sender {
    //清空数据
    [self backClick];
    //查看与我相关的消息
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    CircleMessageController * message = [sb instantiateViewControllerWithIdentifier:@"CircleMessageController"];
    message.dataArr = self.msgArr;
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"朋友圈" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController: message animated:YES];

}
-(void)backClick{
    [self.tableView beginUpdates];
    CGRect frame = self.headerView.frame;
    self.viewHeightCons.constant = 0;
    frame.size.height = 0;
    self.headerView.frame = frame;
    self.btnHeightCons.constant = 0;
    self.imageHeightCons.constant = 0;
    self.conViewHeightCons.constant = 0;
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView layoutIfNeeded];
    [self.tableView endUpdates];
//发送通知到发现隐藏消息提示并清空
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CircleMessage" object:nil];
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
