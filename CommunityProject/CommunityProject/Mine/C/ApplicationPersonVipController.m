//
//  ApplicationPersonVipController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ApplicationPersonVipController.h"

#define ApplicationVIPURL @"appapi/app/applyVip"

@interface ApplicationPersonVipController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *famaleBtn;
//爱好
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

@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;

@property (weak, nonatomic) IBOutlet UITextField *acadenmicTF;

@property (weak, nonatomic) IBOutlet UITextField *schoolTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *postTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *qqTF;


@property (weak, nonatomic) IBOutlet UITextField *marryTF;
@property (weak, nonatomic) IBOutlet UITextField *homeProTF;
@property (weak, nonatomic) IBOutlet UITextField *homeCityTF;
@property (weak, nonatomic) IBOutlet UITextField *homeDisTF;
//性格
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
//已婚需要填写的
@property (weak, nonatomic) IBOutlet UITextField *wifeNameTF;

@property (weak, nonatomic) IBOutlet UITextField *childNameTF;
@property (weak, nonatomic) IBOutlet UITextField *childSchoolTF;
@property (weak, nonatomic) IBOutlet UIView *marryView;
@property (weak, nonatomic) IBOutlet UILabel *wifeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wifeLabel;

@property (weak, nonatomic) IBOutlet UIView *lineOneView;

@property (weak, nonatomic) IBOutlet UILabel *childNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *childLabel;
@property (weak, nonatomic) IBOutlet UILabel *childSchoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *childScLabel;

@property (weak, nonatomic) IBOutlet UITextField *fatherNameTF;

@property (weak, nonatomic) IBOutlet UITextField *motherNameTF;

@property (weak, nonatomic) IBOutlet UITextField *wechatTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marryHeightCons;

//生日
@property (nonatomic,copy)NSString * birthday;

//所有数据
@property (nonatomic,strong)NSArray *allArr;
//省份数据
@property (nonatomic,strong)NSMutableArray * provinceArr;
//城市数据
@property (nonatomic,strong)NSMutableArray * cityArr;
//区县数据
@property (nonatomic,strong)NSMutableArray * districtArr;
//索引
@property (nonatomic,assign)NSInteger proIndex;

@property (nonatomic,assign)NSInteger cityIndex;
@property (nonatomic,assign)NSInteger districtIndex;

@property (nonatomic,assign)NSInteger marryIndex;
//婚姻
@property (nonatomic,strong)NSArray * marryArr;
//学历
@property (nonatomic,assign)NSInteger  degreeIndex;
@property (nonatomic,strong)NSArray * degreeArr;
//行业
@property (nonatomic,assign)NSInteger  industryIndex;
@property (nonatomic,strong)NSArray * industryArr;
//标记pickerView的数据源 1,2,3地址，7婚姻，4，5，6是籍贯,8学历，9行业，10生日
@property (nonatomic,assign)int flag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
@property (weak, nonatomic) IBOutlet UITextField *industryTF;

@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong)UIWindow * window;
//区分消息提示
@property (nonatomic,assign)BOOL isMessage;

@property (nonatomic,copy)NSString * userId;
//计数 爱好选中3项 第四次的时候提示用户 并且不能选中，性格2项
@property (nonatomic,assign)NSInteger count1;
@property (nonatomic,assign)NSInteger count2;
@end

