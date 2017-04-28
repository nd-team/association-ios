//
//  RecommendController.m
//  CommunityProject
//
//  Created by bjike on 17/4/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "RecommendController.h"

@interface RecommendController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *famaleBtn;

@property (weak, nonatomic) IBOutlet UIButton *danceBtn;

@property (weak, nonatomic) IBOutlet UIButton *musicBtn;

@property (weak, nonatomic) IBOutlet UIButton *printBtn;

@property (weak, nonatomic) IBOutlet UIButton *intrusmentBtn;

@property (weak, nonatomic) IBOutlet UIButton *gameBtn;
@property (weak, nonatomic) IBOutlet UIButton *movieBtn;

@property (weak, nonatomic) IBOutlet UIButton *foodBtn;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (weak, nonatomic) IBOutlet UIButton *travelBtn;

@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (weak, nonatomic) IBOutlet UIButton *motionBtn;
@property (weak, nonatomic) IBOutlet UIButton *chessBtn;

@property (weak, nonatomic) IBOutlet UITextField *liveProTF;

@property (weak, nonatomic) IBOutlet UITextField *liveCityTF;

@property (weak, nonatomic) IBOutlet UITextField *liveDisTF;
@property (weak, nonatomic) IBOutlet UITextField *relationshipTF;

@property (weak, nonatomic) IBOutlet UITextField *presiTF;

@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;


@property (weak, nonatomic) IBOutlet UITextField *schoolTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;

@property (weak, nonatomic) IBOutlet UITextField *fatherNameTF;

@property (weak, nonatomic) IBOutlet UITextField *motherNameTF;
@property (weak, nonatomic) IBOutlet UITextField *marryTF;
@property (weak, nonatomic) IBOutlet UITextField *homeProTF;
@property (weak, nonatomic) IBOutlet UITextField *homeCityTF;
@property (weak, nonatomic) IBOutlet UITextField *homeDisTF;
@property (weak, nonatomic) IBOutlet UIButton *quiteBtn;
@property (weak, nonatomic) IBOutlet UIButton *smailBtn;

@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *quickBtn;
//轻浮
@property (weak, nonatomic) IBOutlet UIButton *frivoBtn;
//花心
@property (weak, nonatomic) IBOutlet UIButton *unfaithBtn;

@property (weak, nonatomic) IBOutlet UIButton *douBtn;
@property (weak, nonatomic) IBOutlet UIButton *livelyBtn;
@property (weak, nonatomic) IBOutlet UIButton *coolBtn;

@property (weak, nonatomic) IBOutlet UIButton *honestBtn;
@property (weak, nonatomic) IBOutlet UIButton *cuteBtn;

@property (weak, nonatomic) IBOutlet UIButton *recomendBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation RecommendController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要推荐";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"取消" andLeft:-15 andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self setUI];

}
-(void)setUI{
    [self setTitleButton:self.danceBtn];
    [self setTitleButton:self.musicBtn];
    [self setTitleButton:self.printBtn];
    [self setTitleButton:self.intrusmentBtn];
    [self setTitleButton:self.gameBtn];
    [self setTitleButton:self.movieBtn];
    [self setTitleButton:self.travelBtn];
    [self setTitleButton:self.chessBtn];
    [self setTitleButton:self.foodBtn];
    [self setTitleButton:self.chatBtn];
    [self setTitleButton:self.readBtn];
    [self setTitleButton:self.motionBtn];
    
    [self setTitleButton:self.quiteBtn];
    [self setTitleButton:self.smailBtn];
    [self setTitleButton:self.beautyBtn];
    [self setTitleButton:self.moneyBtn];
    [self setTitleButton:self.quickBtn];
    [self setTitleButton:self.frivoBtn];
    [self setTitleButton:self.unfaithBtn];
    [self setTitleButton:self.douBtn];
    [self setTitleButton:self.livelyBtn];
    [self setTitleButton:self.coolBtn];
    [self setTitleButton:self.honestBtn];
    [self setTitleButton:self.cuteBtn];
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@"noSelBtn"] forState:UIControlStateNormal];
    [self.famaleBtn setBackgroundImage:[UIImage imageNamed:@"noSelBtn"] forState:UIControlStateNormal];
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@"chooseSel"] forState:UIControlStateSelected];
    [self.famaleBtn setBackgroundImage:[UIImage imageNamed:@"chooseSel"] forState:UIControlStateSelected];
    self.liveProTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.liveCityTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.liveDisTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.liveProTF.layer.borderWidth = 1;
    self.liveDisTF.layer.borderWidth = 1;
    self.liveCityTF.layer.borderWidth = 1;
    
    self.homeDisTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.homeProTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.homeCityTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.homeCityTF.layer.borderWidth = 1;
    self.homeProTF.layer.borderWidth = 1;
    self.homeDisTF.layer.borderWidth = 1;
    self.recomendBtn.layer.cornerRadius = 5;
    self.recomendBtn.layer.masksToBounds = YES;
    //手势回收键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    [self.view addGestureRecognizer:tap];

}
-(void)resign{
    self.view.frame = CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight);
    [self.nameLabel resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.schoolTF resignFirstResponder];
    [self.companyTF resignFirstResponder];
    [self.fatherNameTF resignFirstResponder];
    [self.motherNameTF resignFirstResponder];
    [self.marryTF resignFirstResponder];

    
}
-(void)setTitleButton:(UIButton *)btn{
    [btn setBackgroundImage:[UIImage imageNamed:@"hobbyWhite"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"hobbyGreen"] forState:UIControlStateSelected];
    [btn setTitleColor:UIColorFromRGB(0x18bc8b) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x11624a) forState:UIControlStateSelected];

}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)recommendClick:(id)sender {
    
    
}
- (IBAction)manClick:(id)sender {
    self.manBtn.selected = !self.manBtn.selected;
    if (self.manBtn.selected) {
        self.famaleBtn.selected = NO;
    }
}
- (IBAction)famaleClick:(id)sender {
    self.famaleBtn.selected = !self.famaleBtn.selected;
    if (self.famaleBtn.selected) {
        self.manBtn.selected = NO;
    }
}
- (IBAction)danceClick:(id)sender {
    self.danceBtn.selected = !self.danceBtn.selected;
    
}

