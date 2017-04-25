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
#import <CTAssetsPickerController/CTAssetsPickerController.h>

#define SendURL @"appapi/app/releaseFriendsCircle"

@interface ActivityRecommendController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegateFlowLayout,UITextViewDelegate,CTAssetsPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextView *recomTV;

@property (nonatomic,strong)NSMutableArray * collectArr;

@property (nonatomic,assign) NSUInteger count;
//总图片个数
@property (nonatomic,assign) NSUInteger allCount;

@property (nonatomic,assign) CGPoint touchPoint;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic,strong)UIBarButtonItem * rightItem;

@property (nonatomic, strong) PHImageRequestOptions *requestOption;

@end

@implementation ActivityRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.name;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    self.rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:self.rightStr and:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.requestOption = [[PHImageRequestOptions alloc] init];
    self.requestOption.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    //初始化数据源
    [self.collectArr addObject:[self getImageData]];
    self.allCount = 0;
//    self.cameraCount = 0;
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
    NSIndexPath * index = [self.collectionView indexPathForItemAtPoint:self.touchPoint];
    [self.collectArr removeObjectAtIndex:index.row];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index.row inSection:0];
    NSArray * delectArr = @[indexPath];
    [self.collectionView deleteItemsAtIndexPaths:delectArr];
    if ((self.type == 1 && self.allCount == 3)||(self.type == 2 && self.allCount == 9)) {
            //删除的那张之后把第一张插入默认的
            [self.collectArr insertObject:[self getImageData] atIndex:0];
            NSIndexPath * insertIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            
            NSArray * insertArr = @[insertIndex];
            
            [self.collectionView insertItemsAtIndexPaths:insertArr];
    }
    self.allCount -- ;
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
        if (self.recomTV.text.length == 0&&self.collectArr.count == 1) {
            //提示不能发布空的
            return;
        }else{
            //发布朋友圈
            [self send:array];
        }
       
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
//                 NSSLog(@"%@",dic);
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
        if (indexPath.row == 0) {
                //弹出相册
            [self.recomTV resignFirstResponder];
            if (self.type == 1) {
                if (self.allCount == 3) {
                    return;
                }else{
                    [self pushMulPhotos];
                }
            }else{
                if (self.allCount == 9) {
                    //自行删除
                    return;
                }else{
                    [self showAlert];
                }
            }
        }
}
-(void)showAlert{
    WeakSelf;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf pushAlbums];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf pushMulPhotos];
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}
-(void)pushMulPhotos{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        CTAssetsPickerController * picker = [[CTAssetsPickerController alloc]init];
        picker.delegate = self;
        picker.showsSelectionIndex = YES;
        picker.doneButtonTitle = @"确定";
        picker.showsEmptyAlbums = NO;
        // create options for fetching photo only
        PHFetchOptions *fetchOptions = [PHFetchOptions new];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
        
        // assign options
        picker.assetsFetchOptions = fetchOptions;
        [self presentViewController:picker animated:YES completion:nil];
    }];
}
//选择完成
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.allCount += assets.count;
    WeakSelf;
    //刷新collection
    int i = 1;
    for (PHAsset * asset in assets) {
        CGFloat scale = UIScreen.mainScreen.scale;
        CGSize targetSize = CGSizeMake(60 * scale, 60 * scale);
       __block UploadImageModel * item = [UploadImageModel new];
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:self.requestOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                item.image = result;
                
                item.isPlaceHolder = NO;
                
                item.isHide = YES;
                //活动介绍
                if (weakSelf.type == 1) {

                    if (weakSelf.allCount == 3 && i == assets.count) {
                        weakSelf.count = 3;
                        //3张
                        [weakSelf.collectArr replaceObjectAtIndex:0 withObject:item];
                    }else{
                        [weakSelf.collectArr addObject:item];
                    }
                    
                }else{
                    //朋友圈
                    if (weakSelf.allCount == 9 && i == assets.count) {
                        weakSelf.count = 9;
                        //9张
                        [weakSelf.collectArr replaceObjectAtIndex:0 withObject:item];
                    }else{
                        [weakSelf.collectArr addObject:item];

                    }
        
                }
            if (weakSelf.collectArr.count -1 == assets.count || weakSelf.count == 3|| weakSelf.count == 9) {
                [weakSelf.collectionView reloadData];
            }
        }];
        i++;
    }

}
-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset{
    NSInteger max = 0;
    if (self.type == 1) {
        max = 3-self.allCount;
    }else{
        max = 9-self.allCount;
    }
    if (picker.selectedAssets.count >= max) {
        [self showMessage:max andView:picker];
    }
    return picker.selectedAssets.count < max;

}

-(void)showMessage:(NSInteger)max andView:(CTAssetsPickerController*)picker{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"温馨提示"
                                        message:[NSString stringWithFormat:@"请选择不要超过 %ld 张的图片", (long)max]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action =
    [UIAlertAction actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault
                           handler:nil];
    
    [alert addAction:action];
    
    [picker presentViewController:alert animated:YES completion:nil];

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
            NSInteger i = 0;
            for (UploadImageModel * model in self.collectArr) {
                if (self.type == 1) {
                    //活动介绍
                    if ((index.row == i && index.row != 0 && self.allCount < 3)||(index.row == i && self.allCount == 3)) {
                        model.isHide = NO;
                    }else{
                        model.isHide = YES;
                    }
                }else{
                    //朋友圈
                    if ((index.row == i && index.row != 0 && self.allCount < 9)||(index.row == i && self.allCount == 9)) {
                        model.isHide = NO;
                    }else{
                        model.isHide = YES;
                    }
                }
                i++;
 
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
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //dismiss系统的设置自定义
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    
    UploadImageModel * item = [UploadImageModel new];
    
    item.image = originalImage;
    
    item.isPlaceHolder = NO;
    
    item.isHide = YES;
    self.allCount++;
    //总个数
    if (self.type == 1) {
        if (self.allCount == 3) {
            [self.collectArr replaceObjectAtIndex:0 withObject:item];
        }else{
            [self.collectArr addObject:item];
        }
    }else{
        //发布朋友圈
        self.rightItem.enabled = YES;
        if (self.allCount == 9) {
            [self.collectArr replaceObjectAtIndex:0 withObject:item];
        }else{
            [self.collectArr addObject:item];
        }
    }
    

    [self.collectionView reloadData];
    
}
-(NSMutableArray *)collectArr{
    if (!_collectArr) {
        _collectArr = [NSMutableArray new];
    }
    return _collectArr;
}

@end
