//
//  WriteCommentController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/21.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "WriteCommentController.h"
#import "PositionImageCell.h"
#import "UploadImageModel.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import "UploadFilesNet.h"

#define CommentURL @"comment/add"

@interface WriteCommentController ()<UICollectionViewDelegate,UICollectionViewDataSource,CTAssetsPickerControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;

@property (weak, nonatomic) IBOutlet UIButton *fifthBtn;
@property (weak, nonatomic) IBOutlet UITextView *commentTV;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong)NSMutableArray * collectionArr;
@property (nonatomic, strong) PHImageRequestOptions *requestOption;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeightCons;

@property (nonatomic,assign)NSUInteger allCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewHeightCons;
@property (nonatomic,copy)NSString * score;
@property (nonatomic,copy)NSString * userId;

@end

@implementation WriteCommentController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [DEFAULTS objectForKey:@"userId"];

    [self setButton:self.firstBtn];
    [self setButton:self.secondBtn];
    [self setButton:self.thirdBtn];
    [self setButton:self.fourthBtn];
    [self setButton:self.fifthBtn];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PositionImageCell" bundle:nil] forCellWithReuseIdentifier:@"PositionImageCell"];
    self.requestOption = [[PHImageRequestOptions alloc] init];
    self.requestOption.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.allCount = 0;
    //初始化数据
    self.titleLabel.text = self.shopname;
    self.score = @"FIRST";
}
-(void)setButton:(UIButton *)btn{
    [btn setBackgroundImage:[UIImage imageNamed:@"bigDarkStar"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"bigStar"] forState:UIControlStateSelected];
    
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PositionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PositionImageCell" forIndexPath:indexPath];
    cell.uploadModel = self.collectionArr[indexPath.row];
    cell.collectionView = self.collectionView;
    cell.dataArr = self.collectionArr;
    cell.delete = ^(NSIndexPath * selectPath) {
        self.allCount--;
        [self.collectionArr removeObjectAtIndex:selectPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[selectPath]];
    };
    cell.refresh = ^{
        [self.collectionView reloadData];
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
           
                if (weakSelf.allCount == 9 && i == assets.count) {
                    //9张
                    [weakSelf.collectionArr insertObject:item atIndex:self.collectionArr.count-2];
                    //删除最后一张占位图
                    [weakSelf.collectionArr removeObjectAtIndex:9];
                }else{
                    //插入到倒数第二张
                    if (weakSelf.collectionArr.count == 1) {
                        [weakSelf.collectionArr insertObject:item atIndex:0];
                    }else{
                        [weakSelf.collectionArr insertObject:item atIndex:self.collectionArr.count-2];
                    }
                }
                //改变高度
                [weakSelf changeHeight];
        }];
        i++;
    }
    
}
-(void)changeHeight{
    dispatch_async(dispatch_get_main_queue(), ^{

        if (KMainScreenWidth>=375) {
            //一行四个4.7寸 5.5寸
            if (self.allCount < 4) {
                self.collHeightCons.constant = 100;
            }else if(self.allCount < 8 && self.allCount >= 4){
                self.collHeightCons.constant = 200;
            }else{
                self.collHeightCons.constant = 300;
            }
        }else{
            //一行3个
            if (self.allCount < 3) {
                self.collHeightCons.constant = 100;
            }else if(self.allCount < 6 && self.allCount >= 3){
                self.collHeightCons.constant = 200;
            }else{
                self.collHeightCons.constant = 300;
            }
        }
    CGFloat height = self.collectionView.frame.origin.y+66+self.collHeightCons.constant;
    if (height>KMainScreenHeight) {
        self.ViewHeightCons.constant = height;
    }else{
        self.ViewHeightCons.constant = KMainScreenHeight;
    }
        [self.collectionView reloadData];
    });

}
-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset{
    NSInteger max = 0;
    max = 9-self.allCount;
    
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
- (IBAction)cancleClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//提交评价
- (IBAction)sureClick:(id)sender {
    if (![self checkWhite]) {
        return;
    }
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf send];
    });

}
-(void)send{
    WeakSelf;
    NSMutableDictionary * mDic = [NSMutableDictionary new];
    [mDic setValue:self.shopname forKey:@"shopName"];
    [mDic setValue:self.areaId forKey:@"pointId"];
    [mDic setValue:self.area forKey:@"address"];
    [mDic setValue:[NSString stringWithFormat:@"%f",self.latitude] forKey:@"pointX"];
    [mDic setValue:[NSString stringWithFormat:@"%f",self.longitude] forKey:@"pointY"];
    [mDic setValue:self.commentTV.text forKey:@"content"];
    [mDic setValue:@"ALL" forKey:@"visibleType"];
    [mDic setValue:self.score forKey:@"scoreType"];
//    NSSLog(@"%@",mDic);
    NSMutableArray * arr = [NSMutableArray new];
    for (UploadImageModel * model in self.collectionArr) {
        if (!model.isPlaceHolder) {
            [arr addObject:model.image];
        }
    }
//    NSSLog(@"%zi",arr.count);
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    [UploadFilesNet postDataWithUrl:[NSString stringWithFormat:JAVAURL,CommentURL] andParams:mDic andHeader:userId andArray:arr getBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"点评失败：%@",error);
            [weakSelf showMessage:@"服务器出问题咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 0) {
                weakSelf.delegate.isRefresh = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });

            }else{
                [weakSelf showMessage:@"提交评价失败，请重新提交"];
            }
        }
    }];
 
}
-(BOOL)checkWhite{
    BOOL a = YES;
    if ([ImageUrl isEmptyStr:self.commentTV.text]) {
        a= NO;
        [self showMessage:@"评论内容不能为空！"];
    }else if (!self.firstBtn.selected &&!self.secondBtn.selected&&!self.thirdBtn.selected&&!self.fourthBtn.selected&&!self.fifthBtn.selected){
        a = NO;
        [self showMessage:@"请给出您的评分！"];
    }
    return a;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
- (IBAction)firstClick:(id)sender {
    self.score = @"FIRST";
    self.firstBtn.selected = YES;
    self.secondBtn.selected = NO;
    self.thirdBtn.selected = NO;
    self.fourthBtn.selected = NO;
    self.fifthBtn.selected = NO;
}
- (IBAction)secondClick:(id)sender {
    self.score = @"SECOND";
    self.firstBtn.selected = YES;
    self.secondBtn.selected = YES;
    self.thirdBtn.selected = NO;
    self.fourthBtn.selected = NO;
    self.fifthBtn.selected = NO;
}
- (IBAction)thirdClick:(id)sender {
    self.score = @"THIRD";
    self.firstBtn.selected = YES;
    self.secondBtn.selected = YES;
    self.thirdBtn.selected = YES;
    self.fourthBtn.selected = NO;
    self.fifthBtn.selected = NO;
}
- (IBAction)fourthClick:(id)sender {
    self.score = @"FOURTH";
    self.firstBtn.selected = YES;
    self.secondBtn.selected = YES;
    self.thirdBtn.selected = YES;
    self.fourthBtn.selected = YES;
    self.fifthBtn.selected = NO;
}

- (IBAction)fifthClick:(id)sender {
    self.score = @"FIFTH";
    self.firstBtn.selected = YES;
    self.secondBtn.selected = YES;
    self.thirdBtn.selected = YES;
    self.fourthBtn.selected = YES;
    self.fifthBtn.selected = YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text == nil) {
        //return不可用
    }
    if ([text isEqualToString:@"\n"]) {
        [self.commentTV resignFirstResponder];
        return NO;
    }
    return YES;
}
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}
-(NSMutableArray *)collectionArr{
    if (!_collectionArr) {
        _collectionArr = [NSMutableArray new];
        UploadImageModel * item = [UploadImageModel new];
        
        item.image = [UIImage imageNamed:@"uploadImg.png"];
        
        item.isPlaceHolder = YES;
        
        item.isHide = YES;
        [_collectionArr addObject:item];
    }
    return _collectionArr;
}
@end
