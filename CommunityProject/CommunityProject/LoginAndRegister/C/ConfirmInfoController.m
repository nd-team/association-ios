//
//  ConfirmInfoController.m
//  CommunityProject
//
//  Created by bjike on 17/3/14.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ConfirmInfoController.h"
#import "LoginController.h"
//#define RecommendURL @"appapi/app/selectRecommendInfo"
#define SureInfoURL @"appapi/app/editRecommendInfo"
#define LoginURL @"appapi/app/login"

@interface ConfirmInfoController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,RCIMConnectionStatusDelegate>
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

//爱好
@property (nonatomic,assign)NSInteger count1;
//性格
@property (nonatomic,assign)NSInteger count2;
@end

@implementation ConfirmInfoController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];    
}

-(void)setUI{
    self.count1 = 0;
    self.count2 = 0;
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
    self.marryHeightCons.constant = 0;
    [self commonUI:YES];

    //手势回收键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    [self.view addGestureRecognizer:tap];
    
}
-(void)commonUI:(BOOL)isHidden{
    dispatch_async(dispatch_get_main_queue(), ^{
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
            self.viewHeightCons.constant = 1400;
        }else{
            self.viewHeightCons.constant = 1700;
            
        }
    });
   
}
/*
-(void)getData{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,RecommendURL] andParams:@{@"userId":self.phone,@"recommendId":self.code} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"推荐好友的信息获取失败：%@",error);
        }else{
            NSNumber *code = data[@"code"];
            NSSLog(@"%@",code);
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                weakSelf.nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"fullName"]];
                weakSelf.phoneTF.text = [NSString stringWithFormat:@"%@",dict[@"mobile"]];
                weakSelf.birthdayTF.text = [NSString stringWithFormat:@"%@",dict[@"birthday"]];
                NSString * home = [NSString stringWithFormat:@"%@",dict[@"homeplace"]];
                NSArray * arr = [home componentsSeparatedByString:@","];
                if (arr.count == 1) {
                    weakSelf.homeProTF.text = arr[0];
                }
                if (arr.count == 2) {
                    weakSelf.homeProTF.text = arr[0];
                    weakSelf.homeCityTF.text = arr[1];
                }
                if (arr.count == 3) {
                    weakSelf.homeProTF.text = arr[0];
                    weakSelf.homeCityTF.text = arr[1];
                    weakSelf.homeDisTF.text = arr[2];
                }

                weakSelf.schoolTF.text = [NSString stringWithFormat:@"%@",dict[@"finishSchool"]];
                weakSelf.companyTF.text = [NSString stringWithFormat:@"%@",dict[@"company"]];
                if ([dict[@"sex"] integerValue] == 1) {
                    weakSelf.manBtn.selected = YES;
                }else{
                    weakSelf.famaleBtn.selected = YES;
                }
                NSString * hobby = dict[@"hobby"];
                if ([hobby containsString:@"舞蹈"]) {
                    weakSelf.danceBtn.selected = YES;
                }
                if ([hobby containsString:@"音乐"]) {
                    weakSelf.musicBtn.selected = YES;
                }
                if ([hobby containsString:@"画画"]) {
                    weakSelf.printBtn.selected = YES;
                }
                if ([hobby containsString:@"乐器"]) {
                    weakSelf.intrusmentBtn.selected = YES;
                }
                if ([hobby containsString:@"游戏"]) {
                    weakSelf.gameBtn.selected = YES;
                }
                if ([hobby containsString:@"影视"]) {
                    weakSelf.movieBtn.selected = YES;
                }
                if ([hobby containsString:@"旅游"]) {
                    weakSelf.travelBtn.selected = YES;
                }
                if ([hobby containsString:@"棋类"]) {
                    weakSelf.chessBtn.selected = YES;
                }
                if ([hobby containsString:@"美食"]) {
                    weakSelf.foodBtn.selected = YES;
                }
                if ([hobby containsString:@"社交"]) {
                    weakSelf.chatBtn.selected = YES;
                }
                if ([hobby containsString:@"阅读"]) {
                    weakSelf.readBtn.selected = YES;
                }
                if ([hobby containsString:@"运动"]) {
                    weakSelf.motionBtn.selected = YES;
                }
                NSDictionary * addressDic = dict[@"address"];
                weakSelf.liveProTF.text = addressDic[@"firstStage"];
                weakSelf.liveCityTF.text = addressDic[@"secondStage"];
                weakSelf.liveDisTF.text = addressDic[@"thirdStage"];
            }
        }
    }];
}
 */
-(void)resign{
    self.view.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
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
        WeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showBackViewUI:@"部分信息确认后不能再修改,确认保存？"];
        });
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
        make.top.equalTo(self.view).offset(0);
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
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
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backView.hidden = YES;

    });
}
-(void)recommendSubmit{
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setValue:self.phoneTF.text forKey:@"userId"];
    [params setValue:self.code forKey:@"recommendId"];

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
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,SureInfoURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"确认请求失败：%@",error);
            weakSelf.isMessage =  NO;
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
//            NSSLog(@"%@=%@",code,data);
            if ([code intValue] == 200) {
                [weakSelf hideViewAction];
                //登录进入主界面
                [weakSelf loginNet];
            }else{
                weakSelf.isMessage =  NO;
                [weakSelf showMessage:@"确认信息失败，请重新确认"];
            }
            
        }
    }];
}

