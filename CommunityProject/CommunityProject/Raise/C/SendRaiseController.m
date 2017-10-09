//
//  SendRaiseController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SendRaiseController.h"
#import "ImageAndWordsController.h"
#import "SendRaiseCell.h"
#import "RaiseGoodsListCell.h"
#import "WordsDetailController.h"
#import "PositionImageCell.h"

@interface SendRaiseController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UITextView *introductionTV;
@property (weak, nonatomic) IBOutlet UILabel *inPlaceHolderLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextField *helpMoneyTF;

@property (weak, nonatomic) IBOutlet UITextField *helpDayTF;

@property (weak, nonatomic) IBOutlet UITextField *goodObjectivetf;
@property (weak, nonatomic) IBOutlet UITextField *goodsMoneyTF;

@property (weak, nonatomic) IBOutlet UITextField *goodsDayTF;

@property (weak, nonatomic) IBOutlet UITableView *goodsTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *chooseTypeView;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic,strong)NSArray * pickArr;
//保存项目标题

@property (nonatomic,copy)NSString * projectName;

//@property (nonatomic,strong)NSMutableArray * dataArr;
//商品个数
@property (nonatomic,assign)int count;
//图片
@property (nonatomic,strong)NSMutableArray * collectionArr;
@property (nonatomic,assign)NSInteger allCount;
@property (nonatomic, strong) PHImageRequestOptions *requestOption;

@property (nonatomic,assign)NSInteger selectRow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightCons;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpWidthCons;

@end

@implementation SendRaiseController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.chooseTypeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.count = 3;
    self.allCount = 0;
    self.goodsView.hidden = YES;
    self.chooseTypeView.hidden = YES;
    self.pickArr = @[@"产品众筹",@"求助众筹"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PositionImageCell" bundle:nil] forCellWithReuseIdentifier:@"HelpRaiseImageCell"];
    self.requestOption = [[PHImageRequestOptions alloc] init];
    self.requestOption.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [self.goodsTableView setEditing:YES animated:YES];

}
//选择众筹类型
- (IBAction)chooseTypeClick:(id)sender {
    if ([self.pickerView.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.pickerView.delegate pickerView:self.pickerView didSelectRow:0 inComponent:0];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chooseTypeView.hidden = NO;
    });
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        //项目标题
        SendRaiseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SendRaiseCell"];
        cell.block = ^(NSString *titleStr) {
            self.projectName = titleStr;
        };
        return cell;

    }else{
        //商品
        RaiseGoodsListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RaiseGoodsListCell"];
        if (indexPath.row < self.count-1) {
            cell.goodsListLabel.hidden = NO;
            cell.goodsListLabel.text = [NSString stringWithFormat:@"商品%zi:",indexPath.row+1];
        }else{
            cell.goodsListLabel.hidden = YES;    
        }
        return cell;

    }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 1;
    }else{
        return self.count;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.goodsTableView) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Raise" bundle:nil];
        WordsDetailController * words = [sb instantiateViewControllerWithIdentifier:@"WordsDetailController"];
        words.name = @"文字详情";
        words.place = @"请输入商品详情";
        words.delegate = self;
        [self.navigationController pushViewController:words animated:YES];
    }
}
//编辑模式
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.goodsTableView) {
        return YES;
    }else{
        return NO;
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.goodsTableView) {
        if (indexPath.row > 1 && indexPath.row <= self.count-2) {
            //删除模式
            return UITableViewCellEditingStyleDelete;
        }else if (indexPath.row == self.count-1){
            //插入模式
            return UITableViewCellEditingStyleInsert;
            
        }else{
            //第一二个没有
            return UITableViewCellEditingStyleNone;
        }
    }else{
        return UITableViewCellEditingStyleNone;
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.goodsTableView) {
        return @"删除";
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.goodsTableView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.goodsTableView beginUpdates];
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                self.count--;
                //            RaiseGoodsListCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                //清空TF内容
                //            cell.chooseTF.text = @"";
                //删除那行的数据
                //            [self.objectiveMArr removeObjectAtIndex:indexPath.row];
                //删除一个cell
                NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                [self.goodsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
            } else if (editingStyle == UITableViewCellEditingStyleInsert){
                self.count++;
                //增加一个cell
                NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                [self.goodsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
            }//产品众筹
            if (self.selectRow == 0) {
                self.tableHeightCons.constant = self.count * 55;
                //改变尾部高度
                CGRect frame = self.scrollView.frame;
                self.helpHeightCons.constant = self.tableHeightCons.constant+500;
                frame.size.height = self.tableHeightCons.constant+500;
                self.scrollView.frame = frame;
               
            }
            [self.goodsTableView endUpdates];
            [self.goodsTableView reloadData];
        });
       
    }
}

#pragma mark - pickerView-delegate and DataSources
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [UILabel new];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
        pickerLabel.textColor = UIColorFromRGB(0x666666);
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    }
    //去除线条
    [[pickerView.subviews objectAtIndex:1]setHidden:true];
    [[pickerView.subviews objectAtIndex:2]setHidden:true];
    return pickerLabel;
}
//返回组件高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 50;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //改变选择时的颜色
    UILabel * label = (UILabel *)[pickerView viewForRow:row forComponent:0];
    label.backgroundColor = [UIColor whiteColor];
    self.typeLabel.text = self.pickArr[row];
    self.selectRow = row;
    if(row == 1){
        //求助众筹高度不变
        CGRect frame = self.scrollView.frame;
        self.helpHeightCons.constant = 500;
        frame.size.height = 500;
        self.scrollView.frame = frame;
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickArr[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickArr.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PositionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HelpRaiseImageCell" forIndexPath:indexPath];
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
    NSSLog(@"%zi==count:%zi",self.allCount,assets.count);
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
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}

//求助众筹提交
- (IBAction)helpSubmitClick:(id)sender {
    
}
//进入图文详情
- (IBAction)pushImageAndContentClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Raise" bundle:nil];
    ImageAndWordsController * words = [sb instantiateViewControllerWithIdentifier:@"ImageAndWordsController"];
    words.raiseDelegate = self;
    [self.navigationController pushViewController:words animated:YES];

}
//产品众筹提交
- (IBAction)goodsSubmitClick:(id)sender {
    
}
- (IBAction)cancleClick:(id)sender {
    [self hidden];
}
- (IBAction)finishClick:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chooseTypeView.hidden = YES;
        if (self.selectRow == 0) {
            self.helpView.hidden = YES;
            self.goodsView.hidden = NO;
        }else{
            self.helpView.hidden = NO;
            self.goodsView.hidden = YES;
        }
    });
}
-(void)hidden{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chooseTypeView.hidden = YES;
    });
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //众筹目的
    if (textField == self.goodObjectivetf) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Raise" bundle:nil];
        WordsDetailController * words = [sb instantiateViewControllerWithIdentifier:@"WordsDetailController"];
        words.name = @"众筹目的";
        words.place = @"请输入40~140字以内";
        [self.navigationController pushViewController:words animated:YES];
        return NO;
    }
    return YES;
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pushBackImageClick:(id)sender {
    [self pushAlbums];
}
-(void)pushAlbums{
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //dismiss系统的设置自定义
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    self.backImageView.image = originalImage;
}
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.helpWidthCons.constant = KMainScreenWidth;
    
}
-(NSMutableArray *)objectiveMArr{
    if (!_objectiveMArr) {
        _objectiveMArr = [NSMutableArray new];
    }
    return _objectiveMArr;
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
