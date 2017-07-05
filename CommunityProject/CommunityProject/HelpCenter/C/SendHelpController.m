
//
//  SendHelpController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/4.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SendHelpController.h"
#import "UploadImageNet.h"

#define SendQuestionURL @"appapi/app/addSeekHelp"
@interface SendHelpController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *questionTV;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *placeOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeTwoLabel;
@property (weak, nonatomic) IBOutlet UIView *boottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIView *contributeView;
@property (weak, nonatomic) IBOutlet UILabel *contrubuteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *zeroBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;

@property (weak, nonatomic) IBOutlet UIButton *tenBtn;

@property (weak, nonatomic) IBOutlet UIButton *twentyBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirtyBtn;
@property (weak, nonatomic) IBOutlet UIButton *fivetyBtn;
@property (weak, nonatomic) IBOutlet UIButton *seventyBtn;
@property (weak, nonatomic) IBOutlet UIButton *hundredBtn;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
//标记是否上传图片
@property (nonatomic,assign)BOOL isUpload;

@end

@implementation SendHelpController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //监听键盘变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [self setUI];
}
-(void)keyboardWillShow:(NSNotification *)nofi{
    NSDictionary * userInfo = [nofi userInfo];
    NSValue * aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyRect = [aValue CGRectValue];
    self.viewBottomCons.constant = keyRect.size.height;
    
}
-(void)keyBoardWillHidden:(NSNotification *)nofi{
    //改变输入框的位置
    self.viewBottomCons.constant = 0;
    
}
-(void)setUI{
    self.boottomView.layer.borderWidth = 1;
    self.boottomView.layer.borderColor = UIColorFromRGB(0xd6d6d6).CGColor;
    self.viewHeightCons.constant = 0;
    self.viewBottomCons.constant = 0;
    self.pictureView.hidden = YES;
    self.contributeView.hidden = YES;
    self.closeBtn.hidden = YES;
    [self setButton:self.zeroBtn];
    [self setButton:self.fiveBtn];
    [self setButton:self.tenBtn];
    [self setButton:self.twentyBtn];
    [self setButton:self.thirtyBtn];
    [self setButton:self.fivetyBtn];
    [self setButton:self.seventyBtn];
    [self setButton:self.hundredBtn];
    NSString * contribute = [DEFAULTS objectForKey:@"contributionScore"];
    self.contrubuteCountLabel.attributedText = [ImageUrl changeTextColor:[NSString stringWithFormat:@"您可用的财富 %@",contribute] andFirstRangeStr:@"您可用的财富 " andFirstChangeColor:UIColorFromRGB(0x666666) andSecondRangeStr:contribute andSecondColor:UIColorFromRGB(0x0fbb88)];
    NSInteger count = [contribute integerValue];
    if (count<5) {
        self.zeroBtn.selected = YES;
        self.fiveBtn.enabled = NO;
        self.tenBtn.enabled = NO;
        self.twentyBtn.enabled = NO;
        self.thirtyBtn.enabled = NO;
        self.fivetyBtn.enabled = NO;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;
        
    }else if (count<10&&count>=5) {
        self.zeroBtn.enabled = YES;
        self.fiveBtn.selected = YES;
        self.tenBtn.enabled = NO;
        self.twentyBtn.enabled = NO;
        self.thirtyBtn.enabled = NO;
        self.fivetyBtn.enabled = NO;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;

    }else if (count<20&&count>=10){
        self.zeroBtn.enabled = YES;
        self.fiveBtn.enabled = YES;
        self.tenBtn.selected = YES;
        self.twentyBtn.enabled = NO;
        self.thirtyBtn.enabled = NO;
        self.fivetyBtn.enabled = NO;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;
    }else if (count<30&&count>=20){
        self.zeroBtn.enabled = YES;
        self.fiveBtn.enabled = YES;
        self.tenBtn.enabled = YES;
        self.twentyBtn.selected = YES;
        self.thirtyBtn.enabled = NO;
        self.fivetyBtn.enabled = NO;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;
    }else if (count<50&&count>=30){
        self.zeroBtn.enabled = YES;
        self.fiveBtn.enabled = YES;
        self.tenBtn.enabled = YES;
        self.twentyBtn.enabled = YES;
        self.thirtyBtn.selected = YES;
        self.fivetyBtn.enabled = NO;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;
    }else if (count<70&&count>=50){
        self.zeroBtn.enabled = YES;
        self.fiveBtn.enabled = YES;
        self.tenBtn.enabled = YES;
        self.twentyBtn.enabled = YES;
        self.thirtyBtn.enabled = YES;
        self.fivetyBtn.selected = YES;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;
    }else if (count<100&&count>=70){
        self.zeroBtn.enabled = YES;
        self.fiveBtn.enabled = YES;
        self.tenBtn.enabled = YES;
        self.twentyBtn.enabled = YES;
        self.thirtyBtn.enabled = YES;
        self.fivetyBtn.enabled = YES;
        self.seventyBtn.selected = YES;
        self.hundredBtn.enabled = NO;
    }else{
        self.zeroBtn.enabled = YES;
        self.fiveBtn.enabled = YES;
        self.tenBtn.enabled = YES;
        self.twentyBtn.enabled = YES;
        self.thirtyBtn.enabled = YES;
        self.fivetyBtn.enabled = YES;
        self.seventyBtn.enabled = YES;
        self.hundredBtn.selected = YES;
    }
    
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
    if (textView == self.questionTV) {
        if (textView.text.length == 0) {
            self.placeOneLabel.hidden = NO;
        }else{
            self.placeOneLabel.hidden = YES;
        }
    }else{
        if (textView.text.length == 0) {
            self.placeTwoLabel.hidden = NO;
        }else{
            self.placeTwoLabel.hidden = YES;
        }
    }
}
//进入照相机
- (IBAction)cameraClick:(id)sender {
    [self pushCameraAndAlbums:UIImagePickerControllerSourceTypeCamera];
}
//显示照片的界面
- (IBAction)pictureClick:(id)sender {
    [self common:NO];
}
-(void)common:(BOOL)isHidden{
    [self.contentTV resignFirstResponder];
    [self.questionTV resignFirstResponder];
    self.viewBottomCons.constant = 224;
    self.viewHeightCons.constant = 224;
    self.pictureView.hidden = isHidden;
    self.contributeView.hidden = !isHidden;

}
//显示贡献值界面
- (IBAction)contributeClick:(id)sender {
    [self common:YES];
}
//进入相册
- (IBAction)pushPictureClick:(id)sender {
    [self pushCameraAndAlbums:UIImagePickerControllerSourceTypePhotoLibrary];
   
}
-(void)pushCameraAndAlbums:(UIImagePickerControllerSourceType)type{
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = type;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //dismiss系统的设置自定义
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    self.pictureImageView.image = originalImage;
    self.closeBtn.hidden = NO;
    self.isUpload = YES;
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

- (IBAction)cancleClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//发布提问
- (IBAction)sendClick:(id)sender {
    [self.contentTV resignFirstResponder];
    [self.questionTV resignFirstResponder];
    self.viewBottomCons.constant = 0;
    self.viewHeightCons.constant = 0;
    self.pictureView.hidden = YES;
    self.contributeView.hidden = YES;
    if (self.questionTV.text.length == 0) {
        [self showMessage:@"问题标题没有填写哦！"];
        return;
    }
    if (self.contentTV.text.length == 0) {
        [self showMessage:@"问题介绍没有填写哦！"];
        return;
    }
    NSString * contributeStr;
    if (self.zeroBtn.selected) {
        contributeStr = @"0";
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

    if (contributeStr.length == 0) {
        [self showMessage:@"请设置贡献币"];
        return;
    }
//提交提问
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf send:contributeStr];
    });

}
-(void)send:(NSString *)contributeStr{
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    NSDictionary * params = @{@"userId":userId,@"title":self.questionTV.text,@"content":self.contentTV.text,@"contributionCoin":contributeStr};
    UIImage * image ;
    if (self.isUpload) {
        image = self.pictureImageView.image;
    }else{
        image = nil;
    }
    WeakSelf;
   [UploadImageNet postDataWithUrl:[NSString stringWithFormat:NetURL,SendQuestionURL] andParams:params andImage:image getBlock:^(NSURLResponse *response, NSError *error, id data) {
       dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD hideHUDForView:self.view animated:YES];
       });

       if (error) {
           NSSLog(@"提问求助失败:%@",error);
           [weakSelf showMessage:@"亲，服务器出错咯！"];
       }else{
           NSNumber * code = data[@"code"];
           if ([code intValue] == 200) {
               weakSelf.delegate.isRef = YES;
               [weakSelf.navigationController popViewControllerAnimated:YES];
           }else if([code intValue] == 101){
               [weakSelf showMessage:@"对不起，您不是VIP用户"];
           }else{
               [weakSelf showMessage:@"添加求助失败，请重试！"];
           }
       }
   }];

}

- (IBAction)deletePictureClick:(id)sender {
    self.pictureImageView.image = [UIImage imageNamed:@"bigPicture"];
    self.isUpload = NO;
    self.closeBtn.hidden = YES;
}

-(void)showMessage:(NSString *)msg{
    UIView * msgView = [UIView showViewTitle:msg];
    [self.view addSubview:msgView];
    [UIView animateWithDuration:1.0 animations:^{
        msgView.frame = CGRectMake(20, KMainScreenHeight-150, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
        //完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}

@end
