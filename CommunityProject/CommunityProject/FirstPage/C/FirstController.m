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

#define ClaimURL @"http://192.168.0.209:90/appapi/app/allFriendsClaim"
@interface FirstController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *claimTableView;
//认领数据源
@property (nonatomic,strong)NSMutableArray * claimArr;
//旅游数据源
@property (nonatomic,strong)NSMutableArray * dataArr;
//应用中心数据
@property (nonatomic,strong)NSMutableArray * applicationArr;
@property (nonatomic,strong) SDCycleScrollView * playView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeightContraint;

@end

@implementation FirstController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
        [self getAllData];
  
    }
}
-(void)showScrollViewUI{
    //刷新
    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf ];
    }];
    //轮播图
    NSArray * imageArr = @[@"banner.png",@"banner2.png",@"banner3.png"];
    //本地
    self.playView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageNamesGroup:imageArr];

      //网络
//    self.playView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"banner.png"]];
    [self.headView addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
        make.top.equalTo(weakSelf.headView);
        make.left.right.equalTo(weakSelf.headView);
    }];
    self.playView.autoScrollTimeInterval = 1;
    self.playView.currentPageDotColor = UIColorFromRGB(0xFED604);
    self.playView.pageDotColor = UIColorFromRGB(0x243234);
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
    NSInteger row = self.applicationArr.count/count+self.applicationArr.count%count;
    self.collHeightContraint.constant = 101*row;
    self.tableView.sectionHeaderHeight = 637.5+self.collHeightContraint.constant;
    [self.collectionView reloadData];
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
    
    if (self.claimArr.count != 0) {
        
        [self.claimTableView reloadData];
    }
    //旅游
    

}
//网络获取数据
-(void)getAllData{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    WeakSelf;
    dispatch_group_async(group,queue , ^{
    //请求轮播图
        
    });
    dispatch_group_async(group,queue , ^{
      //请求未领数据
        [weakSelf getClaimUserData];
    });
    dispatch_group_async(group,queue , ^{
        //请求旅游数据
        
    });
    dispatch_group_notify(group, queue, ^{
       
        
    });

}
//获取所有认领用户
-(void)getClaimUserData{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [userDefaults objectForKey:@"userId"];
    //0：未认领
    WeakSelf;
    NSDictionary * params = @{@"userId":userId,@"status":@"0"};
    [AFNetData postDataWithUrl:ClaimURL andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"未认领用户数据请求失败：%@",error);
        }else{
//            if (weakSelf.claimArr.count !=0||weakSelf.claimTableView.mj_header.isRefreshing) {
//                for (ClaimModel * model in weakSelf.claimArr) {
//                    [[ClaimDataBaseSingleton shareDatabase]deleteDatabase:model];
//                }
//                [weakSelf.claimArr removeAllObjects];
//            }
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                NSArray * array = jsonDic[@"data"];
                NSSLog(@"%@",array);
                for (NSDictionary * dict in array) {
                    ClaimModel * claim = [[ClaimModel alloc]initWithDictionary:dict error:nil];
                    [weakSelf.claimArr addObject:claim];
                }
                [weakSelf.claimTableView reloadData];
//                [weakSelf.claimTableView.mj_header endRefreshing];
            }else if ([code intValue] == 0){
                NSString * msg = jsonDic[@"msgs"];
                NSSLog(@"失败错误信息：%@",msg);
            }
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
        
        return cell;
    }else{
        ClaimCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ClaimCell"];
//        cell.claimModel = self.claimArr[indexPath.row];
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 10;
//        return self.dataArr.count;
    }else{
        return 3;
//        return self.claimArr.count;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
@end
