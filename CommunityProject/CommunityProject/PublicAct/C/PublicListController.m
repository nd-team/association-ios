//
//  PublicListController.m
//  CommunityProject
//
//  Created by bjike on 17/5/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PublicListController.h"
#import <SDCycleScrollView.h>
#import "UIView+ChatMoreView.h"
#import "PublicListModel.h"
#import "PublicListCell.h"
#import "MyJoinPublicController.h"
#import "PlatformMessageController.h"
#import "PubicDetailController.h"


#define PublicURL @"appapi/app/commonwealActivesList"
#define ZanURL @"appapi/app/userPraise"

@interface PublicListController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *scrollArr;
@property (nonatomic,strong)UIView * moreView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end

@implementation PublicListController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self.scrollView adjustWhenControllerViewWillAppera];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PublicListCell" bundle:nil] forCellReuseIdentifier:@"PublicListCell"];
    self.scrollView.localizationImageNamesGroup = @[@"banner",@"banner2",@"banner3"];
    self.scrollView.autoScrollTimeInterval = 1;
    self.scrollView.currentPageDotColor = UIColorFromRGB(0xFED604);
    self.scrollView.pageDotColor = UIColorFromRGB(0x243234);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 366;
    self.page = 1;
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getPublicListData];
    });
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [weakSelf getPublicListData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [weakSelf getPublicListData];
    }];

}
-(void)getPublicListData{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    NSDictionary * params = @{@"userId":userId,@"page":[NSString stringWithFormat:@"%d",self.page]};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,PublicURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"公益活动数据请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            if (weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }else{
            if (!weakSelf.tableView.mj_footer.isRefreshing) {
//                [weakSelf.scrollArr removeAllObjects];
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                if (arr.count == 0) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    for (NSDictionary * dict in arr) {
                        PublicListModel * model = [[PublicListModel alloc]initWithDictionary:dict error:nil];
                        [self.dataArr addObject:model];
                    }
            }
            }else{
                [weakSelf showMessage:@"加载公益活动失败"];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            

        }
    }];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)moreClick:(id)sender {
    self.moreBtn.selected = !self.moreBtn.selected;
    if (self.moreBtn.selected) {
        WeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf moreViewUI];
        });
    }else{
        self.moreView.hidden = YES;
    }

}
-(void)moreViewUI{
    self.moreView = [UIView claimMessageViewFrame:CGRectMake(KMainScreenWidth-105.5, 0, 95.5, 66.5) andArray:@[@"消息",@"我参与的公益"] andTarget:self andSel:@selector(moreAction:) andTag:137];
    [self.view addSubview:self.moreView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
-(void)tapClick{
    self.moreView.hidden = YES;
}
-(void)moreAction:(UIButton *)btn{
    [self tapClick];
    if (btn.tag == 137) {
        //消息
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
        PlatformMessageController * msg = [sb instantiateViewControllerWithIdentifier:@"PlatformMessageController"];
        msg.type = 7;
        [self.navigationController pushViewController:msg animated:YES];
        
    }else{
        //我参与的活动
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Public" bundle:nil];
        MyJoinPublicController * join = [sb instantiateViewControllerWithIdentifier:@"MyJoinPublicController"];
        [self.navigationController pushViewController:join animated:YES];
        
    }
}
#pragma mark - tableView-delegate and DataSources
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicListModel * model = self.dataArr[indexPath.row];
    if (model.height != 0) {
        return model.height;
    }
    return 366;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PublicListCell"];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    cell.block = ^(UIViewController * vc){
        [self.navigationController pushViewController:vc animated:YES];
    };
    WeakSelf;
    //点赞请求
    cell.zanBlock = ^(NSDictionary *dic,NSIndexPath * index,BOOL isSel){
        [weakSelf userLike:dic andIndexPath:index andIsLove:isSel];
    };

    cell.publicModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(void)userLike:(NSDictionary *)params andIndexPath:(NSIndexPath *)index andIsLove:(BOOL) isSel{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ZanURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"公益活动点赞失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //+1刷新列表-1
                //刷新当前cell
                PublicListModel * list = self.dataArr[index.row];
                if (isSel) {
                    list.likesStatus = @"1";
                    list.likes =  [NSString stringWithFormat:@"%d",[list.likes intValue]+1];
                }else{
                    list.likesStatus = @"0";
                    list.likes =  [NSString stringWithFormat:@"%d",[list.likes intValue]-1];
                }
                [UIView performWithoutAnimation:^{
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }else if ([code intValue] == 1029){
                [weakSelf showMessage:@"多次点赞失败"];

            }else if ([code intValue] == 1030){
                [weakSelf showMessage:@"非朋友点赞失败"];
            }else{
                [weakSelf showMessage:@"公益活动点赞失败"];
            }
        }
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Public" bundle:nil];
    PubicDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"PubicDetailController"];
    detail.idStr = [NSString stringWithFormat:@"%ld",(long)model.id];
    detail.headUrl = model.userPortraitUrl;
    detail.titleName = model.title;
    [self.navigationController pushViewController:detail animated:YES];

}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    return YES;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)scrollArr{
    if (!_scrollArr) {
        _scrollArr = [NSMutableArray new];
    }
    return _scrollArr;
    
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
