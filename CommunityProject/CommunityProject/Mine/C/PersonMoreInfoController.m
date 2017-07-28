//
//  PersonMoreInfoController.m
//  CommunityProject
//
//  Created by bjike on 17/4/27.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PersonMoreInfoController.h"

#define MoreInfoURL @"appapi/app/selectMoreUserInfo"
#define SaveInfoURL @"appapi/app/editMoreUserInfo"
#define FriendDetailURL @"appapi/app/selectUserInfo"

@interface PersonMoreInfoController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic,copy)NSString * userId;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *QQTF;
@property (weak, nonatomic) IBOutlet UITextField *chatTF;
@property (weak, nonatomic) IBOutlet UITextField *schoolTF;
@property (weak, nonatomic) IBOutlet UITextField *starTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *postTF;
@property (weak, nonatomic) IBOutlet UITextField *bloodTF;
@property (weak, nonatomic) IBOutlet UITextField *marryTF;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *wifeBtn;

@property (weak, nonatomic) IBOutlet UIButton *childBtn;

@property (weak, nonatomic) IBOutlet UIButton *childScBtn;
@property (weak, nonatomic) IBOutlet UIButton *fatherBtn;
@property (weak, nonatomic) IBOutlet UIButton *motherBtn;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *marryBtn;

@property (weak, nonatomic) IBOutlet UILabel *seeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeWifeLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeChildLabel;
@property (weak, nonatomic) IBOutlet UIButton *schoolBtn;

@property (weak, nonatomic) IBOutlet UILabel *seeChildSchLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeFatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeSchoolLabel;


@property (weak, nonatomic) IBOutlet UILabel *seeMotherLabel;
@property (weak, nonatomic) IBOutlet UILabel *seePostLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeMarryLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextField *wifeNameTF;

@property (weak, nonatomic) IBOutlet UITextField *childNameTF;
@property (weak, nonatomic) IBOutlet UITextField *childSchoolTF;
@property (weak, nonatomic) IBOutlet UIView *marryView;
@property (weak, nonatomic) IBOutlet UILabel *wifeNameLabel;

@property (weak, nonatomic) IBOutlet UIView *lineOneView;

@property (weak, nonatomic) IBOutlet UILabel *childNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *childSchoolLabel;
@property (weak, nonatomic) IBOutlet UITextField *fatherNameTF;
@property (weak, nonatomic) IBOutlet UITextField *motherNameTF;

@property (weak, nonatomic) IBOutlet UITextField *degreeTF;
@property (weak, nonatomic) IBOutlet UITextField *industryTF;
//索引
@property (nonatomic,assign)NSInteger starIndex;

@property (nonatomic,assign)NSInteger bloodIndex;
@property (nonatomic,assign)NSInteger marryIndex;
//数据源
@property (nonatomic,strong)NSArray * startArr;
@property (nonatomic,strong)NSArray * bloodArr;
@property (nonatomic,strong)NSArray * marryArr;
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

//学历
@property (nonatomic,strong)NSArray * degreeArr;
@property (nonatomic,assign)NSInteger degreeIndex;

//行业
@property (nonatomic,strong)NSArray * industryArr;
@property (nonatomic,assign)NSInteger industryIndex;
//标记pickerView的数据源 1:星座2：血型3：婚姻 4学历5行业6省份7城市8区域9生日
@property (nonatomic,assign)int flag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marryHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *seePhoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *birthBtn;
@property (weak, nonatomic) IBOutlet UILabel *seeBirthLabel;

@property (weak, nonatomic) IBOutlet UITextField *homeProTF;
@property (weak, nonatomic) IBOutlet UITextField *homeCityTF;
@property (weak, nonatomic) IBOutlet UITextField *homeDisTF;

@end