@implementation ApplicationPersonVipController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请VIP";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    self.count1 = 0;
    self.count2 = 0;
    [self setUI];
    
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUI{
    self.bottomView.hidden = YES;
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
    //性格
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
    
    [self commonUI:YES];
    self.marryHeightCons.constant = 0;
    //手势回收键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    [self.view addGestureRecognizer:tap];
    
}
-(void)commonUI:(BOOL)isHidden{
    self.wifeNameLabel.hidden = isHidden;
    self.wifeLabel.hidden = isHidden;
    self.childNameLabel.hidden = isHidden;
    self.childLabel.hidden = isHidden;
    self.childSchoolLabel.hidden = isHidden;
    self.childScLabel.hidden = isHidden;
    self.lineOneView.hidden = isHidden;
    self.wifeNameTF.hidden = isHidden;
    self.childNameTF.hidden = isHidden;
    self.childSchoolTF.hidden = isHidden;
    if (isHidden) {
        self.viewHeightCons.constant = 1300;
    }else{
        self.viewHeightCons.constant = 1600;
        
    }
}
-(void)resign{
    self.view.frame = CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight);
    [self.nameLabel resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.schoolTF resignFirstResponder];
    [self.companyTF resignFirstResponder];
    [self.postTF resignFirstResponder];
    [self.acadenmicTF resignFirstResponder];
    [self.qqTF resignFirstResponder];
    [self.emailTF resignFirstResponder];
    [self.wechatTF resignFirstResponder];
    [self.fatherNameTF resignFirstResponder];
    [self.motherNameTF resignFirstResponder];
    [self.wifeNameTF resignFirstResponder];
    [self.childNameTF resignFirstResponder];
    [self.childSchoolTF resignFirstResponder];
    
}
-(void)setTitleButton:(UIButton *)btn{
    [btn setBackgroundImage:[UIImage imageNamed:@"hobbyWhite"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"hobbyGreen"] forState:UIControlStateSelected];
    [btn setTitleColor:UIColorFromRGB(0x18bc8b) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x11624a) forState:UIControlStateSelected];
    
}
//信息确认
- (IBAction)recommendClick:(id)sender {
    [self resign];
    if ([self checkLegal]) {
        self.isMessage = YES;
        //提示用户是否确认信息
        [self showBackViewUI:@"部分信息确认后不能再修改,确认保存？"];
    }
    
}
-(BOOL)checkLegal{
    BOOL a = YES;
    if (!self.manBtn.selected && !self.famaleBtn.selected) {
        a = NO;
        [self showMessage:@"请选择性别"];
    }
    else if (!self.danceBtn.selected && !self.musicBtn.selected&&!self.printBtn.selected && !self.intrusmentBtn.selected&&!self.gameBtn.selected && !self.movieBtn.selected&&!self.chessBtn.selected && !self.travelBtn.selected&&!self.foodBtn.selected && !self.chatBtn.selected&&!self.readBtn.selected && !self.motionBtn.selected) {
        a = NO;
        [self showMessage:@"请选择爱好"];
    }
    else if (self.nameLabel.text.length == 0||self.phoneTF.text.length == 0 || self.liveProTF.text.length == 0||self.liveCityTF.text.length == 0||self.liveDisTF.text.length == 0) {
        a = NO;
        [self showMessage:@"请填写完整必填项"];
    }
    
    return a;
}
-(void)showBackViewUI:(NSString *)title{
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.backView = [UIView sureViewTitle:title andTag:90 andTarget:self andAction:@selector(buttonAction:)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewAction)];
    
    [self.backView addGestureRecognizer:tap];
    
    [self.window addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-64);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(KMainScreenWidth);
        make.height.mas_equalTo(KMainScreenHeight);
    }];
}
-(void)buttonAction:(UIButton *)btn{
    if (btn.tag == 90) {
        if (self.isMessage) {
            WeakSelf;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [weakSelf recommendSubmit];
            });
        }else{
            [self hideViewAction];
        }
        
    }else{
        [self hideViewAction];
    }
}
-(void)hideViewAction{
    self.backView.hidden = YES;
}
-(void)recommendSubmit{
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setValue:self.userId forKey:@"userId"];
    [params setValue:self.nameLabel.text forKey:@"fullName"];
    [params setValue:self.phoneTF.text forKey:@"mobile"];
    if (self.manBtn.selected) {
        [params setValue:@"1" forKey:@"sex"];
    }else if (self.famaleBtn.selected){
        [params setValue:@"2" forKey:@"sex"];
        
    }
    NSArray * arr = @[self.liveProTF.text,self.liveCityTF.text,self.liveDisTF.text,@"中国"];
    NSData * data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString * result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [params setValue:result forKey:@"address"];
    //爱好最多3项
    NSMutableString * hobby = [NSMutableString new];
    if (self.danceBtn.selected) {
        [hobby appendString:@"舞蹈,"];
    }
    if (self.musicBtn.selected) {
        [hobby appendString:@"音乐,"];
    }
    if (self.printBtn.selected) {
        [hobby appendString:@"画画,"];
    }
    if (self.intrusmentBtn.selected) {
        [hobby appendString:@"乐器,"];
    }
    if (self.gameBtn.selected) {
        [hobby appendString:@"游戏,"];
    }
    if (self.movieBtn.selected) {
        [hobby appendString:@"影视,"];
    }
    if (self.travelBtn.selected) {
        [hobby appendString:@"旅游,"];
    }
    if (self.chessBtn.selected) {
        [hobby appendString:@"棋类,"];
    }
    if (self.foodBtn.selected) {
        [hobby appendString:@"美食,"];
    }
    if (self.chatBtn.selected) {
        [hobby appendString:@"社交,"];
    }
    if (self.readBtn.selected) {
        [hobby appendString:@"阅读,"];
    }
    if (self.motionBtn.selected) {
        [hobby appendString:@"运动,"];
    }
    
    [params setValue:hobby forKey:@"hobby"];
    
    [params setValue:self.schoolTF.text forKey:@"finishSchool"];
    
    [params setValue:self.birthday forKey:@"birthday"];
    [params setValue:[NSString stringWithFormat:@"%@,%@,%@",self.homeProTF.text,self.homeCityTF.text,self.homeDisTF.text] forKey:@"homeplace"];
    
    NSString * status;
    if ([self.marryTF.text isEqualToString:@"已婚"]) {
        status = @"1";
    }else{
        status = @"0";
    }
    [params setValue:status forKey:@"marriage"];
    
    [params setValue:self.companyTF.text forKey:@"company"];
    
    
    [params setValue:self.postTF.text forKey:@"position"];
    [params setValue:self.emailTF.text forKey:@"email"];
    [params setValue:self.qqTF.text forKey:@"QQ"];
    [params setValue:self.wechatTF.text forKey:@"wechat"];
    //性格最多2两项
    //性格
    NSMutableString * character = [NSMutableString new];
    if (self.quiteBtn.selected) {
        [character appendString:@"死宅,"];
    }
    if (self.smailBtn.selected) {
        [character appendString:@"幽默,"];
    }
    if (self.beautyBtn.selected) {
        [character appendString:@"漂亮,"];
    }
    if (self.moneyBtn.selected) {
        [character appendString:@"大方,"];
    }
    if (self.quickBtn.selected) {
        [character appendString:@"急躁,"];
    }
    if (self.frivoBtn.selected) {
        [character appendString:@"轻浮,"];
    }
    if (self.unfaithBtn.selected) {
        [character appendString:@"花心,"];
    }
    if (self.douBtn.selected) {
        [character appendString:@"逗比,"];
    }
    if (self.livelyBtn.selected) {
        [character appendString:@"活泼,"];
    }
    if (self.coolBtn.selected) {
        [character appendString:@"高冷,"];
    }
    if (self.honestBtn.selected) {
        [character appendString:@"诚信,"];
    }
    if (self.cuteBtn.selected) {
        [character appendString:@"可爱,"];
    }
    
    [params setValue:character forKey:@"character"];
    
    [params setValue:self.fatherNameTF.text forKey:@"fatherName"];
    [params setValue:self.motherNameTF.text forKey:@"motherName"];
    
    [params setValue:self.wifeNameTF.text forKey:@"spouseName"];
    [params setValue:self.childNameTF.text forKey:@"childrenName"];
    [params setValue:self.childSchoolTF.text forKey:@"childrenSchool"];
    //行业
    NSString * industry;
    switch (self.industryIndex) {
        case 0:
            industry = @"2";
            break;
        case 1:
            industry = @"3";
            break;
        case 2:
            industry = @"4";
            break;
        case 3:
            industry = @"5";
            break;
        case 4:
            industry = @"6";
            break;
        case 5:
            industry = @"7";
            break;
        case 6:
            industry = @"8";
            break;
        case 7:
            industry = @"9";
            break;
        case 8:
            industry = @"10";
            break;
        default:
            industry = @"1";
            break;
    }
    [params setValue:industry forKey:@"industry"];
    
    NSString * degree;
    switch (self.degreeIndex) {
        case 0:
            degree = @"1";
            
            break;
        case 1:
            degree = @"2";
            
            break;
        case 2:
            degree = @"3";
            
            break;
        case 3:
            degree = @"4";
            
            break;
        case 4:
            degree = @"5";
            
            break;
        case 5:
            degree = @"6";
            
            break;
        case 6:
            degree = @"7";
            
            break;
        case 7:
            degree = @"8";
            
            break;
        case 8:
            degree = @"9";
            
            break;
        case 9:
            degree = @"10";
            
            break;
        default:
            degree = @"11";
            
            break;
    }
    [params setValue:degree forKey:@"degree"];
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ApplicationVIPURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"申请请求失败：%@",error);
            weakSelf.isMessage =  NO;
            weakSelf.backView.hidden = YES;
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            NSSLog(@"%@=",code);
            if ([code intValue] == 200) {
                weakSelf.backView.hidden = YES;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                weakSelf.isMessage =  NO;
                weakSelf.backView.hidden = YES;
                [weakSelf showMessage:@"申请VIP失败，请重新申请"];
            }
            
        }
    }];
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
//爱好
- (IBAction)danceClick:(id)sender {
    [self hobbyAction:self.danceBtn];
}
-(void)hobbyAction:(UIButton *)btn{
    if (self.count1>2) {
        if(btn.selected){
            self.count1--;
            btn.selected = !btn.selected;
        }else{
            //提示用户不可点击
            [self showMessage:@"爱好最多选择三项，请取消其他再进行选择"];
        }
    }else{
        btn.selected = !btn.selected;
        if(btn.selected){
            self.count1++;
        }else{
            self.count1--;
        }
        
    }
}
- (IBAction)musicClick:(id)sender {
    [self hobbyAction:self.musicBtn];
}

