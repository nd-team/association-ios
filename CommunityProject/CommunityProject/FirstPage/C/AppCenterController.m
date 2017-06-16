//
//  AppCenterController.m
//  CommunityProject
//
//  Created by bjike on 17/3/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AppCenterController.h"
#import "AppModel.h"
#import "DataSource.h"
#import "AppTwoCell.h"

@interface AppCenterController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation AppCenterController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBar];
    [self getAllData];
}

-(void)setBar{
    self.title = @"应用中心";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x121212);
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 40, 40) andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getAllData{
    DataSource * data = [DataSource new];
    NSArray * array = [data getApplictionData];
    for (NSDictionary * dic in array) {
        AppModel * model = [[AppModel alloc]initWithDictionary:dic error:nil];
        [self.dataArr addObject:model];
    }
    [self.collectionView reloadData];
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AppTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppTwoCell" forIndexPath:indexPath];
    AppModel * model = self.dataArr[indexPath.row];
    for (AppModel * app in self.nameArr) {
        if ([app.name isEqualToString:model.name]) {
            cell.downloadImage.hidden = YES;
        }else{
            cell.downloadImage.hidden = NO;
        }
    }
    cell.appModel = self.dataArr[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //下载到首页去
    AppModel * model = self.dataArr[indexPath.row];
    int i = 0;
    for (AppModel * app in self.nameArr) {
        if ([app.name isEqualToString:model.name]) {
            i++;
            [self showMessage:@"已经下载此功能，请勿重复下载"];
            break;
        }
    }
    //        if ([@"认领中心" isEqualToString:model.name]) {
//}else{
  //  [self showMessage:@"此功能还未完善，敬请期待"];
    
//}

    if (i == 0) {
            self.delegate.dict = @{@"name":model.name,@"imageName":model.imageName};
            [self.navigationController popViewControllerAnimated:YES];
        
    }
   

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

#pragma mark-懒加载
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
