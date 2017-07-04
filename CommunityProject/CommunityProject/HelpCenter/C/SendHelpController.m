
//
//  SendHelpController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/4.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SendHelpController.h"

@interface SendHelpController ()<UITextViewDelegate>
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



@end

@implementation SendHelpController

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
    if (count<10) {
        self.zeroBtn.enabled = YES;
        self.fiveBtn.selected = YES;
        self.tenBtn.enabled = NO;
        self.twentyBtn.enabled = NO;
        self.thirtyBtn.enabled = NO;
        self.fivetyBtn.enabled = NO;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;

    }else if (count<20){
        self.zeroBtn.enabled = YES;
        self.fiveBtn.enabled = YES;
        self.tenBtn.selected = YES;
        self.twentyBtn.enabled = NO;
        self.thirtyBtn.enabled = NO;
        self.fivetyBtn.enabled = NO;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;
    }else if (count<30){
        self.zeroBtn.enabled = YES;
        self.fiveBtn.enabled = YES;
        self.tenBtn.enabled = YES;
        self.twentyBtn.selected = YES;
        self.thirtyBtn.enabled = NO;
        self.fivetyBtn.enabled = NO;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;
    }else if (count<50){
        self.zeroBtn.enabled = YES;
        self.fiveBtn.enabled = YES;
        self.tenBtn.enabled = YES;
        self.twentyBtn.enabled = YES;
        self.thirtyBtn.selected = YES;
        self.fivetyBtn.enabled = NO;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;
    }else if (count<70){
        self.zeroBtn.enabled = YES;
        self.fiveBtn.enabled = YES;
        self.tenBtn.enabled = YES;
        self.twentyBtn.enabled = YES;
        self.thirtyBtn.enabled = YES;
        self.fivetyBtn.selected = YES;
        self.seventyBtn.enabled = NO;
        self.hundredBtn.enabled = NO;
    }else if (count<100){
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
    
}
//显示照片的界面
- (IBAction)pictureClick:(id)sender {
    
    
}
//显示贡献值界面
- (IBAction)contributeClick:(id)sender {
    
}
//进入相册
- (IBAction)pushPictureClick:(id)sender {
    
    
}

- (IBAction)zeroClick:(id)sender {
    
}
- (IBAction)fiveClick:(id)sender {
    
}
- (IBAction)tenClick:(id)sender {
    
}

- (IBAction)twentyClick:(id)sender {
    
}
- (IBAction)thirtyClick:(id)sender {
    
}
- (IBAction)fivetyClick:(id)sender {
    
}
- (IBAction)seventyClick:(id)sender {
    
}
- (IBAction)hundredClick:(id)sender {
    
}

- (IBAction)cancleClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//发布提问
- (IBAction)sendClick:(id)sender {
    
}


@end