- (IBAction)printClick:(id)sender {
    [self hobbyAction:self.printBtn];
}

- (IBAction)instrumentClick:(id)sender {
    [self hobbyAction:self.intrusmentBtn];
}

- (IBAction)gameClick:(id)sender {
    [self hobbyAction:self.gameBtn];
}

- (IBAction)movieClick:(id)sender {
    [self hobbyAction:self.movieBtn];
}

- (IBAction)foodClick:(id)sender {
    [self hobbyAction:self.foodBtn];
}

- (IBAction)chatClick:(id)sender {
    [self hobbyAction:self.chatBtn];

}
- (IBAction)travelClick:(id)sender {
    [self hobbyAction:self.travelBtn];

}

- (IBAction)readClick:(id)sender {
    [self hobbyAction:self.readBtn];

}

- (IBAction)motionClick:(id)sender {
    [self hobbyAction:self.motionBtn];

}
- (IBAction)chessClick:(id)sender {
    [self hobbyAction:self.chessBtn];

}
//性格
- (IBAction)quiteClick:(id)sender {
    [self characterAction:self.quiteBtn];
}
-(void)characterAction:(UIButton *)btn{
    if (self.count2>1) {
        if(btn.selected){
            self.count2--;
            btn.selected = !btn.selected;
        }else{
            //提示用户不可点击
            [self showMessage:@"性格最多选择两项，请取消其他再进行选择"];
        }
    }else{
        btn.selected = !btn.selected;
        if(btn.selected){
            self.count2++;
        }else{
            self.count2--;
        }
        
    }
}
- (IBAction)smailClick:(id)sender {
    [self characterAction:self.smailBtn];
    
}
- (IBAction)beautyClick:(id)sender {
    [self characterAction:self.beautyBtn];
    
}

