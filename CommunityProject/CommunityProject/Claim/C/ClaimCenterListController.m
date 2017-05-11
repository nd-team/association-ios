//
//  ClaimCenterListController.m
//  CommunityProject
//
//  Created by bjike on 17/5/11.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ClaimCenterListController.h"
#import "ClaimCenterCell.h"

#define ClaimURL @"appapi/app/allFriendsClaim"
@interface ClaimCenterListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray * collectionArr;

@end

@implementation ClaimCenterListController

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getClaimData];
    }];
//    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        //Call this Block When enter the refresh status automatically
//    }];
    [self getClaimData];
}
-(void)getClaimData{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    NSDictionary * params = @{@"userId":userId,@"status":@"0"};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ClaimURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"未认领用户数据请求失败：%@",error);
        }else{
            if (weakSelf.collectionArr.count !=0||weakSelf.collectionView.mj_header.isRefreshing) {
                
                [weakSelf.collectionArr removeAllObjects];
                
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    ClaimCenterModel * model = [[ClaimCenterModel alloc]initWithDictionary:dic error:nil];
                    [self.collectionArr addObject:model];
                }
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
            }
        }
    }];
}
#pragma mark - collectionView的代理方法
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KMainScreenWidth-5)/3, 130);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionArr.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ClaimCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClaimCenterCell" forIndexPath:indexPath];
    cell.centerModel = self.collectionArr[indexPath.row];
    return cell;
    
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)moreClick:(id)sender {
}

-(NSMutableArray *)collectionArr{
    if (!_collectionArr) {
        _collectionArr = [NSMutableArray new];
    }
    return _collectionArr;
}
@end
