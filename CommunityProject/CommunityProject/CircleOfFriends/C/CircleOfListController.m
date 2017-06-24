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
#define UnreadURL @"appapi/app/commentNewsList"

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
@property (nonatomic,copy)NSString * userId;

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
    self.page = 1;
    self.userId  = [DEFAULTS objectForKey:@"userId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleCell" bundle:nil] forCellReuseIdentifier:@"CircleCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    [self postUnreadMessage];
    WeakSelf;
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getList];

    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"数据全部加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
//    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getList];
    }];
    [self getList];
}
-(void)getList{
    WeakSelf;
    NSDictionary * params = @{@"userId":self.userId,@"status":@"1",@"page":[NSString stringWithFormat:@"%d",self.page]};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CircleListURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"朋友圈：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            if (weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }else{
            if (!weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                if (arr.count == 0) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    for (NSDictionary * dic in arr) {
                        CircleListModel * list = [[CircleListModel alloc]initWithDictionary:dic error:nil];
                        [weakSelf.dataArr addObject:list];
                    }
                    
                }
            }else{
                [weakSelf showMessage:@"加载朋友圈失败，下拉刷新重试！"];

            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}
-(void)postUnreadMessage{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,UnreadURL] andParams:@{@"userId":self.userId,@"type":@"2"} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取未读消息失败%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                //初始化传参过来的消息数据
                [weakSelf.tableView beginUpdates];
                CGRect frame = self.headerView.frame;
                if (arr.count == 0) {
                    weakSelf.viewHeightCons.constant = 0;
                    frame.size.height = 0;
                    weakSelf.btnHeightCons.constant = 0;
                    weakSelf.imageHeightCons.constant = 0;
                    weakSelf.conViewHeightCons.constant = 0;
                }else{
                    weakSelf.btnHeightCons.constant = 40;
                    weakSelf.imageHeightCons.constant = 31;
                    weakSelf.viewHeightCons.constant = 64;
                    weakSelf.conViewHeightCons.constant = 40;
                    weakSelf.msgArr = arr;
                    frame.size.height = 64;
                    [self.msgBtn setTitle:[NSString stringWithFormat:@"%ld条新消息",(unsigned long)arr.count] forState:UIControlStateNormal];
                    int i = 0;
                    for (NSDictionary * dic in arr) {
                        if (i == 0) {
                            //第一条数据的头像
                            [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dic[@"userPortraitUrl"]]]] placeholderImage:[UIImage imageNamed:@"default"]];
                            break;
                        }
                        i++;
                    }
                }
                weakSelf.headerView.frame = frame;
                weakSelf.tableView.tableHeaderView = weakSelf.headerView;
                [weakSelf.headerView layoutIfNeeded];
                [weakSelf.tableView endUpdates];
            }else{
                [weakSelf showMessage:@"加载消息失败！"];
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
            [weakSelf showMessage:@"服务器出错咯！"];
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
            }else if ([code intValue] == 1029){
                [weakSelf showMessage:@"多次点赞失败"];
            }else if ([code intValue] == 1030){
                [weakSelf showMessage:@"非朋友点赞失败"];
            }else{
                [weakSelf showMessage:@"点赞失败"];
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
    comment.idStr = [NSString stringWithFormat:@"%ld",(long)model.id];
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
