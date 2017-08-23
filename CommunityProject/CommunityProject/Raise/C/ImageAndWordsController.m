//
//  ImageAndWordsController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ImageAndWordsController.h"
#import "PositionImageCell.h"

@interface ImageAndWordsController ()<UICollectionViewDelegate,UICollectionViewDataSource,CTAssetsPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic,strong)NSMutableArray * collectionArr;
@property (nonatomic,assign)NSInteger allCount;
@property (nonatomic, strong) PHImageRequestOptions *requestOption;

@end

@implementation ImageAndWordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图文详情";
    self.allCount = 0;
    self.requestOption = [[PHImageRequestOptions alloc] init];
    self.requestOption.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

    UIBarButtonItem * leftItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"取消" andLeft:-15 andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"保存" andLeft:15 andTarget:self Action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PositionImageCell" bundle:nil] forCellWithReuseIdentifier:@"RaiseImageCell"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBoard)];
    [self.view addGestureRecognizer:tap];
}
-(void)hiddenBoard{
    [self.contentTV resignFirstResponder];
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveInfo{
    if ([self checkLoyal]) {
        self.raiseDelegate.words = self.contentTV.text;
        self.raiseDelegate.imageArr = self.collectionArr;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(BOOL)checkLoyal{
    BOOL a = YES;
    if ([ImageUrl isEmptyStr:self.contentTV.text]) {
        a = NO;
        [self showMessage:@"请填写文字"];
    }else if(self.collectionArr.count == 1){
        a = NO;
        [self showMessage:@"请选择少于3张的图片"];

    }
    return a;
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PositionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RaiseImageCell" forIndexPath:indexPath];
    cell.isRaise = YES;
    cell.uploadModel = self.collectionArr[indexPath.row];
    cell.collectionView = self.collectionView;
    cell.dataArr = self.collectionArr;
    cell.delete = ^(NSIndexPath * selectPath) {
        self.allCount--;
        [self.collectionArr removeObjectAtIndex:selectPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[selectPath]];
    };
    cell.change = ^(UploadImageModel *model,NSIndexPath *selectPath) {
        self.allCount--;
        [self.collectionArr removeObjectAtIndex:selectPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[selectPath]];
        [self.collectionArr insertObject:model atIndex:0];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    };
    WeakSelf;
    cell.refresh = ^{
        [weakSelf changeHeight];
    };
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UploadImageModel * model = self.collectionArr[indexPath.row];
    if (model.isPlaceHolder) {
        [self pushMulPhotos];
    }
}
-(void)pushMulPhotos{
    WeakSelf;
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
        [weakSelf presentViewController:picker animated:YES completion:nil];
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
        CGSize targetSize = CGSizeMake(75 * scale, 75 * scale);
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:self.requestOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            UploadImageModel * item = [UploadImageModel new];
            
            item.image = result;
            
            item.isPlaceHolder = NO;
            
            item.isHide = NO;
            
            if (weakSelf.allCount == 3 && i == assets.count) {
                [weakSelf.collectionArr replaceObjectAtIndex:0 withObject:item];
            }else{
                [weakSelf.collectionArr addObject:item];
            }
            [weakSelf changeHeight];
        }];
        i++;
    }
    
}
-(void)changeHeight{
    dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
    });
}
-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset{
    NSInteger max = 0;
    max = 3-self.allCount;
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
-(NSMutableArray *)collectionArr{
    if (!_collectionArr) {
        _collectionArr = [NSMutableArray new];
        UploadImageModel * item = [UploadImageModel new];
        
        item.image = [UIImage imageNamed:@"addFriend.png"];
        
        item.isPlaceHolder = YES;
        
        item.isHide = YES;
        [_collectionArr addObject:item];
    }
    return _collectionArr;
}
@end
