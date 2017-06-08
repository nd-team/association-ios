//
//  PlatFormActController.m
//  CommunityProject
//
//  Created by bjike on 17/5/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PlatFormActController.h"
#import <SDCycleScrollView.h>
#import "ActCommonListCell.h"
#import "PlatformActListModel.h"
#import "UIView+ChatMoreView.h"
#import "MyJoinActivityController.h"
#import "PlatformMessageController.h"
#import "PlatformDetailController.h"

#define ActListURL @"appapi/app/platformActivesList"
@interface PlatFormActController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *scrollArr;
@property (nonatomic,strong)UIView * moreView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreItem;
@property (nonatomic,assign)BOOL isSelect;

@end

@implementation PlatFormActController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self.scrollView adjustWhenControllerViewWillAppera];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActCommonListCell" bundle:nil] forCellReuseIdentifier:@"ActCommonListCell"];
    self.scrollView.localizationImageNamesGroup = @[@"banner",@"banner2",@"banner3"];
    self.scrollView.autoScrollTimeInterval = 1;
    self.scrollView.currentPageDotColor = UIColorFromRGB(0xFED604);
    self.scrollView.pageDotColor = UIColorFromRGB(0x243234);
    self.page = 1;
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getActListData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [weakSelf getActListData];
    }];
  self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
      self.page ++;
      [weakSelf getActListData];
  }];

}
-(void)moreViewUI{
    self.moreView = [UIView claimMessageViewFrame:CGRectMake(KMainScreenWidth-105.5, 0, 95.5, 66.5) andArray:@[@"消息",@"我参与的活动"] andTarget:self andSel:@selector(moreAction:) andTag:134];
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
    if (btn.tag == 134) {
        //消息
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
        PlatformMessageController * msg = [sb instantiateViewControllerWithIdentifier:@"PlatformMessageController"];
        msg.type = 1;
        [self.navigationController pushViewController:msg animated:YES];
        
    }else{
        //我参与的活动
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
        MyJoinActivityController * join = [sb instantiateViewControllerWithIdentifier:@"MyJoinActivityController"];
        [self.navigationController pushViewController:join animated:YES];
        
    }
}

-(void)getActListData{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    NSDictionary * params = @{@"userId":userId,@"page":[NSString stringWithFormat:@"%d",self.page]};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ActListURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"平台活动数据请求失败：%@",error);
        }else{
            if (!weakSelf.tableView.mj_footer.isRefreshing) {
//                [weakSelf.scrollArr removeAllObjects];
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dict in arr) {
                    PlatformActListModel * model = [[PlatformActListModel alloc]initWithDictionary:dict error:nil];
                    [self.dataArr addObject:model];
                }
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }else{
                NSSLog(@"请求平台活动数据失败");
            }
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActCommonListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ActCommonListCell"];
    cell.actModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlatformActListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
    PlatformDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"PlatformDetailController"];
    detail.idStr = [NSString stringWithFormat:@"%ld",(long)model.id];
    [self.navigationController pushViewController:detail animated:YES];

}

- (IBAction)leftClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)rightClick:(id)sender {
    self.isSelect = !self.isSelect;
    if (self.isSelect) {
        WeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf moreViewUI];
        });
    }else{
        self.moreView.hidden = YES;
    }
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
@end
