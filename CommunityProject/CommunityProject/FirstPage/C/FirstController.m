//
//  FirstController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "FirstController.h"
#import "TravelCell.h"
#import "ClaimCell.h"
#import "ApplicationCenterCell.h"
#import <SDCycleScrollView.h>
#import "AppModel.h"
#import "FirstAppDataBaseSingleton.h"
#import "ClaimDataBaseSingleton.h"
#import "ClaimModel.h"
#import "AppCenterController.h"
#import "TravelModel.h"
#import "TravelDatabaseSingleton.h"
#import "RecommendController.h"
#import "ClaimCenterListController.h"
#import "PlatFormActController.h"
#import "PlatformDetailController.h"
#import "PublicListController.h"
#import "EducationListController.h"
#import "HelpListController.h"

#define FirstURL @"appapi/app/indexData"

@interface FirstController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *claimTableView;
//认领数据源
@property (nonatomic,strong)NSMutableArray * claimArr;
//旅游数据源
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * scrollArr;

//应用中心数据
@property (nonatomic,strong)NSMutableArray * applicationArr;
@property (nonatomic,strong) SDCycleScrollView * playView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightCons;

@end

@implementation FirstController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.playView adjustWhenControllerViewWillAppera];
    //插入一条数据
    if (self.dict.count != 0) {
        [self insertData];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.playView.delegate = nil;
}
-(void)insertData{
    
    FirstAppDataBaseSingleton * single = [FirstAppDataBaseSingleton shareDatabase];
    
    AppModel * appModel = [[AppModel alloc]initWithDictionary:self.dict error:nil];
    
    [single insertDatabase:appModel];
    
    [self.applicationArr insertObject:appModel atIndex:self.applicationArr.count];
    //计算高度
    [self countHeight];
    //清空插入数据
    self.dict = nil;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self showScrollViewUI];
    [self applicationCenter];
    //判断网络
    [self netWork];
}
-(void)netWork{
    NSInteger status = [[RCIMClient sharedRCIMClient]getCurrentNetworkStatus];
    if (status == 0) {
        //无网从本地加载数据
        [self localData];
    }else{
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf getClaimUserData];
        });
  
    }
}
-(void)showScrollViewUI{
      //网络
    WeakSelf;
    self.playView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"banner.png"]];
    [self.headView addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
        make.top.equalTo(weakSelf.headView);
        make.left.right.equalTo(weakSelf.headView);
    }];
    self.playView.autoScrollTimeInterval = 1;
    self.playView.currentPageDotColor = UIColorFromRGB(0xFED604);
    self.playView.pageDotColor = UIColorFromRGB(0x243234);
    //刷新
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getClaimUserData];
    }];
}
-(void)applicationCenter{
    
    //应用中心
    FirstAppDataBaseSingleton * singleton = [FirstAppDataBaseSingleton shareDatabase];
    
    [self.applicationArr addObjectsFromArray:[singleton searchDatabase]];
    
    if (self.applicationArr.count != 0) {
        //计算表头高度
        [self countHeight];
    }
}
-(void)countHeight{
    //每行cell的个数
    int count = KMainScreenWidth/89;
    //行数
    NSInteger retain = self.applicationArr.count%count;
    NSInteger row;
    if (retain != 0) {
         row = self.applicationArr.count/count+1;
    }else{
         row = self.applicationArr.count/count;
    }
    [self.tableView beginUpdates];
    self.collHeightContraint.constant = 101*row;
    [self.collectionView reloadData];
    self.headerHeightCons.constant = 627.5+self.collHeightContraint.constant;
    CGRect frame = self.headView.frame;
    frame.size.height = self.headerHeightCons.constant;
    self.headView.frame = frame;
    self.tableView.tableHeaderView = self.headView;
    [self.headView layoutIfNeeded];
    [self.tableView endUpdates];
}
//数据库获取数据
-(void)localData{
    //轮播图
    NSArray * imageArr = @[@"banner.png",@"banner2.png",@"banner3.png"];
    //本地
    self.playView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageNamesGroup:imageArr];

    //领养中心
    ClaimDataBaseSingleton * singleton = [ClaimDataBaseSingleton shareDatabase];
    
    [self.claimArr addObjectsFromArray:[singleton searchDatabase]];
    
    //旅游
    TravelDatabaseSingleton * travelSingleton = [TravelDatabaseSingleton shareDatabase];
    
    [self.dataArr addObjectsFromArray:[travelSingleton searchDatabase]];
    
    if (self.dataArr.count != 0&&self.claimArr.count != 0) {
        [self.claimTableView reloadData];
        [self.tableView reloadData];
    }

}
//获取所有
-(void)getClaimUserData{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    NSDictionary * params = @{@"userId":userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FirstURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
        if (error) {
            NSSLog(@"未认领用户数据请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            if (weakSelf.dataArr.count !=0||weakSelf.tableView.mj_header.isRefreshing||weakSelf.scrollArr.count != 0 || weakSelf.claimArr.count != 0) {
                [weakSelf.scrollArr removeAllObjects];
                for (ClaimModel * model in weakSelf.claimArr) {
                    [[ClaimDataBaseSingleton shareDatabase]deleteDatabase:model];
                }
                [weakSelf.claimArr removeAllObjects];
                for (TravelModel * travelModel in weakSelf.dataArr) {
                    [[TravelDatabaseSingleton shareDatabase]deleteDatabase:travelModel];
                }
                [weakSelf.dataArr removeAllObjects];

            }            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * allDic = data[@"data"];
                NSArray * advArr = allDic[@"advs"];
                for (NSDictionary * dic1 in advArr) {
                    [weakSelf.scrollArr addObject:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dic1[@"articleImage"]]]];
                }
                weakSelf.playView.imageURLStringsGroup = weakSelf.scrollArr;
                NSArray *claim = allDic[@"claimUsers"];
                for (NSDictionary * dict in claim) {
                    ClaimModel * claim = [[ClaimModel alloc]initWithDictionary:dict error:nil];
                    [[ClaimDataBaseSingleton shareDatabase]insertDatabase:claim];
                    [weakSelf.claimArr addObject:claim];
                }
                [weakSelf.claimTableView reloadData];
                NSArray * travel = allDic[@"actives"];
                for (NSDictionary * dic2 in travel) {
                    TravelModel * tvModel = [[TravelModel alloc]initWithDictionary:dic2 error:nil];
                    [[TravelDatabaseSingleton shareDatabase]insertDatabase:tvModel];
                    [weakSelf.dataArr addObject:tvModel];
                }
               
            }else if ([code intValue] == 0){
                [weakSelf showMessage:@"加载首页失败"];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
}
- (IBAction)moreClick:(id)sender {
   
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
    AppCenterController * app = [sb instantiateViewControllerWithIdentifier:@"AppCenterController"];
    app.delegate = self;
    app.nameArr = self.applicationArr;
    [self.navigationController pushViewController:app animated:YES];
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        TravelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelCell"];
        cell.travelModel = self.dataArr[indexPath.row];
        return cell;
    }else{
        ClaimCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ClaimCell"];
        cell.tableView = self.claimTableView;
        cell.dataArr = self.claimArr;
        cell.claimModel = self.claimArr[indexPath.row];
        cell.block = ^(UIViewController *vc){
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return self.dataArr.count;
    }else{
        return self.claimArr.count;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        TravelModel * model = self.dataArr[indexPath.row];
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
        PlatformDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"PlatformDetailController"];
        detail.idStr = [NSString stringWithFormat:@"%@",model.idStr];
        [self.navigationController pushViewController:detail animated:YES];
    }
 
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.applicationArr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ApplicationCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationCenterCell" forIndexPath:indexPath];
    cell.appModel = self.applicationArr[indexPath.row];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AppModel * model = self.applicationArr[indexPath.row];
    if ([model.name isEqualToString:@"认领中心"]) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ClaimCenter" bundle:nil];
        ClaimCenterListController * claim = [sb instantiateViewControllerWithIdentifier:@"ClaimCenterListController"];
        [self.navigationController pushViewController:claim animated:YES];
        
    }else if ([model.name isEqualToString:@"平台活动"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
        PlatFormActController * claim = [sb instantiateViewControllerWithIdentifier:@"PlatFormActController"];
        [self.navigationController pushViewController:claim animated:YES];
    }else if ([model.name isEqualToString:@"公益活动"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Public" bundle:nil];
        PublicListController * list = [sb instantiateViewControllerWithIdentifier:@"PublicListController"];
        [self.navigationController pushViewController:list animated:YES];
    }else if ([model.name isEqualToString:@"三分钟教学"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Education" bundle:nil];
        EducationListController * education = [sb instantiateViewControllerWithIdentifier:@"EducationListController"];
        [self.navigationController pushViewController:education animated:YES];
    }else if ([model.name isEqualToString:@"求助中心"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Help" bundle:nil];
        HelpListController * help = [sb instantiateViewControllerWithIdentifier:@"HelpListController"];
        [self.navigationController pushViewController:help animated:YES];
    }
    
}
- (IBAction)recomendClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    RecommendController * recomm = [sb instantiateViewControllerWithIdentifier:@"RecommendController"];
    [self.navigationController pushViewController:recomm animated:YES];
}

#pragma mark-懒加载
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)claimArr{
    if (!_claimArr) {
        _claimArr = [NSMutableArray new];
    }
    return _claimArr;
}
-(NSMutableArray *)applicationArr{
    if (!_applicationArr) {
        _applicationArr = [NSMutableArray new];
    }
    return _applicationArr;
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
        msgView.frame = CGRectMake(20, KMainScreenHeight-200, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
        //完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}
@end
