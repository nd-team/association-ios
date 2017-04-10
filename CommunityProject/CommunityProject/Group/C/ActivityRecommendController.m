//
//  ActivityRecommendController.m
//  CommunityProject
//
//  Created by bjike on 17/4/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ActivityRecommendController.h"
#import "RecommendImageCell.h"

@interface ActivityRecommendController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextView *recomTV;

@property (nonatomic,strong)NSMutableArray * collectArr;

@end

@implementation ActivityRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动介绍";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,60, 40) titleColor:UIColorFromRGB(0x121212) font:14 andTitle:@"完成" and:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;

}
-(void)rightClick{
    self.delegate.recommendStr = self.recomTV.text;
    self.delegate.dataArr = self.collectArr;
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommendImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendImageCell" forIndexPath:indexPath];
    cell.headImageView.image = self.collectArr[indexPath.row];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)pushAlbums{
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //dismiss系统的设置自定义
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    [self.collectArr addObject:originalImage];
    if (self.collectArr.count == 3) {
        
    }
    [self.collectionView reloadData];
    
}
-(NSMutableArray *)collectArr{
    if (!_collectArr) {
        _collectArr = [NSMutableArray new];
        [_collectArr addObject:[UIImage imageNamed:@"addFriend"]];
    }
    return _collectArr;
}

@end