- (IBAction)moneyClick:(id)sender {
    [self characterAction:self.moneyBtn];
    
}
- (IBAction)quickClick:(id)sender {
    [self characterAction:self.quickBtn];
    
}

- (IBAction)frivoClick:(id)sender {
    [self characterAction:self.frivoBtn];
    
}

- (IBAction)unfaithClick:(id)sender {
    [self characterAction:self.unfaithBtn];
    
}


- (IBAction)douClick:(id)sender {
    [self characterAction:self.douBtn];
    
}

- (IBAction)livelyClick:(id)sender {
    [self characterAction:self.livelyBtn];
    
}

- (IBAction)coolClick:(id)sender {
    [self characterAction:self.coolBtn];
    
}

- (IBAction)honeyClick:(id)sender {
    [self characterAction:self.honestBtn];
    
}
- (IBAction)cuteClick:(id)sender {
    [self characterAction:self.cuteBtn];
    
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
        [self.postTF becomeFirstResponder];
    }else if (textField == self.postTF){
        [self.postTF resignFirstResponder];
        [self.fatherNameTF becomeFirstResponder];
        
    }else if (textField == self.fatherNameTF){
        [self.fatherNameTF resignFirstResponder];
        [self.motherNameTF becomeFirstResponder];
        
    }else if (textField == self.motherNameTF){
        [self.motherNameTF resignFirstResponder];
        [self.emailTF becomeFirstResponder];
        
    }else if (textField == self.emailTF){
        [self.emailTF resignFirstResponder];
        [self.qqTF becomeFirstResponder];
        
    }else if (textField == self.qqTF){
        [self.qqTF resignFirstResponder];
        [self.wechatTF becomeFirstResponder];
        
    }else if (textField == self.wechatTF){
        if (self.marryHeightCons.constant == 0) {
            [self resign];
        }else{
            [self.wechatTF resignFirstResponder];
            [self.wifeNameTF becomeFirstResponder];
            
        }
        
    }
    else if (textField == self.wifeNameTF){
        [self.wifeNameTF resignFirstResponder];
        [self.childNameTF becomeFirstResponder];
        
    }else if (textField == self.childNameTF){
        [self.childNameTF resignFirstResponder];
        [self.childSchoolTF becomeFirstResponder];
        
    }else if (textField == self.childSchoolTF){
        [self resign];
        
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.emailTF||textField == self.qqTF||textField == self.wechatTF){
        self.bottomView.hidden = YES;
        CGFloat offset = textField.frame.origin.y+50-(KMainScreenHeight-216);
        self.view.frame = CGRectMake(0, -offset-64, KMainScreenWidth, KMainScreenHeight+offset+64);
        return YES;
        
    }else if (textField == self.wifeNameTF||textField == self.childNameTF||textField == self.childSchoolTF){
        self.bottomView.hidden = YES;
        CGFloat offset1 = self.marryView.frame.origin.y+textField.frame.origin.y+50-(KMainScreenHeight-216);
        self.view.frame = CGRectMake(0, -offset1-64, KMainScreenWidth, KMainScreenHeight+offset1+64);
        return YES;
        
    }
    else if (textField == self.liveProTF||textField == self.liveCityTF||textField == self.liveDisTF||textField == self.homeProTF||textField == self.homeCityTF||textField == self.homeDisTF||textField == self.marryTF||textField == self.acadenmicTF||textField == self.industryTF){
        [self resign];
        if (textField == self.liveProTF) {
            [self hidden];
            self.flag = 1;
            [self getAllData];
        }else if (textField == self.liveCityTF){
            if (self.liveProTF.text.length != 0) {
                [self hidden];
                self.flag = 2;
                for (NSDictionary *dict in self.allArr) {
                    if ([dict objectForKey:self.provinceArr[self.proIndex]]) {
                        self.cityArr = [NSMutableArray arrayWithArray:[[dict objectForKey:self.provinceArr[self.proIndex]] allKeys]];
                        break;
                    }
                }
            }
        }else if(textField == self.liveDisTF){
            if (self.liveCityTF.text.length != 0) {
                [self hidden];
                self.flag = 3;
                for (NSDictionary *dict in self.allArr) {
                    
                    if ([dict objectForKey:self.provinceArr[self.proIndex]]) {
                        self.districtArr = [NSMutableArray arrayWithArray:[[dict objectForKey:self.provinceArr[self.proIndex]] objectForKey:self.cityArr[self.cityIndex]]];
                        break;
                        
                    }
                    
                }
            }
        }else  if (textField == self.homeProTF) {
            [self hidden];
            self.flag = 4;
            [self getAllData];
        }else if (textField == self.homeCityTF){
            if (self.homeProTF.text.length != 0) {
                [self hidden];
                self.flag = 5;
                for (NSDictionary *dict in self.allArr) {
                    
                    if ([dict objectForKey:self.provinceArr[self.proIndex]]) {
                        self.cityArr = [NSMutableArray arrayWithArray:[[dict objectForKey:self.provinceArr[self.proIndex]] allKeys]];
                        break;
                    }
                }
            }
        }else if(textField == self.homeDisTF){
            if (self.homeCityTF.text.length != 0) {
                [self hidden];
                self.flag = 6;
                for (NSDictionary *dict in self.allArr) {
                    
                    if ([dict objectForKey:self.provinceArr[self.proIndex]]) {
                        self.districtArr = [NSMutableArray arrayWithArray:[[dict objectForKey:self.provinceArr[self.proIndex]] objectForKey:self.cityArr[self.cityIndex]]];
                        break;
                    }
                }
            }
        }else if (textField == self.marryTF){
            [self hidden];
            self.flag = 7;
            //婚姻
            self.marryArr = @[@"未婚",@"已婚"];
        }else if (textField == self.acadenmicTF){
            //学历
            [self hidden];
            self.flag = 8;
            self.degreeArr = @[@"初中",@"高中",@"中技",@"中专",@"大专",@"本科",@"硕士",@"博士",@"MBA",@"EMBA",@"其他"];
        }else if (textField == self.industryTF){
            //行业
            [self hidden];
            self.flag = 9;
            self.industryArr = @[@"互联网",@"服务业",@"金融",@"教师",@"银行",@"医疗",@"房地产",@"贸易",@"物流",@"其他"];
            
        }
        [self.pickerView reloadComponent:0];
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        if ([self.pickerView.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
            [self.pickerView.delegate pickerView:self.pickerView didSelectRow:0 inComponent:0];
        }
        return NO;
    }else if (textField == self.birthdayTF){
        [self resign];
        self.bottomView.hidden = NO;
        self.pickerView.hidden = YES;
        self.datePicker.hidden = NO;
        self.flag = 10;
        return NO;
    }
    else{
        self.bottomView.hidden = YES;
        return YES;
    }
}
-(void)hidden{
    self.bottomView.hidden = NO;
    self.datePicker.hidden = YES;
    self.pickerView.hidden = NO;
}
- (IBAction)datePickerClick:(id)sender {
    [self common];
    
}
-(void)common{
    NSString * time = [NowDate getTime:self.datePicker.date];
    NSArray * arr = [time componentsSeparatedByString:@"-"];
    self.birthdayTF.text = [NSString stringWithFormat:@"%@年%@月%@日",arr[0],arr[1],arr[2]];
    self.birthday = time;
}
-(void)getAllData{
    self.allArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
    for (NSDictionary *dci in self.allArr) {
        [self.provinceArr addObject:[[dci allKeys] firstObject]];
    }
}
- (IBAction)finishClick:(id)sender {
    switch (self.flag) {
        case 1:
            self.liveProTF.text = self.provinceArr[self.proIndex];
            
            break;
        case 2:
            self.liveCityTF.text = self.cityArr[self.cityIndex];
            
            break;
        case 3:
            self.liveDisTF.text = self.districtArr[self.districtIndex];
            
            break;
        case 4:
            self.homeProTF.text = self.provinceArr[self.proIndex];
            
            break;
        case 5:
            self.homeCityTF.text = self.cityArr[self.cityIndex];
            
            break;
        case 6:
            self.homeDisTF.text = self.districtArr[self.districtIndex];
            break;
        case 7:
            //婚姻
        {
            self.marryTF.text = self.marryArr[self.marryIndex];
            if ([self.marryTF.text isEqualToString:@"已婚"]) {
                self.marryHeightCons.constant = 163;
                [self commonUI:NO];
                
            }else{
                self.marryHeightCons.constant = 0;
                [self commonUI:YES];
                
            }
        }
            
            break;
        case 8:
            //学历
            self.acadenmicTF.text = self.degreeArr[self.degreeIndex];
            break;
        case 9:
            //行业
            self.industryTF.text = self.industryArr[self.industryIndex];
            
            break;
            
        default:
            //生日
            [self common];
            break;
    }
    self.bottomView.hidden = YES;
    
}
#pragma mark - pickerView-delegate and DataSources
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [UILabel new];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        pickerLabel.textColor = UIColorFromRGB(0x333333);
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    }
    //去除线条
    [[pickerView.subviews objectAtIndex:1]setHidden:true];
    [[pickerView.subviews objectAtIndex:2]setHidden:true];
    return pickerLabel;
}
//返回组件高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 45;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //改变选择时的颜色
    UILabel * label = (UILabel *)[pickerView viewForRow:row forComponent:0];
    label.backgroundColor = [UIColor whiteColor];
    switch (self.flag) {
        case 1:
        {
            self.proIndex = row;
            self.cityIndex = 0;
            self.districtIndex = 0;
            
        }
            break;
        case 2:
        {
            self.cityIndex = row;
            self.districtIndex = 0;
            
        }
            break;
        case 3:
        {
            self.districtIndex = row;
        }
            break;
        case 4:
        {
            self.proIndex = row;
            self.cityIndex = 0;
            self.districtIndex = 0;
        }
            break;
            
        case 5:
        {
            self.cityIndex = row;
            self.districtIndex = 0;
        }
            break;
        case 6:
            self.districtIndex = row;
            break;
        case 7:
            self.marryIndex = row;
            break;
        case 8:
            self.degreeIndex = row;
            
            break;
        default:
            self.industryIndex = row;
            break;
    }
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (self.flag) {
        case 1:
            return [self.provinceArr objectAtIndex:row];
            
        case 2:
            return [self.cityArr objectAtIndex:row];
            
        case 3:
            return [self.districtArr objectAtIndex:row];
            
        case 4:
            return [self.provinceArr objectAtIndex:row];
            
        case 5:
            return [self.cityArr objectAtIndex:row];
            
        case 6:
            return [self.districtArr objectAtIndex:row];
            
        case 7:
            return [self.marryArr objectAtIndex:row];
            
        case 8:
            return [self.degreeArr objectAtIndex:row];
            
        default:
            return [self.industryArr objectAtIndex:row];
            
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (self.flag) {
        case 1:
            return self.provinceArr.count;
            
        case 2:
            return self.cityArr.count;
            
        case 3:
            return self.districtArr.count;
            
        case 4:
            return self.provinceArr.count;
            
        case 5:
            return self.cityArr.count;
            
        case 6:
            return self.districtArr.count;
            
        case 7:
            return self.marryArr.count;
        case 8:
            return self.degreeArr.count;
        default:
            return self.industryArr.count;
            
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}
-(NSMutableArray *)provinceArr{
    if (!_provinceArr) {
        _provinceArr = [NSMutableArray new];
    }
    return _provinceArr;
}
-(NSMutableArray *)cityArr{
    if (!_cityArr) {
        _cityArr = [NSMutableArray new];
    }
    return _cityArr;
}
-(NSMutableArray *)districtArr{
    if (!_districtArr) {
        _districtArr = [NSMutableArray new];
    }
    return _districtArr;
}


@end
