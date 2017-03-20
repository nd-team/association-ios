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
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40) image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
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
        if ([model.name isEqualToString:app.name]) {
            cell.downloadImage.hidden = YES;
        }else{
            cell.downloadImage.hidden = NO;
        }
    }
    cell.appModel = self.dataArr[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AppModel * model = self.dataArr[indexPath.row];
    for (AppModel * app in self.nameArr) {
        if (![model.name isEqualToString:app.name]) {
            //下载 通知首页 传参 提示用户已经有这个选项
            self.delegate.dict = @{@"name":model.name,@"imageName":model.imageName};

        }
    }
}
#pragma mark-懒加载
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
