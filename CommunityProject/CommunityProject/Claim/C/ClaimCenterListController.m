//
//  ClaimCenterListController.m
//  CommunityProject
//
//  Created by bjike on 17/5/11.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ClaimCenterListController.h"
#import "ClaimCenterCell.h"
#import "ClaimInfoController.h"
#import "UIView+ChatMoreView.h"
#import "ClaimMessageController.h"
#import "MyClaimController.h"

#define ClaimURL @"appapi/app/allFriendsClaim"
@interface ClaimCenterListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray * collectionArr;

@property (nonatomic,strong)UIView * moreView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end

@implementation ClaimCenterListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
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
-(void)moreViewUI{
    self.moreView = [UIView claimMessageViewFrame:CGRectMake(KMainScreenWidth-105.5, 0, 95.5, 66.5) andArray:@[@"消息",@"我的认领"] andTarget:self andSel:@selector(moreAction:) andTag:130];
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
    if (btn.tag == 130) {
        //消息
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ClaimCenter" bundle:nil];
        ClaimMessageController * msg = [sb instantiateViewControllerWithIdentifier:@"ClaimMessageController"];
        [self.navigationController pushViewController:msg animated:YES];

    }else{
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ClaimCenter" bundle:nil];
        MyClaimController * claim = [sb instantiateViewControllerWithIdentifier:@"MyClaimController"];
        [self.navigationController pushViewController:claim animated:YES];

    }
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ClaimCenterModel * model = self.collectionArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ClaimCenter" bundle:nil];
    ClaimInfoController * info = [sb instantiateViewControllerWithIdentifier:@"ClaimInfoController"];
    info.claimUserId = model.userId;
    info.url = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:model.userPortraitUrl]];
    if (model.fullName.length !=0) {
        info.name = model.fullName;
    }else{
        info.name = model.nickname;
    }
    [self.navigationController pushViewController:info animated:YES];

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

-(NSMutableArray *)collectionArr{
    if (!_collectionArr) {
        _collectionArr = [NSMutableArray new];
    }
    return _collectionArr;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UICollectionView class]]) {
        return NO;
    }
    return YES;
}
@end
