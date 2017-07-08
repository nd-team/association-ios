//
//  SendTrafficController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/7.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SendTrafficController.h"
#import "AuthorityController.h"
#import "TrafficeUploadNet.h"
#import "TrafficDetailController.h"

#define SendURL @"appapi/app/dealBuy"

@interface SendTrafficController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *topPlace;

@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *firstTV;
@property (weak, nonatomic) IBOutlet UITextView *secondTV;
@property (weak, nonatomic) IBOutlet UILabel *actPlace;
@property (weak, nonatomic) IBOutlet UILabel *hidePlace;
@property (weak, nonatomic) IBOutlet UIView *authView;
@property (weak, nonatomic) IBOutlet UILabel *isPublicLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authHeightCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputBottomCons;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *contributeView;

@property (weak, nonatomic) IBOutlet UILabel *avaiLabel;
@property (weak, nonatomic) IBOutlet UIView *choosePictureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightCons;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *zeroBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;

@property (weak, nonatomic) IBOutlet UIButton *tenBtn;

@property (weak, nonatomic) IBOutlet UIButton *twentyBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirtyBtn;
@property (weak, nonatomic) IBOutlet UIButton *fivetyBtn;
@property (weak, nonatomic) IBOutlet UIButton *seventyBtn;
@property (weak, nonatomic) IBOutlet UIButton *hundredBtn;
//标记是否上传图片
@property (nonatomic,assign)BOOL isUpload;
//标记是背景图还是出售图
@property (nonatomic,assign)BOOL isBack;

@end

