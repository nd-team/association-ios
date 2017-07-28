//
//  SendGoodsController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SendGoodsController.h"
#import "AuthorityController.h"
#import "TrafficeUploadNet.h"
#import "GoodsDetailController.h"

#define SendURL @"appapi/app/addShare"
@interface SendGoodsController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *topPlace;

@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *firstTV;
@property (weak, nonatomic) IBOutlet UITextView *secondTV;
@property (weak, nonatomic) IBOutlet UILabel *synopsisPlace;
@property (weak, nonatomic) IBOutlet UILabel *contentPlace;
@property (weak, nonatomic) IBOutlet UIView *authView;
@property (weak, nonatomic) IBOutlet UILabel *isPublicLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authHeightCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputBottomCons;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *choosePictureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightCons;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downHeightCons;

//标记是否上传图片
@property (nonatomic,assign)BOOL isUpload;
//标记是背景图还是出售图
@property (nonatomic,assign)BOOL isBack;

@end

@implementation SendGoodsController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.authStr.length != 0) {
        self.isPublicLabel.text = self.authStr;
    }
    if (self.downStr.length != 0) {
        self.downLabel.text = self.downStr;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    //监听键盘变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [self setUI];
}
-(void)keyboardWillShow:(NSNotification *)nofi{
    NSDictionary * userInfo = [nofi userInfo];
    NSValue * aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyRect = [aValue CGRectValue];
    self.inputBottomCons.constant = keyRect.size.height;
    
}
-(void)keyBoardWillHidden:(NSNotification *)nofi{
    //改变输入框的位置
    self.inputBottomCons.constant = 0;
    
}
-(void)setUI{
    self.isBack = YES;
    self.inputView.layer.borderWidth = 1;
    self.inputView.layer.borderColor = UIColorFromRGB(0xd6d6d6).CGColor;
    self.backImageView.layer.borderWidth = 1;
    self.backImageView.layer.borderColor = UIColorFromRGB(0xd6d6d6).CGColor;
    NSInteger  checkVip = [DEFAULTS integerForKey:@"checkVip"];
    if (checkVip == 1) {
        self.authHeightCons.constant = 45;
        self.downHeightCons.constant = 45;
    }else{
        self.authHeightCons.constant = 0;
        self.downHeightCons.constant = 0;
    }
    self.bottomViewHeightCons.constant = 0;
    self.inputBottomCons.constant = 0;
    self.delBtn.hidden = YES;
    
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView == self.firstTV) {
        if (textView.text.length == 0) {
            self.synopsisPlace.hidden = NO;
        }else{
            self.synopsisPlace.hidden = YES;
        }
    }else{
        if (textView.text.length == 0) {
            self.contentPlace.hidden = NO;
        }else{
            self.contentPlace.hidden = YES;
        }
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //dismiss系统的设置自定义
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    if (self.isBack) {
        self.topPlace.hidden = YES;
        self.backImageView.image = originalImage;
    }else{
        self.pictureImageView.image = originalImage;
        self.delBtn.hidden = NO;
        self.isUpload = YES;
    }
    
}
-(void)common{
    [self hiddenBoard];
    self.bottomViewHeightCons.constant = 224;
    self.inputBottomCons.constant = 224;
}
-(void)pushCameraAndAlbums:(UIImagePickerControllerSourceType)type{
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = type;
    [self presentViewController:picker animated:YES completion:nil];
}

