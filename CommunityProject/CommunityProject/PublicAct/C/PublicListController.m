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

#define PublicURL @"appapi/app/commonwealActivesList"
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
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
        if (error) {
            NSSLog(@"公益活动数据请求失败：%@",error);
        }else{
            if (!weakSelf.tableView.mj_footer.isRefreshing) {
//                [weakSelf.scrollArr removeAllObjects];
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dict in arr) {
                    PublicListModel * model = [[PublicListModel alloc]initWithDictionary:dict error:nil];
                    [self.dataArr addObject:model];
                }
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }else{
                NSSLog(@"请求公益活动数据失败");
            }
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
//        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
//        PlatformMessageController * msg = [sb instantiateViewControllerWithIdentifier:@"PlatformMessageController"];
//        [self.navigationController pushViewController:msg animated:YES];
        
    }else{
        //我参与的活动
//        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
//        MyJoinActivityController * join = [sb instantiateViewControllerWithIdentifier:@"MyJoinActivityController"];
//        [self.navigationController pushViewController:join animated:YES];
        
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
    cell.publicModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