- (IBAction)musicClick:(id)sender {
    self.musicBtn.selected = !self.musicBtn.selected;
    
}

- (IBAction)printClick:(id)sender {
    self.printBtn.selected = !self.printBtn.selected;
    
}

- (IBAction)instrumentClick:(id)sender {
    self.intrusmentBtn.selected = !self.intrusmentBtn.selected;
    
}

- (IBAction)gameClick:(id)sender {
    self.gameBtn.selected = !self.gameBtn.selected;
    
}

- (IBAction)movieClick:(id)sender {
    self.movieBtn.selected = !self.movieBtn.selected;
    
}

- (IBAction)foodClick:(id)sender {
    self.foodBtn.selected = !self.foodBtn.selected;
}

- (IBAction)chatClick:(id)sender {
    self.chatBtn.selected = !self.chatBtn.selected;

}
- (IBAction)travelClick:(id)sender {
    self.travelBtn.selected = !self.travelBtn.selected;

}

- (IBAction)readClick:(id)sender {
    self.readBtn.selected = !self.readBtn.selected;

}

- (IBAction)motionClick:(id)sender {
    self.motionBtn.selected = !self.motionBtn.selected;

}
- (IBAction)chessClick:(id)sender {
    self.chessBtn.selected = !self.chessBtn.selected;

}

- (IBAction)quiteClick:(id)sender {
    self.quiteBtn.selected = !self.quiteBtn.selected;

}

- (IBAction)smailClick:(id)sender {
    self.smailBtn.selected = !self.smailBtn.selected;

}
- (IBAction)beautyClick:(id)sender {
    self.beautyBtn.selected = !self.beautyBtn.selected;

}

- (IBAction)moneyClick:(id)sender {
    self.moneyBtn.selected = !self.moneyBtn.selected;

}
- (IBAction)quickClick:(id)sender {
    self.quickBtn.selected = !self.quickBtn.selected;

}




- (IBAction)frivoClick:(id)sender {
    self.frivoBtn.selected = !self.frivoBtn.selected;

}

- (IBAction)unfaithClick:(id)sender {
    self.unfaithBtn.selected = !self.unfaithBtn.selected;

}


- (IBAction)douClick:(id)sender {
    self.douBtn.selected = !self.douBtn.selected;

}

- (IBAction)livelyClick:(id)sender {
    self.livelyBtn.selected = !self.livelyBtn.selected;

}

- (IBAction)coolClick:(id)sender {
    self.coolBtn.selected = !self.coolBtn.selected;

}

- (IBAction)honeyClick:(id)sender {
    self.honestBtn.selected = !self.honestBtn.selected;

}
- (IBAction)cuteClick:(id)sender {
    self.cuteBtn.selected = !self.cuteBtn.selected;

}
#pragma mark-textField-Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameLabel) {
        [self.nameLabel resignFirstResponder];
        [self.phoneTF becomeFirstResponder];
    }else if (textField == self.phoneTF){
        [self.phoneTF resignFirstResponder];
        [self.schoolTF becomeFirstResponder];
    }else if (textField == self.schoolTF){
        [self.schoolTF resignFirstResponder];
        [self.companyTF becomeFirstResponder];
    }else if (textField == self.companyTF){
        [self.companyTF resignFirstResponder];
        [self.fatherNameTF becomeFirstResponder];
    }else if (textField == self.fatherNameTF){
        [self.fatherNameTF resignFirstResponder];
        [self.motherNameTF becomeFirstResponder];
    }else if (textField == self.motherNameTF){
        [self.motherNameTF resignFirstResponder];
        [self.marryTF becomeFirstResponder];
        
    }else if (textField == self.marryTF){

        [self resign];
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = textField.frame.origin.y+50-(KMainScreenHeight-216);
    if (textField == self.companyTF||textField == self.schoolTF||textField == self.fatherNameTF||textField == self.motherNameTF||textField == self.marryTF){
        self.view.frame = CGRectMake(0, -offset, KMainScreenWidth, KMainScreenHeight);
        return YES;

    }else if (textField == self.liveProTF||textField == self.liveCityTF||textField == self.liveDisTF||textField == self.relationshipTF||textField == self.presiTF||textField == self.birthdayTF||textField == self.homeProTF||textField == self.homeCityTF||textField == self.homeDisTF){
        return NO;
    }else{
        return YES;
    }
}
- (IBAction)datePickerClick:(id)sender {
}

- (IBAction)finishClick:(id)sender {
}



@end
