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
#import "UploadMulDocuments.h"
#import "CircleListModel.h"

#define SendURL @"appapi/app/releaseFriendsCircle"

@interface ActivityRecommendController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegateFlowLayout,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextView *recomTV;

@property (nonatomic,strong)NSMutableArray * collectArr;

@property (nonatomic,assign) NSUInteger count;

@property (nonatomic,assign) CGPoint touchPoint;
//标记已经有3张照片
@property (nonatomic,assign)BOOL isOver;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic,strong)UIBarButtonItem * rightItem;
@end

@implementation ActivityRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.name;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    self.rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,40, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:self.rightStr and:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    //初始化数据源
    [self.collectArr addObject:[self getImageData]];
    self.count = self.collectArr.count;
    if (self.type == 1) {
        self.placeLabel.hidden = YES;
    }else{
        self.placeLabel.hidden = NO;
        self.rightItem.enabled = NO;
    }
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
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.placeLabel.hidden = YES;
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    self.rightItem.enabled = YES;
}
-(void)rightClick{
    [self.recomTV resignFirstResponder];
    NSMutableArray * array = [NSMutableArray new];
    for (UploadImageModel * model in self.collectArr) {
        if (!model.isPlaceHolder) {
            [array addObject:model];
        }
    }
    if (self.type == 1) {
        self.delegate.recommendStr = self.recomTV.text;
        self.delegate.dataArr = array;
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        //发布朋友圈
        [self send:array];
    }
    
}
-(void)send:(NSMutableArray *)arr{
    WeakSelf;
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    NSMutableDictionary * mDic = [NSMutableDictionary new];
    [mDic setValue:userId forKey:@"userId"];
    [mDic setValue:self.recomTV.text forKey:@"content"];
     [UploadMulDocuments postDataWithUrl:[NSString stringWithFormat:NetURL,SendURL] andParams:mDic andArray:arr getBlock:^(NSURLResponse *response, NSError *error, id data) {
         if (error) {
             NSSLog(@"发布朋友圈失败：%@",error);
         }else{
             NSNumber * code = data[@"code"];
             if ([code intValue] == 200) {
                 NSDictionary * dic = data[@"data"];
                 NSSLog(@"%@",dic);
                 weakSelf.circleDelegate.isRef = YES;
                 CircleListModel * list = [CircleListModel new];
                 list.userId = userId;
                 list.userPortraitUrl = [DEFAULTS objectForKey:@"userPortraitUrl"];
                 list.nickname = [DEFAULTS objectForKey:@"nickname"];
                 list.likeStatus = @"0";
                 list.content = weakSelf.recomTV.text;
                 list.releaseTime = [NowDate currentDetailTime];
                 list.likedNumber = @"0";
                 list.commentNumber = @"0";
                 list.images = dic[@"images"];
                 list.id = [dic[@"id"] integerValue];
                 weakSelf.circleDelegate.model = list;
                 [weakSelf.navigationController popViewControllerAnimated:YES];
             }
         }
     }];
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommendImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendImageCell" forIndexPath:indexPath];
    cell.uploadModel = self.collectArr[indexPath.row];
    if (self.type == 1) {
        if (indexPath.row != 0) {
            cell.nameLabel.hidden = YES;
        }else{
            cell.nameLabel.hidden = NO;
        }
    }else{
        cell.nameLabel.hidden = YES;
    }
   
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        if (indexPath.row == 0) {
            if (self.isOver) {
                NSSLog(@"已有三张");
            }else{
                [self pushAlbums];
            }
        }
    }else{
        //9张
        if (indexPath.row == 0) {
            if (self.isOver) {
                NSSLog(@"已有9张");
            }else{
                [self pushAlbums];
            }
        }
    }
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
   return  UIEdgeInsetsMake(0, 0, 0, 10);
}
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
    if (self.type == 1) {
        if (self.count == 4) {
            [self.collectArr replaceObjectAtIndex:0 withObject:item];
            //标记提示用户
            self.isOver = YES;
        }else{
            [self.collectArr insertObject:item atIndex:1];
            self.isOver = NO;
        }
    }else{
        //发布朋友圈
        self.rightItem.enabled = YES;
        if (self.count == 10) {
            [self.collectArr replaceObjectAtIndex:0 withObject:item];
            //标记提示用户
            self.isOver = YES;
        }else{
            [self.collectArr insertObject:item atIndex:1];
            self.isOver = NO;
        }
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
