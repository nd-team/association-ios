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
@interface PersonMoreInfoController ()<UITextFieldDelegate>


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
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (weak, nonatomic) IBOutlet UIButton *hobbyBtn;
@property (weak, nonatomic) IBOutlet UIButton *schoolBtn;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet UIButton *bloodBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *marryBtn;

@property (weak, nonatomic) IBOutlet UIButton *danceBtn;

@property (weak, nonatomic) IBOutlet UIButton *singBtn;
@property (weak, nonatomic) IBOutlet UIButton *printBtn;
@property (weak, nonatomic) IBOutlet UIButton *pianoBtn;

@property (weak, nonatomic) IBOutlet UIButton *sleepBtn;
@property (weak, nonatomic) IBOutlet UIButton *movieBtn;
@property (weak, nonatomic) IBOutlet UIButton *hanBtn;
@property (weak, nonatomic) IBOutlet UIButton *artBtn;
@property (weak, nonatomic) IBOutlet UIButton *eatBtn;

@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
@property (weak, nonatomic) IBOutlet UIButton *mountainBtn;
@property (weak, nonatomic) IBOutlet UILabel *seeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeQQLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeChatLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeHobbyLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeStarLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeBloodLabel;


@property (weak, nonatomic) IBOutlet UILabel *seeCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *seePostLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeSchoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeMarryLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *chessBtn;



@end