@implementation PersonMoreInfoController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.name;
    self.bottomView.hidden = YES;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"取消" andLeft:-15 andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.homeProTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.homeCityTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.homeDisTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.homeProTF.layer.borderWidth = 1;
    self.homeCityTF.layer.borderWidth = 1;
    self.homeDisTF.layer.borderWidth = 1;
    if (self.isCurrent) {
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"保存" andLeft:15 andTarget:self Action:@selector(saveInfo)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self setButtonBackImage:self.nameBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
        [self setButtonBackImage:self.phoneBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
        [self setButtonBackImage:self.birthBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
        [self setButtonBackImage:self.fatherBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
        [self setButtonBackImage:self.motherBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
        [self setButtonBackImage:self.wifeBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
        [self setButtonBackImage:self.childBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
        [self setButtonBackImage:self.childScBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
        [self setButtonBackImage:self.postBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
        [self setButtonBackImage:self.marryBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
        [self setButtonBackImage:self.schoolBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];

        //手势回收键盘
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
        [self.view addGestureRecognizer:tap];
        //初始化界面数据
        [self getMoreInfo];
    }else{
        //别人的信息=所有都不可用，按钮隐藏
        self.nameBtn.hidden = YES;
        self.phoneBtn.hidden = YES;
        self.birthBtn.hidden = YES;
        self.wifeBtn.hidden = YES;
        self.childScBtn.hidden = YES;
        self.childBtn.hidden = YES;
        self.fatherBtn.hidden = YES;
        self.motherBtn.hidden = YES;
        self.schoolBtn.hidden = YES;
        self.postBtn.hidden = YES;
        self.marryBtn.hidden = YES;
        self.seeNameLabel.hidden = YES;
        self.seePhoneLabel.hidden = YES;
        self.seeBirthLabel.hidden = YES;
        self.seeWifeLabel.hidden = YES;
        self.seeChildLabel.hidden = YES;
        self.seeChildSchLabel.hidden = YES;
        self.seeFatherLabel.hidden = YES;
        self.seeMotherLabel.hidden = YES;
        self.seePostLabel.hidden = YES;
        self.seeMarryLabel.hidden = YES;
        self.seeSchoolLabel.hidden = YES;
        self.nameTF.enabled = NO;
        self.phoneTF.enabled = NO;
        self.homeProTF.enabled = NO;
        self.homeCityTF.enabled = NO;
        self.homeDisTF.enabled = NO;
        self.birthdayTF.enabled = NO;
        self.fatherNameTF.enabled = NO;
        self.motherNameTF.enabled = NO;
        self.industryTF.enabled = NO;
        self.degreeTF.enabled = NO;
        self.QQTF.enabled = NO;
        self.chatTF.enabled = NO;
        self.schoolTF.enabled = NO;
        self.starTF.enabled = NO;
        self.bloodTF.enabled = NO;
        self.companyTF.enabled = NO;
        self.postTF.enabled = NO;
        self.marryTF.enabled = NO;
        self.wifeNameTF.enabled = NO;
        self.childNameTF.enabled = NO;
        self.childSchoolTF.enabled = NO;
        [self getUserInformation];
        
    }

}
-(void)commonUI:(BOOL)isHidden{
    self.wifeNameLabel.hidden = isHidden;
    self.seeWifeLabel.hidden = isHidden;
    self.childNameLabel.hidden = isHidden;
    self.seeChildLabel.hidden = isHidden;
    self.childSchoolLabel.hidden = isHidden;
    self.seeChildSchLabel.hidden = isHidden;
    self.wifeBtn.hidden = isHidden;
    self.childBtn.hidden = isHidden;
    self.childScBtn.hidden = isHidden;
    self.lineOneView.hidden = isHidden;
    self.wifeNameTF.hidden = isHidden;
    self.childNameTF.hidden = isHidden;
    self.childSchoolTF.hidden = isHidden;
    if (isHidden) {
        self.viewHeightCons.constant = 1000;
    }else{
        self.viewHeightCons.constant = 1170;
        
    }
}
-(void)setButtonBackImage:(UIButton *)btn andNormalImage:(NSString *)norImg andSelectImage:(NSString *)selImg{
    [btn setBackgroundImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selImg] forState:UIControlStateSelected];
    
}
//对方更多信息

-(void)getUserInformation{
    WeakSelf;
    //获取数据初始化数据
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendDetailURL] andParams:@{@"otherUserId":self.friendId,@"status":@"0",@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"好友详情请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                NSSLog(@"%@",dict);
                //请求网络数据获取用户详细资料
                if ( [dict[@"fullName"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * nameDic = dict[@"fullName"];
                    weakSelf.nameTF.text = nameDic[@"name"];
                }
                if ( [dict[@"mobile"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * mobileDic = dict[@"mobile"];
                    weakSelf.phoneTF.text = mobileDic[@"name"];
                }
                if ( [dict[@"birthday"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * birthDic = dict[@"birthday"];
                    NSArray * arr = [birthDic[@"name"] componentsSeparatedByString:@"-"];
                    self.birthdayTF.text = [NSString stringWithFormat:@"%@年%@月%@日",arr[0],arr[1],arr[2]];
                }
                weakSelf.QQTF.text = [NSString stringWithFormat:@"%@",dict[@"QQ"]];
                
                weakSelf.chatTF.text = [NSString stringWithFormat:@"%@",dict[@"wechat"]];
                
                if ( [dict[@"finishSchool"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * schoolDic = dict[@"finishSchool"];
                    weakSelf.schoolTF.text = schoolDic[@"name"];
                }
                if ( [dict[@"fatherName"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * fatherDic = dict[@"fatherName"];
                    weakSelf.fatherNameTF.text = fatherDic[@"name"];
                }
                if ( [dict[@"motherName"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * motherDic = dict[@"motherName"];
                    weakSelf.motherNameTF.text = motherDic[@"name"];
                }
                weakSelf.starTF.text = [NSString stringWithFormat:@"%@",dict[@"constellation"]];
                weakSelf.bloodTF.text = [NSString stringWithFormat:@"%@",dict[@"bloodType"]];
                
                if ( [dict[@"marriage"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * marryDic = dict[@"marriage"];
                    NSNumber * name = marryDic[@"name"];
                    if ([name intValue] == 0) {
                        weakSelf.marryTF.text = @"未婚";
                        [weakSelf commonUI:YES];

                    }else{
                        weakSelf.marryTF.text = @"已婚";
                        [weakSelf commonUI:NO];
                        
                    }
                }
                weakSelf.companyTF.text = [NSString stringWithFormat:@"%@",dict[@"company"]];
                NSInteger indu = [dict[@"industry"] integerValue];
                switch (indu) {
                    case 1:
                        weakSelf.industryTF.text = @"其他";
                        break;
                    case 2:
                        weakSelf.industryTF.text = @"互联网";
                        break;
                    case 3:
                        weakSelf.industryTF.text = @"服务业";
                        break;
                    case 4:
                        weakSelf.industryTF.text = @"金融";
                        break;
                    case 5:
                        weakSelf.industryTF.text = @"教师";
                        break;
                    case 6:
                        weakSelf.industryTF.text = @"银行";
                        break;
                    case 7:
                        weakSelf.industryTF.text = @"医疗";
                        break;
                    case 8:
                        weakSelf.industryTF.text = @"房地产";
                        break;
                    case 9:
                        weakSelf.industryTF.text = @"贸易";
                        break;
                    default:
                        weakSelf.industryTF.text = @"物流";
                        break;
                }
                NSInteger deg = [dict[@"degree"] integerValue];
                switch (deg) {
                    case 1:
                        weakSelf.degreeTF.text = @"初中";
                        break;
                    case 2:
                        weakSelf.degreeTF.text = @"高中";
                        break;
                    case 3:
                        weakSelf.degreeTF.text = @"中技";
                        break;
                    case 4:
                        weakSelf.degreeTF.text = @"中专";
                        break;
                    case 5:
                        weakSelf.degreeTF.text = @"大专";
                        break;
                    case 6:
                        weakSelf.degreeTF.text = @"本科";
                        break;
                    case 7:
                        weakSelf.degreeTF.text = @"硕士";
                        break;
                    case 8:
                        weakSelf.degreeTF.text = @"博士";
                        break;
                    case 9:
                        weakSelf.degreeTF.text = @"MBA";
                        break;
                    case 10:
                        weakSelf.degreeTF.text = @"EMBA";
                        break;
                    default:
                        weakSelf.degreeTF.text = @"其他";
                        break;
                }
                
                NSArray * home = [dict[@"homeplace"] componentsSeparatedByString:@","];
                weakSelf.homeProTF.text = home[0];
                weakSelf.homeCityTF.text = home[1];
                weakSelf.homeDisTF.text = home[2];
                if ( [dict[@"position"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * postDic = dict[@"position"];
                    weakSelf.postTF.text = postDic[@"name"];
                }
                if ( [dict[@"spouseName"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * wifeDic = dict[@"spouseName"];
                    weakSelf.wifeNameTF.text = wifeDic[@"name"];
                }
                if ( [dict[@"childrenName"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * childDic = dict[@"childrenName"];
                    weakSelf.childNameTF.text = childDic[@"name"];
                }
                if ( [dict[@"childrenSchool"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * schoolDic = dict[@"childrenSchool"];
                    weakSelf.childSchoolTF.text = schoolDic[@"name"];
                }
                
            }else{
                [weakSelf showMessage:@"加载好友更多信息失败！"];
            }
        }
    }];
    
}

-(void)getMoreInfo{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MoreInfoURL] andParams:@{@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取用户信息失败%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
        
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                if ( [dict[@"fullName"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * nameDic = dict[@"fullName"];
                    NSNumber * nameStatus = nameDic[@"status"];
                    weakSelf.nameTF.text = nameDic[@"name"];
                    
                    if ([nameStatus intValue] == 0) {
                        weakSelf.seeNameLabel.text = @"非公开";
                        weakSelf.nameBtn.selected = NO;
                    }else{
                        weakSelf.seeNameLabel.text = @"公开";
                        weakSelf.nameBtn.selected = YES;
                    }
                }
                if ( [dict[@"mobile"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * mobileDic = dict[@"mobile"];
                    NSNumber * mobileStatus = mobileDic[@"status"];
                    weakSelf.phoneTF.text = mobileDic[@"name"];
                    
                    if ([mobileStatus intValue] == 0) {
                        weakSelf.seePhoneLabel.text = @"非公开";
                        weakSelf.phoneBtn.selected = NO;
                    }else{
                        weakSelf.seePhoneLabel.text = @"公开";
                        weakSelf.phoneBtn.selected = YES;
                    }
                }
                if ( [dict[@"birthday"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * birthDic = dict[@"birthday"];
                    NSNumber * nameStatus = birthDic[@"status"];
                    NSArray * arr = [birthDic[@"name"] componentsSeparatedByString:@"-"];
                    self.birthdayTF.text = [NSString stringWithFormat:@"%@年%@月%@日",arr[0],arr[1],arr[2]];
                    if ([nameStatus intValue] == 0) {
                        weakSelf.seeBirthLabel.text = @"非公开";
                        weakSelf.birthBtn.selected = NO;
                    }else{
                        weakSelf.seeBirthLabel.text = @"公开";
                        weakSelf.birthBtn.selected = YES;
                    }
                }
                    weakSelf.QQTF.text = [NSString stringWithFormat:@"%@",dict[@"QQ"]];
                
                    weakSelf.chatTF.text = [NSString stringWithFormat:@"%@",dict[@"wechat"]];
                
                if ( [dict[@"finishSchool"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * schoolDic = dict[@"finishSchool"];
                    NSNumber * schoolStatus = schoolDic[@"status"];
                    weakSelf.schoolTF.text = schoolDic[@"name"];
                    if ([schoolStatus intValue] == 0) {
                        weakSelf.seeSchoolLabel.text = @"非公开";
                        weakSelf.schoolBtn.selected = NO;
                    }else{
                        weakSelf.seeSchoolLabel.text = @"公开";
                        weakSelf.schoolBtn.selected = YES;
                    }
                }
                if ( [dict[@"fatherName"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * fatherDic = dict[@"fatherName"];
                    NSNumber * fatherStatus = fatherDic[@"status"];
                    weakSelf.fatherNameTF.text = fatherDic[@"name"];
                    if ([fatherStatus intValue] == 0) {
                        weakSelf.seeFatherLabel.text = @"非公开";
                        weakSelf.fatherBtn.selected = NO;
                    }else{
                        weakSelf.seeFatherLabel.text = @"公开";
                        weakSelf.fatherBtn.selected = YES;
                    }
                }
                if ( [dict[@"motherName"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * motherDic = dict[@"motherName"];
                    NSNumber * motherStatus = motherDic[@"status"];
                    weakSelf.motherNameTF.text = motherDic[@"name"];
                    if ([motherStatus intValue] == 0) {
                        weakSelf.seeMotherLabel.text = @"非公开";
                        weakSelf.motherBtn.selected = NO;
                    }else{
                        weakSelf.seeMotherLabel.text = @"公开";
                        weakSelf.motherBtn.selected = YES;
                    }
                }
                    weakSelf.starTF.text = [NSString stringWithFormat:@"%@",dict[@"constellation"]];
                    weakSelf.bloodTF.text = [NSString stringWithFormat:@"%@",dict[@"bloodType"]];
                
                if ( [dict[@"marriage"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * marryDic = dict[@"marriage"];
                    NSNumber * marryStatus = marryDic[@"status"];
                    NSNumber * name = marryDic[@"name"];
                    if ([marryStatus intValue] == 0) {
                        weakSelf.seeMarryLabel.text = @"非公开";
                        weakSelf.marryBtn.selected = NO;
                    }else{
                        weakSelf.seeMarryLabel.text = @"公开";
                        weakSelf.marryBtn.selected = YES;
                    }
                    if ([name intValue] == 0) {
                        weakSelf.marryTF.text = @"未婚";
                        [weakSelf commonUI:YES];
                    }else{
                        weakSelf.marryTF.text = @"已婚";
                        [weakSelf commonUI:NO];
 
                    }
                }
                weakSelf.companyTF.text = [NSString stringWithFormat:@"%@",dict[@"company"]];
                NSInteger indu = [dict[@"industry"] integerValue];
                switch (indu) {
                    case 1:
                        weakSelf.industryTF.text = @"其他";
                        break;
                    case 2:
                        weakSelf.industryTF.text = @"互联网";
                        break;
                    case 3:
                        weakSelf.industryTF.text = @"服务业";
                        break;
                    case 4:
                        weakSelf.industryTF.text = @"金融";
                        break;
                    case 5:
                        weakSelf.industryTF.text = @"教师";
                        break;
                    case 6:
                        weakSelf.industryTF.text = @"银行";
                        break;
                    case 7:
                        weakSelf.industryTF.text = @"医疗";
                        break;
                    case 8:
                        weakSelf.industryTF.text = @"房地产";
                        break;
                    case 9:
                        weakSelf.industryTF.text = @"贸易";
                        break;
                    default:
                        weakSelf.industryTF.text = @"物流";
                        break;
                }
                NSInteger deg = [dict[@"degree"] integerValue];
                switch (deg) {
                    case 1:
                        weakSelf.degreeTF.text = @"初中";
                        break;
                    case 2:
                        weakSelf.degreeTF.text = @"高中";
                        break;
                    case 3:
                        weakSelf.degreeTF.text = @"中技";
                        break;
                    case 4:
                        weakSelf.degreeTF.text = @"中专";
                        break;
                    case 5:
                        weakSelf.degreeTF.text = @"大专";
                        break;
                    case 6:
                        weakSelf.degreeTF.text = @"本科";
                        break;
                    case 7:
                        weakSelf.degreeTF.text = @"硕士";
                        break;
                    case 8:
                        weakSelf.degreeTF.text = @"博士";
                        break;
                    case 9:
                        weakSelf.degreeTF.text = @"MBA";
                        break;
                    case 10:
                        weakSelf.degreeTF.text = @"EMBA";
                        break;
                    default:
                        weakSelf.degreeTF.text = @"其他";
                        break;
                }

                NSArray * home = [dict[@"homeplace"] componentsSeparatedByString:@","];
                weakSelf.homeProTF.text = home[0];
                weakSelf.homeCityTF.text = home[1];
                weakSelf.homeDisTF.text = home[2];
                if ( [dict[@"position"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * postDic = dict[@"position"];
                    NSNumber * postStatus = postDic[@"status"];
                    weakSelf.postTF.text = postDic[@"name"];
                    if ([postStatus intValue] == 0) {
                        weakSelf.seePostLabel.text = @"非公开";
                        weakSelf.postBtn.selected = NO;
                    }else{
                        weakSelf.seePostLabel.text = @"公开";
                        weakSelf.postBtn.selected = YES;
                    }
                }
                if ( [dict[@"spouseName"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * wifeDic = dict[@"spouseName"];
                    NSNumber * wifeStatus = wifeDic[@"status"];
                    weakSelf.wifeNameTF.text = wifeDic[@"name"];
                    if ([wifeStatus intValue] == 0) {
                        weakSelf.seeWifeLabel.text = @"非公开";
                        weakSelf.wifeBtn.selected = NO;
                    }else{
                        weakSelf.seeWifeLabel.text = @"公开";
                        weakSelf.wifeBtn.selected = YES;
                    }
                }
                if ( [dict[@"childrenName"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * childDic = dict[@"childrenName"];
                    NSNumber * childStatus = childDic[@"status"];
                    weakSelf.childNameTF.text = childDic[@"name"];
                    if ([childStatus intValue] == 0) {
                        weakSelf.seeChildLabel.text = @"非公开";
                        weakSelf.childBtn.selected = NO;
                    }else{
                        weakSelf.seeChildLabel.text = @"公开";
                        weakSelf.childBtn.selected = YES;
                    }
                }
                if ( [dict[@"childrenSchool"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * schoolDic = dict[@"childrenSchool"];
                    NSNumber * schoolStatus = schoolDic[@"status"];
                    weakSelf.childSchoolTF.text = schoolDic[@"name"];
                    if ([schoolStatus intValue] == 0) {
                        weakSelf.seeChildSchLabel.text = @"非公开";
                        weakSelf.childScBtn.selected = NO;
                    }else{
                        weakSelf.seeChildSchLabel.text = @"公开";
                        weakSelf.childScBtn.selected = YES;
                    }
                }
 
            }else{
                [weakSelf showMessage:@"加载数据失败！"];
            }
 
        }
        
    }];

}
 
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)saveInfo{
    [self resign];
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf postData];
    });
}
-(void)postData{
    WeakSelf;
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setValue:self.userId forKey:@"userId"];
    [params setValue:self.nameTF.text forKey:@"fullName"];
    [params setValue:self.nameBtn.selected?@"1":@"0" forKey:@"SfullName"];
    [params setValue:self.phoneTF.text forKey:@"mobile"];
    [params setValue:self.phoneBtn.selected?@"1":@"0" forKey:@"Smobile"];
    
    [params setValue:self.birthday forKey:@"birthday"];
    [params setValue:self.birthBtn.selected?@"1":@"0" forKey:@"Sbirthday"];
    
    [params setValue:self.QQTF.text forKey:@"QQ"];
    [params setValue:self.chatTF.text forKey:@"wechat"];

    //学历
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
    [params setValue:self.fatherNameTF.text forKey:@"fatherName"];
    [params setValue:self.fatherBtn.selected?@"1":@"0" forKey:@"SfatherName"];
    [params setValue:self.motherNameTF.text forKey:@"motherName"];
    [params setValue:self.motherBtn.selected?@"1":@"0" forKey:@"SmotherName"];

    [params setValue:self.wifeNameTF.text forKey:@"spouseName"];
    [params setValue:self.wifeBtn.selected?@"1":@"0" forKey:@"SspouseName"];
    [params setValue:self.childNameTF.text forKey:@"childrenName"];
    [params setValue:self.childBtn.selected?@"1":@"0" forKey:@"SchildrenName"];
    

    [params setValue:self.childSchoolTF.text forKey:@"childrenSchool"];
    [params setValue:self.childScBtn.selected?@"1":@"0" forKey:@"SchildrenSchool"];
    

    [params setValue:self.schoolTF.text forKey:@"finishSchool"];
    [params setValue:self.schoolBtn.selected?@"1":@"0" forKey:@"SfinishSchool"];

    [params setValue:self.starTF.text forKey:@"constellation"];

    [params setValue:self.bloodTF.text forKey:@"bloodType"];
    NSString * status;
    if ([self.marryTF.text isEqualToString:@"已婚"]) {
        status = @"1";
    }else{
        status = @"0";
    }
    [params setValue:status forKey:@"marriage"];
    [params setValue:self.marryBtn.selected?@"1":@"0" forKey:@"Smarriage"];
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
    //籍贯
    [params setValue:[NSString stringWithFormat:@"%@,%@,%@",self.homeProTF.text,self.homeCityTF.text,self.homeDisTF.text] forKey:@"homeplace"];

    [params setValue:self.companyTF.text forKey:@"company"];

    [params setValue:self.postTF.text forKey:@"position"];
    [params setValue:self.postBtn.selected?@"1":@"0" forKey:@"Sposition"];
    NSSLog(@"%@",params);
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,SaveInfoURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSSLog(@"个人消息更多请求失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                //生日和电话重新保存
                [userDefaults setValue:weakSelf.birthday forKey:@"birthday"];
                [userDefaults setValue:weakSelf.phoneTF.text forKey:@"mobile"];
                [userDefaults synchronize];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showMessage:@"修改失败，重试！"];
            }
            
        }
    }];
    
}
#pragma mark-textField-delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameTF) {
        [self.nameTF resignFirstResponder];
        [self.phoneTF becomeFirstResponder];
    }else if (textField == self.phoneTF){
        [self.phoneTF resignFirstResponder];
        [self.QQTF becomeFirstResponder];
    }else if (textField == self.QQTF){
        [self.QQTF resignFirstResponder];
        [self.chatTF becomeFirstResponder];
    }else if (textField == self.chatTF){
        [self.chatTF resignFirstResponder];
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
        if (self.marryHeightCons.constant == 0) {
            [self resign];
        }else{
            [self.motherNameTF resignFirstResponder];
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
    CGFloat offset = textField.frame.origin.y+50-(KMainScreenHeight-216);
    if (textField == self.companyTF||textField == self.postTF||textField == self.fatherNameTF||textField == self.motherNameTF){
        self.bottomView.hidden = YES;
        self.view.frame = CGRectMake(0, -offset-64, KMainScreenWidth, KMainScreenHeight+offset+64);
        return YES;

    }else if (textField == self.wifeNameTF||textField == self.childNameTF||textField == self.childSchoolTF){
        self.bottomView.hidden = YES;
        CGFloat offset1 = self.marryView.frame.origin.y+textField.frame.origin.y+50-(KMainScreenHeight-216);
        self.view.frame = CGRectMake(0, -offset1-64, KMainScreenWidth, KMainScreenHeight+offset1+64);
        return YES;
        
    }else if (textField == self.marryTF||textField == self.starTF || textField == self.bloodTF||textField == self.homeProTF||textField == self.homeCityTF || textField == self.homeDisTF|| textField == self.degreeTF|| textField == self.industryTF){
        [self resign];
        self.bottomView.hidden = NO;
        if (self.starTF == textField) {
            [self hidden];
            self.flag = 1;
            self.startArr = @[@"水瓶座",@"双鱼座",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座"];
        }else if (textField ==self.bloodTF){
            [self hidden];
              //血型
            self.flag = 2;
            self.bloodArr = @[@"A型",@"B型",@"AB型",@"O型",@"其他"];
        }else if(textField == self.marryTF){
            [self hidden];

            //婚姻
            self.flag = 3;
            self.marryArr = @[@"未婚",@"已婚"];
        }else  if (textField == self.homeProTF) {
            [self hidden];
            self.flag = 6;
            [self getAllData];
        }else if (textField == self.homeCityTF){
            if (self.homeProTF.text.length != 0) {
                [self hidden];
                self.flag = 7;
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
                self.flag = 8;
                for (NSDictionary *dict in self.allArr) {
                    
                    if ([dict objectForKey:self.provinceArr[self.proIndex]]) {
                        self.districtArr = [NSMutableArray arrayWithArray:[[dict objectForKey:self.provinceArr[self.proIndex]] objectForKey:self.cityArr[self.cityIndex]]];
                        break;
                    }
                }
            }
        }else if (textField == self.industryTF){
            [self hidden];
            self.flag = 5;
            //行业
            self.industryArr = @[@"互联网",@"服务业",@"金融",@"教师",@"银行",@"医疗",@"房地产",@"贸易",@"物流",@"其他"];
        }else if (textField == self.degreeTF){
            //学历
            [self hidden];
            self.flag = 4;
            self.degreeArr = @[@"初中",@"高中",@"中技",@"中专",@"大专",@"本科",@"硕士",@"博士",@"MBA",@"EMBA",@"其他"];
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
        self.flag = 9;
        return NO;
    }else{
        self.bottomView.hidden = YES;
        return YES;

    }
}
-(void)hidden{
    self.bottomView.hidden = NO;
    self.datePicker.hidden = YES;
    self.pickerView.hidden = NO;
}
-(void)getAllData{
    self.allArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
    for (NSDictionary *dci in self.allArr) {
        [self.provinceArr addObject:[[dci allKeys] firstObject]];
    }
}
-(void)resign{
    [self.chatTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
    [self.QQTF resignFirstResponder];
    [self.schoolTF resignFirstResponder];
    [self.companyTF resignFirstResponder];
    [self.postTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.wifeNameTF resignFirstResponder];
    [self.childNameTF resignFirstResponder];
    [self.childSchoolTF resignFirstResponder];
    [self.fatherNameTF resignFirstResponder];
    [self.motherNameTF resignFirstResponder];
    self.view.frame = CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight);
}
- (IBAction)nameBtnClick:(id)sender {
    self.nameBtn.selected = !self.nameBtn.selected;
    if (self.nameBtn.selected) {
        self.seeNameLabel.text = @"公开";
    }else{
        self.seeNameLabel.text = @"非公开";
 
    }
}
- (IBAction)phoneBtnClick:(id)sender {
    self.phoneBtn.selected = !self.phoneBtn.selected;
    if (self.phoneBtn.selected) {
        self.seePhoneLabel.text = @"公开";
    }else{
        self.seePhoneLabel.text = @"非公开";
        
    }
}

- (IBAction)birthBtnClick:(id)sender {
    self.birthBtn.selected = !self.birthBtn.selected;
    if (self.birthBtn.selected) {
        self.seeBirthLabel.text = @"公开";
    }else{
        self.seeBirthLabel.text = @"非公开";
        
    }
}
- (IBAction)wifeBtnClick:(id)sender {
    self.wifeBtn.selected = !self.wifeBtn.selected;
    if (self.wifeBtn.selected) {
        self.seeWifeLabel.text = @"公开";
    }else{
        self.seeWifeLabel.text = @"非公开";
        
    }
}

- (IBAction)childBtnClick:(id)sender {
    self.childBtn.selected = !self.childBtn.selected;
    if (self.childBtn.selected) {
        self.seeChildLabel.text = @"公开";
    }else{
        self.seeChildLabel.text = @"非公开";
        
    }
}
- (IBAction)childSchBtnClick:(id)sender {
    self.childScBtn.selected = !self.childScBtn.selected;
    if (self.childScBtn.selected) {
        self.seeChildSchLabel.text = @"公开";
    }else{
        self.seeChildSchLabel.text = @"非公开";
        
    }
}
- (IBAction)fatherNameBtnClick:(id)sender {
    self.fatherBtn.selected = !self.fatherBtn.selected;
    if (self.fatherBtn.selected) {
        self.seeFatherLabel.text = @"公开";
    }else{
        self.seeFatherLabel.text = @"非公开";
        
    }
}
- (IBAction)motherNameBtnClick:(id)sender {
    self.motherBtn.selected = !self.motherBtn.selected;
    if (self.motherBtn.selected) {
        self.seeMotherLabel.text = @"公开";
    }else{
        self.seeMotherLabel.text = @"非公开";
        
    }
}
- (IBAction)postBtnClick:(id)sender {
    self.postBtn.selected = !self.postBtn.selected;
    if (self.postBtn.selected) {
        self.seePostLabel.text = @"公开";
    }else{
        self.seePostLabel.text = @"非公开";
        
    }
}
- (IBAction)marryBtnClick:(id)sender {
    self.marryBtn.selected = !self.marryBtn.selected;
    if (self.marryBtn.selected) {
        self.seeMarryLabel.text = @"公开";
    }else{
        self.seeMarryLabel.text = @"非公开";
        
    }
}
- (IBAction)schoolClick:(id)sender {
    self.schoolBtn.selected = !self.schoolBtn.selected;
    if (self.schoolBtn.selected) {
        self.seeSchoolLabel.text = @"公开";
    }else{
        self.seeSchoolLabel.text = @"非公开";
        
    }
}

- (IBAction)finishClick:(id)sender {
    switch (self.flag) {
        case 1:
            self.starTF.text = self.startArr[self.starIndex];
            
            break;
        case 2:
            self.bloodTF.text = self.bloodArr[self.bloodIndex];
            
            break;
        case 3:
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
        case 4:
            //学历
            self.degreeTF.text = self.degreeArr[self.degreeIndex];
            break;
        case 5:
            //行业
            self.industryTF.text = self.industryArr[self.industryIndex];
            break;
        case 6:
            self.homeProTF.text = self.provinceArr[self.proIndex];
            
            break;
        case 7:
            self.homeCityTF.text = self.cityArr[self.cityIndex];
            
            break;
        case 8:
            self.homeDisTF.text = self.districtArr[self.districtIndex];
            
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
            self.starIndex = row;

        }
            break;
        case 2:
        {
            self.bloodIndex = row;

        }
            break;
        case 3:
        {
            self.marryIndex = row;
        }
            break;
        case 4:
        {
            self.degreeIndex = row;
        }
            break;
        case 5:
        {
            self.industryIndex = row;
        }
            break;
    
        case 6:
        {
            self.proIndex = row;
            self.cityIndex = 0;
            self.districtIndex = 0;
        }
            break;
        case 7:
        {
            self.cityIndex = row;
            self.districtIndex = 0;
        }
            break;
        default :
        {
            self.districtIndex = row;
            
        }
            break;
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (self.flag) {
        case 1:
            return [self.startArr objectAtIndex:row];
        case 2:
            return [self.bloodArr objectAtIndex:row];
        case 3:
            return [self.marryArr objectAtIndex:row];
        case 4:
            return [self.degreeArr objectAtIndex:row];
        case 5:
            return [self.industryArr objectAtIndex:row];
        case 6:
            return [self.provinceArr objectAtIndex:row];
        case 7:
            return [self.cityArr objectAtIndex:row];
        default :
            return [self.districtArr objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (self.flag) {
        case 1:
            return self.startArr.count;
            
        case 2:
            return self.bloodArr.count;
            
        case 3:
            return self.marryArr.count;
            
        case 4:
            return self.degreeArr.count;
            
        case 5:
            return self.industryArr.count;
            
        case 6:
            return self.provinceArr.count;
            
        case 7:
            return self.cityArr.count;
            
        default :
            return self.districtArr.count;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
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
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}


@end