@implementation SendTrafficController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.authStr.length != 0) {
        self.isPublicLabel.text = self.authStr;
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
    self.secondTV.layer.borderWidth = 1;
    self.secondTV.layer.borderColor = UIColorFromRGB(0xd6d6d6).CGColor;
    NSInteger  checkVip = [DEFAULTS integerForKey:@"checkVip"];
    if (checkVip == 1) {
        self.authHeightCons.constant = 45;
    }else{
        self.authHeightCons.constant = 0;
    }
    self.bottomViewHeightCons.constant = 0;
    self.inputBottomCons.constant = 0;
    self.choosePictureView.hidden = YES;
    self.contributeView.hidden = YES;
    self.delBtn.hidden = YES;
    [self setButton:self.zeroBtn];
    [self setButton:self.fiveBtn];
    [self setButton:self.tenBtn];
    [self setButton:self.twentyBtn];
    [self setButton:self.thirtyBtn];
    [self setButton:self.fivetyBtn];
    [self setButton:self.seventyBtn];
    [self setButton:self.hundredBtn];
    NSString * contribute = [DEFAULTS objectForKey:@"contributionScore"];
    self.avaiLabel.attributedText = [ImageUrl changeTextColor:[NSString stringWithFormat:@"您可用的财富 %@",contribute] andFirstRangeStr:@"您可用的财富 " andFirstChangeColor:UIColorFromRGB(0x666666) andSecondRangeStr:contribute andSecondColor:UIColorFromRGB(0x0fbb88)];
    
}
-(void)setButton:(UIButton *)btn{
    [btn setBackgroundImage:[UIImage imageNamed:@"contributeNor"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"contributeSel"] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"contributeDis"] forState:UIControlStateDisabled];
    [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateDisabled];
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView == self.firstTV) {
        if (textView.text.length == 0) {
            self.actPlace.hidden = NO;
        }else{
            self.actPlace.hidden = YES;
        }
    }else{
        if (textView.text.length == 0) {
            self.hidePlace.hidden = NO;
        }else{
            self.hidePlace.hidden = YES;
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
- (IBAction)cameraClick:(id)sender {
    [self pushCameraAndAlbums:UIImagePickerControllerSourceTypeCamera];

}

- (IBAction)showPictureClick:(id)sender {
    [self common:NO];

}
- (IBAction)moneyClick:(id)sender {
    [self common:YES];

}
- (IBAction)pushAlbumsClick:(id)sender {
    self.isBack = NO;
    [self pushCameraAndAlbums:UIImagePickerControllerSourceTypePhotoLibrary];

}
-(void)common:(BOOL)isHidden{
    [self.titleTF resignFirstResponder];
    [self.firstTV resignFirstResponder];
    [self.secondTV resignFirstResponder];
    self.bottomViewHeightCons.constant = 224;
    self.inputBottomCons.constant = 224;
    self.choosePictureView.hidden = isHidden;
    self.contributeView.hidden = !isHidden;
    
}
-(void)pushCameraAndAlbums:(UIImagePickerControllerSourceType)type{
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = type;
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)deletePictureClick:(id)sender {
    self.pictureImageView.image = [UIImage imageNamed:@"bigPicture"];
    self.isUpload = NO;
    self.delBtn.hidden = YES;
}
- (IBAction)zeroClick:(id)sender {
    self.zeroBtn.selected = YES;
    self.twentyBtn.selected = NO;
    self.fiveBtn.selected = NO;
    self.tenBtn.selected = NO;
    self.seventyBtn.selected = NO;
    self.thirtyBtn.selected = NO;
    self.hundredBtn.selected = NO;
    self.fivetyBtn.selected = NO;
    
}
- (IBAction)fiveClick:(id)sender {
    self.fiveBtn.selected = YES;
    self.zeroBtn.selected = NO;
    self.twentyBtn.selected = NO;
    self.tenBtn.selected = NO;
    self.seventyBtn.selected = NO;
    self.thirtyBtn.selected = NO;
    self.hundredBtn.selected = NO;
    self.fivetyBtn.selected = NO;
    
}
- (IBAction)tenClick:(id)sender {
    self.tenBtn.selected = YES;
    self.zeroBtn.selected = NO;
    self.fiveBtn.selected = NO;
    self.twentyBtn.selected = NO;
    self.seventyBtn.selected = NO;
    self.thirtyBtn.selected = NO;
    self.hundredBtn.selected = NO;
    self.fivetyBtn.selected = NO;
    
}

- (IBAction)twentyClick:(id)sender {
    self.twentyBtn.selected = YES;
    self.zeroBtn.selected = NO;
    self.fiveBtn.selected = NO;
    self.tenBtn.selected = NO;
    self.seventyBtn.selected = NO;
    self.thirtyBtn.selected = NO;
    self.hundredBtn.selected = NO;
    self.fivetyBtn.selected = NO;
    
}
- (IBAction)thirtyClick:(id)sender {
    self.thirtyBtn.selected = YES;
    self.zeroBtn.selected = NO;
    self.fiveBtn.selected = NO;
    self.tenBtn.selected = NO;
    self.twentyBtn.selected = NO;
    self.fivetyBtn.selected = NO;
    self.seventyBtn.selected = NO;
    self.hundredBtn.selected = NO;
    
}
- (IBAction)fivetyClick:(id)sender {
    self.fivetyBtn.selected = YES;
    self.zeroBtn.selected = NO;
    self.fiveBtn.selected = NO;
    self.tenBtn.selected = NO;
    self.twentyBtn.selected = NO;
    self.thirtyBtn.selected = NO;
    self.seventyBtn.selected = NO;
    self.hundredBtn.selected = NO;
    
}
- (IBAction)seventyClick:(id)sender {
    self.seventyBtn.selected = YES;
    self.hundredBtn.selected = NO;
    self.zeroBtn.selected = NO;
    self.fiveBtn.selected = NO;
    self.tenBtn.selected = NO;
    self.twentyBtn.selected = NO;
    self.thirtyBtn.selected = NO;
    self.fivetyBtn.selected = NO;
    
}
- (IBAction)hundredClick:(id)sender {
    self.hundredBtn.selected = YES;
    self.zeroBtn.selected = NO;
    self.fiveBtn.selected = NO;
    self.tenBtn.selected = NO;
    self.twentyBtn.selected = NO;
    self.thirtyBtn.selected = NO;
    self.fivetyBtn.selected = NO;
    self.seventyBtn.selected = NO;
    
}
//权限管理
- (IBAction)authClick:(id)sender {
    [self hiddenBoard];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    AuthorityController * auth = [sb instantiateViewControllerWithIdentifier:@"AuthorityController"];
    auth.trafficDelegate = self;
    auth.type = 3;
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
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
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
        [self showMessage:@"亲，请填写正文"];
    }else if([ImageUrl isEmptyStr:self.secondTV.text]) {
        a= NO;
        [self showMessage:@"亲，请填写要贩卖的灵感"];
    }else if (!self.zeroBtn.selected && !self.fiveBtn.selected &&!self.tenBtn.selected&&!self.twentyBtn.selected&&!self.thirtyBtn.selected&&!self.fivetyBtn.selected&&!self.seventyBtn.selected&&!self.hundredBtn.selected) {
        [self showMessage:@"亲，请选择你的贡献币"];
    }
    
    return a;
}
-(void)hiddenBoard{
    [self.firstTV resignFirstResponder];
    [self.secondTV resignFirstResponder];
    [self.titleTF resignFirstResponder];
}
-(NSString *)contribute{
    NSString * contributeStr;
    if (self.zeroBtn.selected) {
        contributeStr = @"1";
    }
    if (self.fiveBtn.selected) {
        contributeStr = @"5";
    }
    if (self.tenBtn.selected) {
        contributeStr = @"10";
    }
    if (self.twentyBtn.selected) {
        contributeStr = @"20";
    }
    if (self.thirtyBtn.selected) {
        contributeStr = @"30";
    }
    if (self.fivetyBtn.selected) {
        contributeStr = @"50";
    }
    if (self.seventyBtn.selected) {
        contributeStr = @"70";
    }
    if (self.hundredBtn.selected) {
        contributeStr = @"100";
    }
    return contributeStr;
}
-(void)send{
    NSDictionary *dict = @{@"userId":self.userId,@"title":self.titleTF.text,@"content":self.firstTV.text,@"dealContent":self.secondTV.text,@"status":[self status],@"dealContribution":[self contribute]};
    UIImage * image;
    if (self.isUpload) {
        image = self.pictureImageView.image;
    }else{
        image = nil;
    }
    WeakSelf;
    [TrafficeUploadNet postDataWithUrl:[NSString stringWithFormat:NetURL,SendURL] andParams:dict andFirstImage:self.backImageView.image andSecondImage:image getBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
        if (error) {
            NSSLog(@"发布灵感失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                weakSelf.delegate.isRef = YES;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showMessage:@"发布灵感失败！"];
            }
        }
    }];

}
-(NSString *)status{
    NSString * status;
    if ([self.isPublicLabel.text isEqualToString:@"公开"]) {
        status = @"0";
    }else{
        status = @"1";
    }
    return status;
}
//预览
- (IBAction)lookClick:(id)sender {
    [self hiddenBoard];
    if ([self checkLegal]) {
        
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSString * nick = [userDefault objectForKey:@"nickname"];
        NSString *userUrl = [userDefault objectForKey:@"userPortraitUrl"];
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"TrafficeOfInsporation" bundle:nil];
        TrafficDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"TrafficDetailController"];
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
        detail.contributeCount = [self contribute];
        detail.status = [self status];
        [self.navigationController pushViewController:detail animated:YES];
        UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
    }
}
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}
-(void)showMessage:(NSString *)msg{
    UIView * msgView = [UIView showViewTitle:msg];

    [self.view addSubview:msgView];
    [UIView animateWithDuration:3.0 animations:^{
        msgView.frame = CGRectMake(20, KMainScreenHeight-150, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
//        完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}

@end