@implementation PersonMoreInfoController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"取消" andLeft:-15 andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"保存" andLeft:15 andTarget:self Action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    [self setButtonBackImage:self.nameBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
    [self setButtonBackImage:self.QQBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
    [self setButtonBackImage:self.chatBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
    [self setButtonBackImage:self.hobbyBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
    [self setButtonBackImage:self.schoolBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
    [self setButtonBackImage:self.starBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
    [self setButtonBackImage:self.bloodBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
    [self setButtonBackImage:self.companyBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
    [self setButtonBackImage:self.postBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
    [self setButtonBackImage:self.marryBtn andNormalImage:@"switchOff" andSelectImage:@"switchOn"];
    [self setButtonBackImage:self.danceBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.singBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.printBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.pianoBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.sleepBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.movieBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.hanBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.artBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.eatBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.bookBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.mountainBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];
    [self setButtonBackImage:self.chessBtn andNormalImage:@"hobbyWhite" andSelectImage:@"hobbyGreen"];

    [self setTitleButton:self.danceBtn];
    [self setTitleButton:self.singBtn];
    [self setTitleButton:self.printBtn];
    [self setTitleButton:self.pianoBtn];
    [self setTitleButton:self.sleepBtn];
    [self setTitleButton:self.movieBtn];
    [self setTitleButton:self.eatBtn];
    [self setTitleButton:self.hanBtn];
    [self setTitleButton:self.artBtn];
    [self setTitleButton:self.bookBtn];
    [self setTitleButton:self.mountainBtn];
    [self setTitleButton:self.chessBtn];

    //手势回收键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    [self.view addGestureRecognizer:tap];

    //初始化界面数据
    [self getMoreInfo];

}
-(void)setButtonBackImage:(UIButton *)btn andNormalImage:(NSString *)norImg andSelectImage:(NSString *)selImg{
    [btn setBackgroundImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selImg] forState:UIControlStateSelected];
    
}
-(void)setTitleButton:(UIButton *)btn{
    [btn setTitleColor:UIColorFromRGB(0x18bc8b) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x11624a) forState:UIControlStateSelected];
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
                NSSLog(@"%@",dict);
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
    [params setValue:self.nameTF.text forKey:@"fullName"];
    [params setValue:self.nameBtn.selected?@"1":@"0" forKey:@"SfullName"];
    
    [params setValue:self.QQTF.text forKey:@"QQ"];
    [params setValue:self.QQBtn.selected?@"1":@"0" forKey:@"SQQ"];
    NSMutableString * hobby = [NSMutableString new];
    if (self.danceBtn.selected) {
        [hobby appendString:@"舞蹈,"];
    }
    if (self.singBtn.selected) {
        [hobby appendString:@"音乐,"];
    }
    if (self.printBtn.selected) {
        [hobby appendString:@"画画,"];
    }
    if (self.pianoBtn.selected) {
        [hobby appendString:@"乐器,"];
    }
    if (self.sleepBtn.selected) {
        [hobby appendString:@"游戏,"];
    }
    if (self.movieBtn.selected) {
        [hobby appendString:@"影视,"];
    }
    if (self.eatBtn.selected) {
        [hobby appendString:@"旅游,"];
    }
    if (self.chessBtn.selected) {
        [hobby appendString:@"棋类,"];
    }
    if (self.hanBtn.selected) {
        [hobby appendString:@"美食,"];
    }
    if (self.artBtn.selected) {
        [hobby appendString:@"社交,"];
    }
    if (self.bookBtn.selected) {
        [hobby appendString:@"阅读,"];
    }
    if (self.mountainBtn.selected) {
        [hobby appendString:@"运动,"];
    }
   
    [params setValue:hobby forKey:@"favour"];
    [params setValue:self.hobbyBtn.selected?@"1":@"0" forKey:@"Sfavour"];
    
    [params setValue:self.schoolTF.text forKey:@"finishSchool"];
    [params setValue:self.schoolBtn.selected?@"1":@"0" forKey:@"SfinishSchool"];

    [params setValue:self.starTF.text forKey:@"constellation"];
    [params setValue:self.starBtn.selected?@"1":@"0" forKey:@"Sconstellation"];

    [params setValue:self.bloodTF.text forKey:@"bloodType"];
    [params setValue:self.bloodBtn.selected?@"1":@"0" forKey:@"SbloodType"];
    NSString * status;
    if ([self.marryTF.text isEqualToString:@"已婚"]) {
        status = @"1";
    }else{
        status = @"0";
    }
    [params setValue:status forKey:@"marriage"];
    [params setValue:self.marryBtn.selected?@"1":@"0" forKey:@"Smarriage"];

    [params setValue:self.companyTF.text forKey:@"company"];
    [params setValue:self.companyBtn.selected?@"1":@"0" forKey:@"Scompany"];

    [params setValue:self.postTF.text forKey:@"position"];
    [params setValue:self.postBtn.selected?@"1":@"0" forKey:@"Sposition"];

    [params setValue:self.chatTF.text forKey:@"wechat"];
    [params setValue:self.chatBtn.selected?@"1":@"0" forKey:@"Swechat"];

    [params setValue:self.userId forKey:@"userId"];
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,SaveInfoURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"已推荐人请求失败：%@",error);
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
        [self.QQTF becomeFirstResponder];
    }else if (textField == self.QQTF){
        [self.QQTF resignFirstResponder];
        [self.chatTF becomeFirstResponder];
    }else if (textField == self.chatTF){
        [self.chatTF resignFirstResponder];
        [self.schoolTF becomeFirstResponder];
    }else if (textField == self.schoolTF){
        [self.schoolTF resignFirstResponder];
        [self.starTF becomeFirstResponder];
    }else if (textField == self.starTF){
        [self.starTF resignFirstResponder];
        [self.bloodTF becomeFirstResponder];
    }else if (textField == self.bloodTF){
        [self.bloodTF resignFirstResponder];
        [self.companyTF becomeFirstResponder];

    }else if (textField == self.companyTF){
        [self.companyTF resignFirstResponder];
        [self.postTF becomeFirstResponder];

    }else if (textField == self.postTF){
        [self.postTF resignFirstResponder];
        [self.marryTF becomeFirstResponder];
    }else if (textField == self.marryTF){
        [self resign];
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = textField.frame.origin.y+50-(KMainScreenHeight-216);
    if (textField == self.starTF||textField == self.bloodTF||textField == self.companyTF||textField == self.postTF||textField == self.marryTF){
        self.view.frame = CGRectMake(0, -offset, KMainScreenWidth, KMainScreenHeight);
    }
    return YES;
}
-(void)resign{
    [self.marryTF resignFirstResponder];
    [self.chatTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
    [self.QQTF resignFirstResponder];
    [self.schoolTF resignFirstResponder];
    [self.starTF resignFirstResponder];
    [self.bloodTF resignFirstResponder];
    [self.companyTF resignFirstResponder];
    [self.postTF resignFirstResponder];
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
- (IBAction)qqBtnClick:(id)sender {
    self.QQBtn.selected = !self.QQBtn.selected;
    if (self.QQBtn.selected) {
        self.seeQQLabel.text = @"公开";
    }else{
        self.seeQQLabel.text = @"非公开";
        
    }
}

- (IBAction)chatBtnClick:(id)sender {
    self.chatBtn.selected = !self.chatBtn.selected;
    if (self.chatBtn.selected) {
        self.seeChatLabel.text = @"公开";
    }else{
        self.seeChatLabel.text = @"非公开";
        
    }
}
- (IBAction)hobbyBtnClick:(id)sender {
    self.hobbyBtn.selected = !self.hobbyBtn.selected;
    if (self.hobbyBtn.selected) {
        self.seeHobbyLabel.text = @"公开";
    }else{
        self.seeHobbyLabel.text = @"非公开";
        
    }
}
- (IBAction)schoolBtnClick:(id)sender {
    self.schoolBtn.selected = !self.schoolBtn.selected;
    if (self.schoolBtn.selected) {
        self.seeSchoolLabel.text = @"公开";
    }else{
        self.seeSchoolLabel.text = @"非公开";
        
    }
}

- (IBAction)startBtnClick:(id)sender {
    self.starBtn.selected = !self.starBtn.selected;
    if (self.starBtn.selected) {
        self.seeStarLabel.text = @"公开";
    }else{
        self.seeStarLabel.text = @"非公开";
        
    }
}
- (IBAction)bloodBtnClick:(id)sender {
    self.bloodBtn.selected = !self.bloodBtn.selected;
    if (self.bloodBtn.selected) {
        self.seeBloodLabel.text = @"公开";
    }else{
        self.seeBloodLabel.text = @"非公开";
        
    }
}
- (IBAction)companyBtnClick:(id)sender {
    self.companyBtn.selected = !self.companyBtn.selected;
    if (self.companyBtn.selected) {
        self.seeCompanyLabel.text = @"公开";
    }else{
        self.seeCompanyLabel.text = @"非公开";
        
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
- (IBAction)danceBtnClick:(id)sender {
    self.danceBtn.selected = !self.danceBtn.selected;

}
- (IBAction)singBtnClick:(id)sender {
    self.singBtn.selected = !self.singBtn.selected;

}
- (IBAction)printClick:(id)sender {
    self.printBtn.selected = !self.printBtn.selected;

}

- (IBAction)pianoClick:(id)sender {
    self.pianoBtn.selected = !self.pianoBtn.selected;

}

- (IBAction)sleepClick:(id)sender {
    self.sleepBtn.selected = !self.sleepBtn.selected;

}

- (IBAction)movieClick:(id)sender {
    self.movieBtn.selected = !self.movieBtn.selected;

}
- (IBAction)hanClick:(id)sender {
    self.hanBtn.selected = !self.hanBtn.selected;

}
- (IBAction)artClick:(id)sender {
    self.artBtn.selected = !self.artBtn.selected;

}
- (IBAction)eatClick:(id)sender {
    self.eatBtn.selected = !self.eatBtn.selected;

}

- (IBAction)chessBtnClick:(id)sender {
    self.chessBtn.selected = !self.chessBtn.selected;
    
}

- (IBAction)lookClick:(id)sender {
    self.bookBtn.selected = !self.bookBtn.selected;

}
- (IBAction)mountainClick:(id)sender {
    self.mountainBtn.selected = !self.mountainBtn.selected;

}







@end
