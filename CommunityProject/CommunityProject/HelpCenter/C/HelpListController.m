
//
//  HelpListController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HelpListController.h"
#import "HelpCenterListCell.h"
#import "UIView+ChatMoreView.h"
#import "PlatformMessageController.h"
#import "HelpListModel.h"
#import "MyHelpListController.h"
#import "HelpDetailController.h"

#define HelpListURL @"appapi/app/selectSeekHelpList"

@interface HelpListController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UIView * moreView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (nonatomic,assign)int page;
@property (nonatomic,copy)NSString * userId;

@end

@implementation HelpListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.page = 1;
    if (self.isRef) {
        [self netWork];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.questionBtn.layer.cornerRadius = 30;
    self.questionBtn.layer.masksToBounds = YES;
    self.userId = [DEFAULTS objectForKey:@"userId"];

    WeakSelf;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getHelpListData];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getHelpListData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self netWork];
}
-(void)netWork{
    NSInteger status = [[RCIMClient sharedRCIMClient]getCurrentNetworkStatus];
    if (status == 0) {
        //无网从本地加载数据
        [self showMessage:@"亲，没有连接网络哦！"];
    }else{
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf getHelpListData];
        });
        
    }

}
-(void)leftClick{
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
    self.moreView = [UIView claimMessageViewFrame:CGRectMake(KMainScreenWidth-105.5, 0, 95.5, 67) andArray:@[@"消息",@"我的求助"] andTarget:self andSel:@selector(moreAction:) andTag:150];
    [self.view addSubview:self.moreView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
-(void)moreAction:(UIButton *)btn{
    [self tapClick];
    if (btn.tag == 150) {
        //消息
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
        PlatformMessageController * msg = [sb instantiateViewControllerWithIdentifier:@"PlatformMessageController"];
        msg.type = 4;
        [self.navigationController pushViewController:msg animated:YES];
        
    }else{
        //我的求助
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Help" bundle:nil];
        MyHelpListController * help = [sb instantiateViewControllerWithIdentifier:@"MyHelpListController"];
        help.userId = self.userId;
        [self.navigationController pushViewController:help animated:YES];
        
    }
}
-(void)tapClick{
    self.moreView.hidden = YES;
}
-(void)getHelpListData{
    WeakSelf;
    NSDictionary * params = @{@"userId":self.userId,@"page":[NSString stringWithFormat:@"%d",self.page]};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,HelpListURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"求助中心：%@",error);
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
                        HelpListModel * list = [[HelpListModel alloc]initWithDictionary:dic error:nil];
                        [weakSelf.dataArr addObject:list];
                    }
                }
            }else{
                [weakSelf showMessage:@"加载求助中心失败，下拉刷新重试！"];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        }
    }];

}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpCenterListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HelpCenterListCell"];
    cell.listModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Help" bundle:nil];
    HelpDetailController * help = [sb instantiateViewControllerWithIdentifier:@"HelpDetailController"];
    help.iDStr = model.idStr;
    help.titleStr = model.title;
    help.time = model.time;
    help.content = model.content;
    help.contributeCount = [NSString stringWithFormat:@"%@",model.contributionCoin];
    help.answerCount = [NSString stringWithFormat:@"%@",model.helpNumber];
    [self.navigationController pushViewController:help animated:YES];

}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
//手势代理方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if ([touch.view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    return YES;
}
-(void)showMessage:(NSString *)msg{
    UIView * msgView = [UIView showViewTitle:msg];
    [self.view addSubview:msgView];
    [UIView animateWithDuration:1.0 animations:^{
        msgView.frame = CGRectMake(20, KMainScreenHeight-150, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
        //完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}
@end