-(void)loginNet{
    WeakSelf;
    NSDictionary * dic = @{@"mobile":self.phone,@"password":self.password};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,LoginURL] andParams:dic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        
        if (error) {
            NSSLog(@"登录失败：%@",error);
            weakSelf.isMessage =  NO;
            [weakSelf showMessage:@"服务器出错咯！"];

        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //成功
                NSDictionary * msg = data[@"data"];
                //保存用户数据
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                //用户ID
                [userDefaults setValue:msg[@"userId"] forKey:@"userId"];
                //昵称
                [userDefaults setValue:msg[@"nickname"] forKey:@"nickname"];
                //头像
                NSString * url = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:msg[@"userPortraitUrl"]]];
                [userDefaults setValue:url forKey:@"userPortraitUrl"];
                //token
                [userDefaults setValue:msg[@"token"] forKey:@"token"];
                [userDefaults setValue:weakSelf.password forKey:@"password"];
                //sex
                NSNumber * sex = msg[@"sex"];
                [userDefaults setInteger:[sex integerValue] forKey:@"sex"];
                if (![msg[@"birthday"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"birthday"] forKey:@"birthday"];
                }
                if (![msg[@"address"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"address"] forKey:@"address"];
                }
                if (![msg[@"email"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"email"] forKey:@"email"];
                }
                if (![msg[@"mobile"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"mobile"] forKey:@"mobile"];
                }
                if (![msg[@"numberId"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"numberId"] forKey:@"numberId"];
                }
                if (![msg[@"recommendUserId"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"recommendUserId"] forKey:@"recommendUserId"];
                }
                if (![msg[@"claimUserId"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"claimUserId"] forKey:@"claimUserId"];
                }
                if (![msg[@"experience"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"experience"]] forKey:@"experience"];
                }
                if (![msg[@"creditScore"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"creditScore"]] forKey:@"creditScore"];
                }
                if (![msg[@"contributionScore"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"contributionScore"]] forKey:@"contributionScore"];
                }
                if (![msg[@"checkVip"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setInteger:[msg[@"checkVip"] integerValue]forKey:@"checkVip"];
                }
                if (![msg[@"favour"] isKindOfClass:[NSNull class]]) {
                    [userDefaults setValue:msg[@"favour"] forKey:@"favour"];
                }
                [userDefaults setValue:[NSString stringWithFormat:@"%@",msg[@"status"]] forKey:@"status"];

                [userDefaults synchronize];
                //设置当前用户
                RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:msg[@"userId"] name:msg[@"nickname"] portrait:url];
                [RCIM sharedRCIM].currentUserInfo = userInfo;
                [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:msg[@"userId"]];
                [weakSelf loginRongServicer:msg[@"token"]];
                
                
            }else if ([code intValue] == 0){
                weakSelf.isMessage =  NO;
                [weakSelf showMessage:@"账号不存在！"];
            }else if ([code intValue] == 1002){
                weakSelf.isMessage =  NO;
                [weakSelf showMessage:@"账号禁止登录！"];
            }else if ([code intValue] == 1003){
                weakSelf.isMessage =  NO;
                [weakSelf showMessage:@"密码错误！"];
                
            }else{
                weakSelf.isMessage =  NO;
                [weakSelf showMessage:@"确认信息成功，登录失败，请回到登录界面进行登录"];
            }
        }
    }];
}
//登录融云服务器
-(void)loginRongServicer:(NSString *)token{
    WeakSelf;
    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
        NSSLog(@"登录成功%@",userId);
        [weakSelf loginMain];
        //登录主界面
    } error:^(RCConnectErrorCode status) {
        NSSLog(@"错误码：%ld",(long)status);
        //SDK自动重新连接
        [[RCIM sharedRCIM]setConnectionStatusDelegate:self];
    } tokenIncorrect:^{
        NSSLog(@"token错误");
    }];
}
-(void)loginMain{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    });
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == ConnectionStatus_Connected) {
            [RCIM sharedRCIM].connectionStatusDelegate = (id<RCIMConnectionStatusDelegate>)[UIApplication sharedApplication].delegate;
        } else if (status == ConnectionStatus_NETWORK_UNAVAILABLE) {
            //            [weakSelf showMessage:@"当前网络不可用，请检查！"];
            
        } else if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
//            [weakSelf showMessage:@"您的帐号在别的设备上登录，您被迫下线！"];
        } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
            NSSLog(@"Token无效");
            //            [weakSelf showMessage:@"无法连接到服务器！"];
        } else {
            NSLog(@"RCConnectErrorCode is %zd", status);
        }
    });
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
            [self showMessage:@"爱好最多选择三项，请取消其他项，重新选择"];
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
            [self showMessage:@"性格最多选择两项，请取消其他项，重新选择"];
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
        self.view.frame = CGRectMake(0, -offset, KMainScreenWidth, KMainScreenHeight+offset+64);
        return YES;
        
    }else if (textField == self.wifeNameTF||textField == self.childNameTF||textField == self.childSchoolTF){
        self.bottomView.hidden = YES;
        CGFloat offset1 = self.marryView.frame.origin.y+textField.frame.origin.y+50-(KMainScreenHeight-216);
        self.view.frame = CGRectMake(0, -offset1, KMainScreenWidth, KMainScreenHeight+offset1+64);
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
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bottomView.hidden = NO;
            self.pickerView.hidden = YES;
            self.datePicker.hidden = NO;
        });
        self.flag = 10;
        return NO;
    }
    else{
        self.bottomView.hidden = YES;
        return YES;
    }
}
-(void)hidden{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bottomView.hidden = NO;
        self.datePicker.hidden = YES;
        self.pickerView.hidden = NO;

    });
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
- (IBAction)cancelClick:(id)sender {
    UIViewController * vc = self.presentingViewController;
    while (![vc isKindOfClass:[LoginController class]]) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
    
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
