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

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
//索引
@property (nonatomic,assign)NSInteger starIndex;

@property (nonatomic,assign)NSInteger bloodIndex;
@property (nonatomic,assign)NSInteger marryIndex;
//数据源
@property (nonatomic,strong)NSArray * startArr;
@property (nonatomic,strong)NSArray * bloodArr;
@property (nonatomic,strong)NSArray * marryArr;

//标记pickerView的数据源 1:星座2：血型3：婚姻
@property (nonatomic,assign)int flag;

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

    if (self.isCurrent) {
        UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"保存" andLeft:15 andTarget:self Action:@selector(saveInfo)];
        self.navigationItem.rightBarButtonItem = rightItem;
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
       
        //手势回收键盘
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
        [self.view addGestureRecognizer:tap];
        //初始化界面数据
        [self getMoreInfo];
    }else{
        //别人的信息=所有都不可用，按钮隐藏
        self.nameBtn.hidden = YES;
        self.QQBtn.hidden = YES;
        self.chatBtn.hidden = YES;
        self.hobbyBtn.hidden = YES;
        self.schoolBtn.hidden = YES;
        self.starBtn.hidden = YES;
        self.bloodBtn.hidden = YES;
        self.companyBtn.hidden = YES;
        self.postBtn.hidden = YES;
        self.marryBtn.hidden = YES;
        self.seeNameLabel.hidden = YES;
        self.seeQQLabel.hidden = YES;
        self.seeChatLabel.hidden = YES;
        self.seeHobbyLabel.hidden = YES;
        self.seeSchoolLabel.hidden = YES;
        self.seeStarLabel.hidden = YES;
        self.seeBloodLabel.hidden = YES;
        self.seeCompanyLabel.hidden = YES;
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
        
        self.danceBtn.enabled = NO;
        self.singBtn.enabled = NO;
        self.printBtn.enabled = NO;
        self.pianoBtn.enabled = NO;
        self.sleepBtn.enabled = NO;
        self.movieBtn.enabled = NO;
        self.hanBtn.enabled = NO;
        self.artBtn.enabled = NO;
        self.eatBtn.enabled = NO;
        self.bookBtn.enabled = NO;
        self.mountainBtn.enabled = NO;
        self.chessBtn.enabled = NO;
        [self getUserInformation];
        
    }

}
-(void)setButtonBackImage:(UIButton *)btn andNormalImage:(NSString *)norImg andSelectImage:(NSString *)selImg{
    [btn setBackgroundImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selImg] forState:UIControlStateSelected];
    
}
-(void)setTitleButton:(UIButton *)btn{
    [btn setTitleColor:UIColorFromRGB(0x18bc8b) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x11624a) forState:UIControlStateSelected];
}
-(void)setDisableAndNormal:(UIButton *)btn{
    [btn setBackgroundImage:[UIImage imageNamed:@"hobbyGreen"] forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x11624a) forState:UIControlStateNormal];
}
//对方更多信息
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
        [self.companyTF becomeFirstResponder];
    }else if (textField == self.companyTF){
        [self.companyTF resignFirstResponder];
        [self.postTF becomeFirstResponder];

    }else if (textField == self.postTF){
         [self resign];
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = textField.frame.origin.y+50-(KMainScreenHeight-216);
    if (textField == self.companyTF||textField == self.postTF){
        self.bottomView.hidden = YES;
        self.view.frame = CGRectMake(0, -offset-64, KMainScreenWidth, KMainScreenHeight+offset+64);
        return YES;

    }else if (textField == self.marryTF||textField == self.starTF || textField == self.bloodTF){
        [self resign];
        self.bottomView.hidden = NO;
        if (self.starTF == textField) {
            
            self.flag = 1;
            self.startArr = @[@"水瓶座",@"双鱼座",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座"];
        }else if (textField ==self.bloodTF){
              //血型
            self.flag = 2;
            self.bloodArr = @[@"A型",@"B型",@"AB型",@"O型",@"其他"];
        }else{
         
            //婚姻
            self.flag = 3;
            self.marryArr = @[@"未婚",@"已婚"];
        }
        [self.pickerView reloadComponent:0];
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        if ([self.pickerView.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
            [self.pickerView.delegate pickerView:self.pickerView didSelectRow:0 inComponent:0];
        }
        return NO;

    }else{
        self.bottomView.hidden = YES;
        return YES;

    }
}
-(void)resign{
    [self.chatTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
    [self.QQTF resignFirstResponder];
    [self.schoolTF resignFirstResponder];
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

- (IBAction)finishClick:(id)sender {
    switch (self.flag) {
        case 1:
            self.starTF.text = self.startArr[self.starIndex];
            break;
        case 2:
            self.bloodTF.text = self.bloodArr[self.bloodIndex];

            break;
 
        default:
            self.marryTF.text = self.marryArr[self.marryIndex];
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
    if (self.flag == 1) {
        self.starIndex = row;
       
    }
    
    else if (self.flag == 2) {
        self.bloodIndex = row;
        
    }
    
    else {
        self.marryIndex = row;
    }
    
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.flag == 1) {
        return [self.startArr objectAtIndex:row];
    }else if (self.flag == 2){
        return [self.bloodArr objectAtIndex:row];
    }else if (self.flag == 3){
        return [self.marryArr objectAtIndex:row];
    }
    
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.flag == 1) {
        return self.startArr.count;
    }else if (self.flag == 2){
        return self.bloodArr.count;
    }else{
        return self.marryArr.count;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}






@end
