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
#import "TrafficListController.h"
#import "GoodsListController.h"
#import "RaiseListController.h"
#import "WeatherListController.h"
#import "PositionMapController.h"
#import "EntericeOfDriverController.h"
#import "OutCarController.h"
#import "PassagerViewController.h"

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeightContraint;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scrollView;

@end

@implementation FirstController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.scrollView adjustWhenControllerViewWillAppera];
    //插入一条数据
    if (self.dict.count != 0) {
        [self insertData];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.scrollView.delegate = nil;
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf getClaimUserData];
        });
  
    }
}
-(void)showScrollViewUI{
      //网络
    self.scrollView.autoScrollTimeInterval = 1;
    self.scrollView.currentPageDotColor = UIColorFromRGB(0xFED604);
    self.scrollView.pageDotColor = UIColorFromRGB(0x243234);
    //刷新
    WeakSelf;
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
#pragma mark-修改tableView表头高度
-(void)countHeight{
    //每行cell的个数
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = KMainScreenWidth/89;
        //行数
        NSInteger retainCount = self.applicationArr.count%count;
        NSInteger row;
        if (retainCount != 0) {
            row = self.applicationArr.count/count+1;
        }else{
            row = self.applicationArr.count/count;
        }
        //    [self.headView setNeedsLayout];
        self.collHeightContraint.constant = 101*row;
        CGRect frame = self.headView.frame;
        frame.size.height = 622.5+self.collHeightContraint.constant;
        self.headView.frame = frame;
        [self.collectionView reloadData];
    });
}
//数据库获取数据
-(void)localData{

    //领养中心
    ClaimDataBaseSingleton * singleton = [ClaimDataBaseSingleton shareDatabase];
    
    [self.claimArr addObjectsFromArray:[singleton searchDatabase]];
    
    //旅游
    TravelDatabaseSingleton * travelSingleton = [TravelDatabaseSingleton shareDatabase];
    
    [self.dataArr addObjectsFromArray:[travelSingleton searchDatabase]];
    
    if (self.dataArr.count != 0&&self.claimArr.count != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.claimTableView reloadData];
            [self.tableView reloadData];
        });

    }

}
//获取所有
-(void)getClaimUserData{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    NSDictionary * params = @{@"userId":userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FirstURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"未认领用户数据请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            weakSelf.scrollView.localizationImageNamesGroup = @[@"banner",@"banner2",@"banner3"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            [weakSelf localData];
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
                if (advArr.count == 0) {
                    weakSelf.scrollView.localizationImageNamesGroup = @[@"banner",@"banner2",@"banner3"];
                }else{
                    for (NSDictionary * dic1 in advArr) {
                        [weakSelf.scrollArr addObject:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dic1[@"articleImage"]]]];
                    }
                    weakSelf.scrollView.imageURLStringsGroup = weakSelf.scrollArr;
                }
                NSArray *claim = allDic[@"claimUsers"];
                for (NSDictionary * dict in claim) {
                    ClaimModel * claim = [[ClaimModel alloc]initWithDictionary:dict error:nil];
                    [[ClaimDataBaseSingleton shareDatabase]insertDatabase:claim];
                    [weakSelf.claimArr addObject:claim];
                }
                NSArray * travel = allDic[@"actives"];
                for (NSDictionary * dic2 in travel) {
                    TravelModel * tvModel = [[TravelModel alloc]initWithDictionary:dic2 error:nil];
                    [[TravelDatabaseSingleton shareDatabase]insertDatabase:tvModel];
                    [weakSelf.dataArr addObject:tvModel];
                }
               
            }else if ([code intValue] == 0){
                weakSelf.scrollView.localizationImageNamesGroup = @[@"banner",@"banner2",@"banner3"];
                [weakSelf showMessage:@"加载首页失败"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.claimTableView reloadData];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            });
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
    UIViewController *vc;
    if ([model.name isEqualToString:@"认领中心"]) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ClaimCenter" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"ClaimCenterListController"];
    }else if ([model.name isEqualToString:@"平台活动"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"PlatFormActController"];
    }else if ([model.name isEqualToString:@"公益活动"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Public" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"PublicListController"];
    }else if ([model.name isEqualToString:@"三分钟教学"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Education" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"EducationListController"];
    }else if ([model.name isEqualToString:@"求助中心"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Help" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"HelpListController"];
    }else if ([model.name isEqualToString:@"灵感贩卖"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"TrafficeOfInsporation" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"TrafficListController"];
    }else if ([model.name isEqualToString:@"干货分享"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Goods" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"GoodsListController"];
    }
    else if ([model.name isEqualToString:@"众筹"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Raise" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"RaiseListController"];
    }
    else if ([model.name isEqualToString:@"天气中心"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Weather" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"WeatherListController"];
    }else if ([model.name isEqualToString:@"位置点评"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Position" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"PositionMapController"];
    }
    else if ([model.name isEqualToString:@"联盟司机"]){
        /*判断用户是司机就进入定位接单界面，否则就进入申请表
         
         */
        NSInteger  driver = [DEFAULTS integerForKey:@"checkCar"];
        if (driver == 1) {
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Driver" bundle:nil];
            
            vc = [sb instantiateViewControllerWithIdentifier:@"OutCarController"];
        }else{
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Driver" bundle:nil];
            vc = [sb instantiateViewControllerWithIdentifier:@"EntericeOfDriverController"];
        }
    }else if ([model.name isEqualToString:@"联盟打车"]){
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Passager" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"PassagerViewController"];
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];

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
    [self.navigationController.view makeToast:msg];
}
@end