//权限管理
- (IBAction)authClick:(id)sender {
    [self hiddenBoard];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    AuthorityController * auth = [sb instantiateViewControllerWithIdentifier:@"AuthorityController"];
    auth.goodsDelegate = self;
    auth.type = 4;
    [self.navigationController pushViewController:auth animated:YES];
}
//添加背景图
- (IBAction)addBackImageClick:(id)sender {
    self.isBack = YES;
    [self pushCameraAndAlbums:UIImagePickerControllerSourceTypePhotoLibrary];
    
}
//发布
- (IBAction)sendClick:(id)sender {
    [self hiddenBoard];
    if ([self checkLegal]) {
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf send];
        });
        
    }
    
}
-(BOOL)checkLegal{
    BOOL a = YES;
    if (self.backImageView.image == nil) {
        a = NO;
        [self showMessage:@"亲，请添加背景图"];
    }else if ([ImageUrl isEmptyStr:self.titleTF.text]) {
        a = NO;
        [self showMessage:@"亲，请输入标题"];
    }else if([ImageUrl isEmptyStr:self.firstTV.text]) {
        a= NO;
        [self showMessage:@"亲，请填写简介"];
    }else if([ImageUrl isEmptyStr:self.secondTV.text]) {
        a= NO;
        [self showMessage:@"亲，请填写正文"];
    }
    
    return a;
}
-(void)hiddenBoard{
    [self.firstTV resignFirstResponder];
    [self.secondTV resignFirstResponder];
    [self.titleTF resignFirstResponder];
}
-(void)send{
    NSDictionary *dict = @{@"userId":self.userId,@"arctitle":self.titleTF.text,@"synopsis":self.firstTV.text,@"shareContent":self.secondTV.text,@"status":[self status:self.isPublicLabel.text],@"isDownload":[self status:self.downLabel.text]};
    UIImage * image;
    if (self.isUpload) {
        image = self.pictureImageView.image;
    }else{
        image = nil;
    }
    WeakSelf;
    [TrafficeUploadNet postDataWithUrl:[NSString stringWithFormat:NetURL,SendURL] andParams:dict andFirstImage:self.backImageView.image andSecondImage:image getBlock:^(NSURLResponse *response, NSError *error, id data) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (error) {
            NSSLog(@"发布干货失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                weakSelf.delegate.isRef = YES;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showMessage:@"发布干货失败！"];
            }
        }
    }];
    
}
-(NSString *)status:(NSString *)str{
    NSString * status;
    if ([str isEqualToString:@"公开"]) {
        status = @"0";
    }else{
        status = @"1";
    }
    return status;
}

- (IBAction)deleteClick:(id)sender {
    self.pictureImageView.image = [UIImage imageNamed:@"bigPicture"];
    self.isUpload = NO;
    self.delBtn.hidden = YES;
}
- (IBAction)cameraClick:(id)sender {
    self.isBack = NO;
    [self common];
    [self pushCameraAndAlbums:UIImagePickerControllerSourceTypeCamera];
    
}

- (IBAction)showPictureClick:(id)sender {
    [self common];
    
}
//进入相册
- (IBAction)pushAlbumsClick:(id)sender {
    self.isBack = NO;
    [self pushCameraAndAlbums:UIImagePickerControllerSourceTypePhotoLibrary];

}

//预览
- (IBAction)lookClick:(id)sender {
    [self hiddenBoard];
    if ([self checkLegal]) {
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSString * nick = [userDefault objectForKey:@"nickname"];
        NSString *userUrl = [userDefault objectForKey:@"userPortraitUrl"];
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Goods" bundle:nil];
        GoodsDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailController"];
        detail.isLook = YES;
        detail.titleStr = self.titleTF.text;
        detail.content = self.firstTV.text;
        detail.nickname = nick;
        detail.headUrl = userUrl;
        detail.backImage = self.backImageView.image;
        if (self.isUpload) {
            if (self.pictureImageView.image) {
                detail.buyImage = self.pictureImageView.image;
            }
        }
        detail.time = [NowDate currentDetailTime];
        detail.buyContent = self.secondTV.text;
        detail.status = [self status:self.isPublicLabel.text];
        detail.isDown = [self status:self.downLabel.text];
        [self.navigationController pushViewController:detail animated:YES];
        UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
    }
}
//设置谁可以下载
- (IBAction)downClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    AuthorityController * auth = [sb instantiateViewControllerWithIdentifier:@"AuthorityController"];
    auth.goodsDelegate = self;
    auth.type = 5;
    [self.navigationController pushViewController:auth animated:YES];
}

//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
    
}

@end
