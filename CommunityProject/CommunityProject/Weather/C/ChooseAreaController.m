//
//  ChooseAreaController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ChooseAreaController.h"
#import "WeatherAreaCell.h"

@interface ChooseAreaController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation ChooseAreaController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.areaTF.text = self.area;
    [self getAreaData];
}
//获取地区数据源
-(void)getAreaData{
    NSArray * arr = @[@"北京",@"深圳",@"广州",@"天津",@"上海",@"重庆",@"南京",@"沈阳",@"长春",@"哈尔滨",@"武汉",@"香港",@"澳门",@"台北",@"高雄",@"台中",@"无锡",@"南昌",@"郑州",@"兰州"];
    [self.dataArr addObjectsFromArray:arr];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherAreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeatherAreaCell" forIndexPath:indexPath];
    cell.areaLabel.text = self.dataArr[indexPath.row];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击
    WeatherAreaCell * cell = (WeatherAreaCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.areaLabel.textColor = UIColorFromRGB(0x0fc791);
    self.areaTF.text =  self.dataArr[indexPath.row];
    [self common];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KMainScreenWidth-24)/4, 56);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //返回上个界面
    [self.areaTF resignFirstResponder];
    [self common];
    return YES;
}
-(void)common{
    self.delegate.city = self.areaTF.text;
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
