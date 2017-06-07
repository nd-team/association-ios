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

@property (weak, nonatomic) IBOutlet UILabel *seeChildSchLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeFatherLabel;


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
    [self commonUI:YES];
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
       
        //手势回收键盘
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
        [self.view addGestureRecognizer:tap];
        //初始化界面数据
//        [self getMoreInfo];
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
        self.nameTF.enabled = NO;
        self.QQTF.enabled = NO;
        self.chatTF.enabled = NO;
        self.schoolTF.enabled = NO;
        self.starTF.enabled = NO;
        self.bloodTF.enabled = NO;
        self.companyTF.enabled = NO;
        self.postTF.enabled = NO;
        self.marryTF.enabled = NO;
        
//        [self getUserInformation];
        
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
//-(void)setTitleButton:(UIButton *)btn{
//    [btn setTitleColor:UIColorFromRGB(0x18bc8b) forState:UIControlStateNormal];
//    [btn setTitleColor:UIColorFromRGB(0x11624a) forState:UIControlStateSelected];
//}
//-(void)setDisableAndNormal:(UIButton *)btn{
//    [btn setBackgroundImage:[UIImage imageNamed:@"hobbyGreen"] forState:UIControlStateNormal];
//    [btn setTitleColor:UIColorFromRGB(0x11624a) forState:UIControlStateNormal];
//}
//对方更多信息
/*
-(void)getUserInformation{
    WeakSelf;
    //获取数据初始化数据
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,FriendDetailURL] andParams:@{@"otherUserId":self.friendId,@"status":@"0",@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"好友详情请求失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                NSSLog(@"%@",dict);
                //请求网络数据获取用户详细资料
                if ( [dict[@"fullName"] isKindOfClass:[NSString class]]) {
                    weakSelf.nameTF.text = dict[@"fullName"];

                }
                if ( [dict[@"QQ"] isKindOfClass:[NSString class]]) {
                    weakSelf.QQTF.text = dict[@"QQ"];
    
                }
                if ( [dict[@"wechat"] isKindOfClass:[NSString class]]) {
                    weakSelf.chatTF.text = dict[@"wechat"];
                }
                
                if ( [dict[@"favour"] isKindOfClass:[NSString class]]) {
                    NSString * hobby = dict[@"favour"];
                    if ([hobby containsString:@"舞蹈"]) {
//                        weakSelf.danceBtn.selected = YES;
                     
                        [weakSelf setDisableAndNormal:weakSelf.danceBtn];

                    }
                    if ([hobby containsString:@"音乐"]){
//                        weakSelf.singBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.singBtn];

                    }
                    if ([hobby containsString:@"画画"]){
//                        weakSelf.printBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.pianoBtn];

                    }
                    if ([hobby containsString:@"乐器"]){
//                        weakSelf.pianoBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.pianoBtn];

                    }
                    if ([hobby containsString:@"游戏"]){
//                        weakSelf.sleepBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.sleepBtn];

                    }
                    if ([hobby containsString:@"影视"]){
//                        weakSelf.movieBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.movieBtn];

                    }
                    if ([hobby containsString:@"旅行"]){
//                        weakSelf.eatBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.eatBtn];

                    }
                    if ([hobby containsString:@"棋类"]){
//                        weakSelf.chessBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.chessBtn];

                    }
                    if ([hobby containsString:@"美食"]){
//                        weakSelf.hanBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.hanBtn];

                    }
                    if ([hobby containsString:@"社交"]){
//                        weakSelf.artBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.artBtn];

                    }
                    if ([hobby containsString:@"阅读"]){
//                        weakSelf.bookBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.bookBtn];

                    }
                    if ([hobby containsString:@"运动"]){
//                        weakSelf.mountainBtn.selected = YES;
                        [weakSelf setDisableAndNormal:weakSelf.mountainBtn];

                    }
                }
                if ( [dict[@"finishSchool"] isKindOfClass:[NSString class]]) {
                    weakSelf.schoolTF.text = dict[@"finishSchool"];
                }
                
                if ( [dict[@"constellation"] isKindOfClass:[NSString class]]) {
                    weakSelf.starTF.text = dict[@"constellation"];
                }
                
                if ( [dict[@"bloodType"] isKindOfClass:[NSString class]]) {
                    weakSelf.bloodTF.text = dict[@"bloodType"];
                }
                
                if ( [dict[@"marriage"] isKindOfClass:[NSString class]]) {
                    NSNumber * name = dict[@"marriage"];
                    if ([name intValue] == 0) {
                        weakSelf.marryTF.text = @"未婚";
                    }else{
                        weakSelf.marryTF.text = @"已婚";
                        
                    }
                }
                
                if ( [dict[@"company"] isKindOfClass:[NSString class]]) {
                    weakSelf.companyTF.text = dict[@"company"];
                }
                
                if ( [dict[@"position"] isKindOfClass:[NSString class]]) {
                    weakSelf.postTF.text = dict[@"position"];
                }

                
            }
        }
    }];
    
}

-(void)getMoreInfo{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MoreInfoURL] andParams:@{@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取用户信息失败%@",error);
        }else{
        
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
//                NSSLog(@"%@",dict);
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
                if ( [dict[@"QQ"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * qqDic = dict[@"QQ"];
                    NSNumber * qqStatus = qqDic[@"status"];
                    weakSelf.QQTF.text = qqDic[@"name"];
                    if ([qqStatus intValue] == 0) {
                        weakSelf.seeQQLabel.text = @"非公开";
                        weakSelf.QQBtn.selected = NO;
                    }else{
                        weakSelf.seeQQLabel.text = @"公开";
                        weakSelf.QQBtn.selected = YES;
                    }

                }
                if ( [dict[@"wechat"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * chatDic = dict[@"wechat"];
                    NSNumber * chatStatus = chatDic[@"status"];
                    weakSelf.chatTF.text = chatDic[@"name"];
                    if ([chatStatus intValue] == 0) {
                        weakSelf.seeChatLabel.text = @"非公开";
                        weakSelf.chatBtn.selected = NO;
                    }else{
                        weakSelf.seeChatLabel.text = @"公开";
                        weakSelf.chatBtn.selected = YES;
                    }
                }
                
                if ( [dict[@"favour"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * favourDic = dict[@"favour"];
                    NSNumber * favourStatus = favourDic[@"status"];
                    if ([favourStatus intValue] == 0) {
                        weakSelf.seeHobbyLabel.text = @"非公开";
                        weakSelf.hobbyBtn.selected = NO;
                    }else{
                        weakSelf.seeHobbyLabel.text = @"公开";
                        weakSelf.hobbyBtn.selected = YES;
                    }
                    NSString * hobby = favourDic[@"name"];
                    if ([hobby containsString:@"舞蹈"]) {
                        weakSelf.danceBtn.selected = YES;
                    }
                    if ([hobby containsString:@"音乐"]){
                        weakSelf.singBtn.selected = YES;
                        
                    }
                    if ([hobby containsString:@"画画"]){
                        weakSelf.printBtn.selected = YES;
                        
                    }
                    if ([hobby containsString:@"乐器"]){
                        weakSelf.pianoBtn.selected = YES;
                        
                    }
                    if ([hobby containsString:@"游戏"]){
                        weakSelf.sleepBtn.selected = YES;
                        
                    }
                    if ([hobby containsString:@"影视"]){
                        weakSelf.movieBtn.selected = YES;
                        
                    }
                    if ([hobby containsString:@"旅行"]){
                        weakSelf.eatBtn.selected = YES;
                        
                    }
                    if ([hobby containsString:@"棋类"]){
                        weakSelf.chessBtn.selected = YES;
                        
                    }
                    if ([hobby containsString:@"美食"]){
                        weakSelf.hanBtn.selected = YES;
                        
                    }
                    if ([hobby containsString:@"社交"]){
                        weakSelf.artBtn.selected = YES;
                        
                    }
                    if ([hobby containsString:@"阅读"]){
                        weakSelf.bookBtn.selected = YES;
                        
                    }
                    if ([hobby containsString:@"运动"]){
                        weakSelf.mountainBtn.selected = YES;
                        
                    }
                }
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
                
                if ( [dict[@"constellation"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * starDic = dict[@"constellation"];
                    NSNumber * starStatus = starDic[@"status"];
                    weakSelf.starTF.text = starDic[@"name"];
                    if ([starStatus intValue] == 0) {
                        weakSelf.seeStarLabel.text = @"非公开";
                        weakSelf.starBtn.selected = NO;
                    }else{
                        weakSelf.seeStarLabel.text = @"公开";
                        weakSelf.starBtn.selected = YES;
                    }
                }
                
                if ( [dict[@"bloodType"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * bloodDic = dict[@"bloodType"];
                    NSNumber * bloodStatus = bloodDic[@"status"];
                    weakSelf.bloodTF.text = bloodDic[@"name"];
                    if ([bloodStatus intValue] == 0) {
                        weakSelf.seeBloodLabel.text = @"非公开";
                        weakSelf.bloodTF.selected = NO;
                    }else{
                        weakSelf.seeBloodLabel.text = @"公开";
                        weakSelf.bloodTF.selected = YES;
                    }
                }
               
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
                    }else{
                        weakSelf.marryTF.text = @"已婚";
 
                    }
                }
                
                if ( [dict[@"company"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * companyDic = dict[@"company"];
                    NSNumber * companyStatus = companyDic[@"status"];
                    weakSelf.companyTF.text = companyDic[@"name"];
                    if ([companyStatus intValue] == 0) {
                        weakSelf.seeCompanyLabel.text = @"非公开";
                        weakSelf.companyBtn.selected = NO;
                    }else{
                        weakSelf.seeCompanyLabel.text = @"公开";
                        weakSelf.companyBtn.selected = YES;
                    }
                }
                
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
                
 
            }
 
        }
        
    }];

}
 */
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)saveInfo{
    [self resign];
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf postData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
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
        if (error) {
            NSSLog(@"个人消息更多请求失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                NSSLog(@"修改失败");
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
//    NSSLog(@"%f",KMainScreenWidth);
    if (KMainScreenWidth == 375) {
        self.viewWidthCons.constant = KMainScreenWidth+5;

    }else{
        self.viewWidthCons.constant = KMainScreenWidth;

    }
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



@end
