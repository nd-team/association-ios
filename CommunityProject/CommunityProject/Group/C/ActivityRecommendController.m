//
//  ActivityRecommendController.m
//  CommunityProject
//
//  Created by bjike on 17/4/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ActivityRecommendController.h"
#import "RecommendImageCell.h"
#import "UploadImageModel.h"

@interface ActivityRecommendController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextView *recomTV;

@property (nonatomic,strong)NSMutableArray * collectArr;

@property (nonatomic,assign) NSUInteger count;

@property (nonatomic,assign) CGPoint touchPoint;
//标记已经有3张照片
@property (nonatomic,assign)BOOL isOver;

@end

@implementation ActivityRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动介绍";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,40, 30) titleColor:UIColorFromRGB(0x121212) font:14 andTitle:@"完 成" and:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //初始化数据源
    [self.collectArr addObject:[self getImageData]];
    self.count = self.collectArr.count;

    //长按删除
    [self showTapUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delectImageCell) name:@"DelectImage" object:nil];
    
}
//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
-(void)delectImageCell{

    self.count --;
    
    NSIndexPath * index = [self.collectionView indexPathForItemAtPoint:self.touchPoint];
    
    [self.collectArr removeObjectAtIndex:index.row];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index.row inSection:0];
    
    NSArray * delectArr = @[indexPath];
    
    [self.collectionView deleteItemsAtIndexPaths:delectArr];
    if (self.isOver) {
        //删除的那张之后把第一张插入默认的
        [self.collectArr insertObject:[self getImageData] atIndex:0];
        NSIndexPath * insertIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        
        NSArray * insertArr = @[insertIndex];
        
        [self.collectionView insertItemsAtIndexPaths:insertArr];
        
        self.isOver = NO;
        
    }
    [self.collectionView reloadData];
    
    
}

-(void)rightClick{
    [self.recomTV resignFirstResponder];
    self.delegate.recommendStr = self.recomTV.text;
    NSMutableArray * array = [NSMutableArray new];
    for (UploadImageModel * model in self.collectArr) {
        if (!model.isPlaceHolder) {
            [array addObject:model];
        }
    }
    self.delegate.dataArr = array;
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommendImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendImageCell" forIndexPath:indexPath];
    cell.uploadModel = self.collectArr[indexPath.row];
    if (indexPath.row != 0) {
        cell.nameLabel.hidden = YES;
    }else{
        cell.nameLabel.hidden = NO;
    }
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        if (self.isOver) {
            NSSLog(@"已有三张");
        }else{
            [self pushAlbums];
        }
    }
}
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    UIEdgeInsetsMake(0, 0, 0, <#CGFloat right#>)
//}
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 0;
//}
#pragma mark-删除图片
-(void)showTapUI{
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClicked:)];
    
    [self.collectionView addGestureRecognizer:longPress];
    
}
-(void)longPressClicked:(UILongPressGestureRecognizer *)tap{
    
    self.touchPoint = [tap locationInView:self.collectionView];
    
    if (tap.state == UIGestureRecognizerStateBegan) {
        
        
        NSIndexPath * index = [self.collectionView indexPathForItemAtPoint:self.touchPoint];
        
        if (index == nil) {
            
            NSLog(@"空");
            
        }else{
            
            UploadImageModel * model = self.collectArr[index.row];
            //第一个隐藏删除键
            if (index.row == 0) {
                
                model.isHide = YES;
            }else{
                
                model.isHide = NO;
                
            }
            
            [self.collectionView reloadData];
        }
        
    }else{
        
        NSLog(@"结束长按");
    }
    
}
-(UploadImageModel *)getImageData{
    UploadImageModel * item = [UploadImageModel new];
    
    item.image = [UIImage imageNamed:@"addFriend"];
    
    item.isPlaceHolder = YES;
    
    item.isHide = YES;
    
    return item;
}

-(void)pushAlbums{
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //dismiss系统的设置自定义
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    
    UploadImageModel * item = [UploadImageModel new];
    
    item.image = originalImage;
    
    item.isPlaceHolder = NO;
    
    item.isHide = YES;
    self.count++;
    if (self.count == 4) {
        [self.collectArr replaceObjectAtIndex:0 withObject:item];
        //标记提示用户
        self.isOver = YES;
    }else{
        [self.collectArr insertObject:item atIndex:1];
    }
    
    
    [self.collectionView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(NSMutableArray *)collectArr{
    if (!_collectArr) {
        _collectArr = [NSMutableArray new];
    }
    return _collectArr;
}

@end
