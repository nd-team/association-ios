//
//  RecommendController.m
//  CommunityProject
//
//  Created by bjike on 17/4/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "RecommendController.h"
#import "ProductCodeController.h"

#define RecommendURL @"appapi/app/friendsRecommend"

@interface RecommendController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;

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

@property (nonatomic,copy)NSString * userId;
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

//@property (nonatomic,assign)NSInteger homeProIndex;
//
//@property (nonatomic,assign)NSInteger homeCityIndex;
@property (nonatomic,assign)NSInteger marryIndex;
@property (nonatomic,assign)NSInteger relationIndex;
@property (nonatomic,assign)NSInteger presiIndex;
//关系
@property (nonatomic,strong)NSArray * relationshipArr;
//信誉
@property (nonatomic,strong)NSArray * presiCountArr;
//婚姻
@property (nonatomic,strong)NSArray * marryArr;
//标记pickerView的数据源 1,2,3地址，4关系，5信誉分，6婚姻，7，8，9是籍贯,10生日
@property (nonatomic,assign)int flag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marryHeightCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
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
    self.userId = [DEFAULTS objectForKey:@"userId"];
    self.marryHeightCons.constant = 0;
    [self commonUI:YES];
    [self setUI];
}
-(void)commonUI:(BOOL)isHidden{
    self.wifeNameLabel.hidden = isHidden;
    self.wifeLabel.hidden = isHidden;
    self.childNameLabel.hidden = isHidden;
    self.childLabel.hidden = isHidden;
    self.childSchoolLabel.hidden = isHidden;
    self.childScLabel.hidden = isHidden;
    self.lineOneView.hidden = isHidden;
    if (isHidden) {
        self.viewHeightCons.constant = 1050;
    }else{
        self.viewHeightCons.constant = 1250;

    }
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
    [self.wifeNameTF resignFirstResponder];
    [self.childSchoolTF resignFirstResponder];
    [self.childNameTF resignFirstResponder];
    
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
//推荐
- (IBAction)recommendClick:(id)sender {
    [self resign];
    //提示必填项
    if (!self.manBtn.selected && !self.famaleBtn.selected) {
        return;
    }
    if (!self.danceBtn.selected && !self.musicBtn.selected&&!self.printBtn.selected && !self.intrusmentBtn.selected&&!self.gameBtn.selected && !self.movieBtn.selected&&!self.chessBtn.selected && !self.travelBtn.selected&&!self.foodBtn.selected && !self.chatBtn.selected&&!self.readBtn.selected && !self.motionBtn.selected) {
        return;
    }
    if (self.nameLabel.text.length == 0||self.phoneTF.text.length == 0 || self.liveProTF.text.length == 0||self.liveCityTF.text.length == 0||self.liveDisTF.text.length == 0 || self.relationshipTF.text.length == 0 || self.presiTF.text.length == 0) {
        return;
    }
    
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf recommendSubmit];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}
-(void)recommendSubmit{
    NSMutableDictionary * params = [NSMutableDictionary new];
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
    NSString * relation ;
    if ([self.relationshipTF.text isEqualToString:@"亲人"]) {
        relation = @"1";
    }else if ([self.relationshipTF.text isEqualToString:@"同乡"]){
        relation = @"4";

    }else if ([self.relationshipTF.text isEqualToString:@"校友"]){
        relation = @"3";
        
    }else if ([self.relationshipTF.text isEqualToString:@"同事"]){
        relation = @"2";
        
    }
    
    [params setValue:relation forKey:@"relationship"];
    
    [params setValue:self.schoolTF.text forKey:@"finishSchool"];
    [params setValue:self.presiTF.text forKey:@"creditScore"];
    
    [params setValue:self.birthday forKey:@"birthday"];
    [params setValue:[NSString stringWithFormat:@"%@,%@,%@",self.homeProTF.text,self.homeCityTF.text,self.homeDisTF.text] forKey:@"homeplace"];
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
    NSString * status;
    if ([self.marryTF.text isEqualToString:@"已婚"]) {
        status = @"1";
    }else{
        status = @"0";
    }
    [params setValue:status forKey:@"marriage"];
    
    [params setValue:self.companyTF.text forKey:@"company"];
    
    [params setValue:self.motherNameTF.text forKey:@"motherName"];
    
    [params setValue:self.wifeNameTF.text forKey:@"spouseName"];
    [params setValue:self.childNameTF.text forKey:@"childrenName"];
    [params setValue:self.childSchoolTF.text forKey:@"childrenSchool"];

    [params setValue:self.userId forKey:@"userId"];
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,RecommendURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"已推荐人请求失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //推荐码进入推荐码界面
                NSString * recomCode = [NSString stringWithFormat:@"%@",data[@"data"][@"recommendId"]];
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
                ProductCodeController * code = [sb instantiateViewControllerWithIdentifier:@"ProductCodeController"];
                code.code = recomCode;
                [weakSelf.navigationController pushViewController:code animated:YES];

                NSSLog(@"%@",recomCode);
            }else{
                NSSLog(@"推荐失败");
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
        [self.wifeNameTF becomeFirstResponder];
        
    }else if (textField == self.wifeNameTF){
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
    if (textField == self.companyTF||textField == self.schoolTF||textField == self.fatherNameTF||textField == self.motherNameTF){
        self.bottomView.hidden = YES;
        self.view.frame = CGRectMake(0, -offset, KMainScreenWidth, KMainScreenHeight);
        return YES;
        
    }else if (textField == self.wifeNameTF||textField == self.childNameTF||textField == self.childSchoolTF){
        self.bottomView.hidden = YES;
        CGFloat offset1 = self.marryView.frame.origin.y+textField.frame.origin.y+50-(KMainScreenHeight-216);
        self.view.frame = CGRectMake(0, -offset1, KMainScreenWidth, KMainScreenHeight);
        return YES;
        
    }
    else if (textField == self.liveProTF||textField == self.liveCityTF||textField == self.liveDisTF||textField == self.relationshipTF||textField == self.presiTF||textField == self.homeProTF||textField == self.homeCityTF||textField == self.homeDisTF||textField == self.marryTF){
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
            self.flag = 7;
            [self getAllData];
        }else if (textField == self.homeCityTF){
            if (self.homeProTF.text.length != 0) {
                [self hidden];
                self.flag = 8;
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
                self.flag = 9;
                for (NSDictionary *dict in self.allArr) {
                    
                    if ([dict objectForKey:self.provinceArr[self.proIndex]]) {
                        self.districtArr = [NSMutableArray arrayWithArray:[[dict objectForKey:self.provinceArr[self.proIndex]] objectForKey:self.cityArr[self.cityIndex]]];
                        break;
                    }
                }
            }
        }else if (textField == self.relationshipTF){
            [self hidden];
            self.flag = 4;
            self.relationshipArr = @[@"亲人",@"同事",@"校友",@"同乡"];
        }else if (textField == self.presiTF){
            [self hidden];
            self.flag = 5;
            //信誉分
            self.presiCountArr = @[@"0",@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100"];
        }else if (textField == self.marryTF){
            [self hidden];
            self.flag = 6;
            //婚姻
            self.marryArr = @[@"未婚",@"已婚"];
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
         //关系
            self.relationshipTF.text = self.relationshipArr[self.relationIndex];
            break;
        case 5:
            //信誉分
            self.presiTF.text = self.presiCountArr[self.presiIndex];
            break;
        case 6:
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
        case 7:
            self.homeProTF.text = self.provinceArr[self.proIndex];
            
            break;
        case 8:
            self.homeCityTF.text = self.cityArr[self.cityIndex];
            
            break;
        case 9:
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
            self.relationIndex = row;
        }
            break;
        case 5:
        {
            self.presiIndex = row;
        }
            break;
        case 6:
        {
            self.marryIndex = row;
        }
            break;
        case 7:
        {
            self.proIndex = row;
            self.cityIndex = 0;
            self.districtIndex = 0;
        }
            break;
        case 8:
        {
            self.cityIndex = row;
            self.districtIndex = 0;
        }
            break;
        default:
            self.districtIndex = row;

            break;
    }
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (self.flag) {
        case 1:
            return [self.provinceArr objectAtIndex:row];

            break;
        case 2:
            return [self.cityArr objectAtIndex:row];
            
            break;
        case 3:
            return [self.districtArr objectAtIndex:row];
            
            break;
        case 4:
            return [self.relationshipArr objectAtIndex:row];
            
            break;
        case 5:
            return [self.presiCountArr objectAtIndex:row];
            
            break;
        case 6:
            return [self.marryArr objectAtIndex:row];
            
            break;
        case 7:
            return [self.provinceArr objectAtIndex:row];
            
            break;
        case 8:
            return [self.cityArr objectAtIndex:row];
            
            break;
        default:
            return [self.districtArr objectAtIndex:row];

            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (self.flag) {
        case 1:
            return self.provinceArr.count;
            
            break;
        case 2:
            return self.cityArr.count;
            
            break;
        case 3:
            return self.districtArr.count;
            
            break;
        case 4:
            return self.relationshipArr.count;
            
            break;
        case 5:
            return self.presiCountArr.count;
            
            break;
        case 6:
            return self.marryArr.count;
            
            break;
        case 7:
            return self.provinceArr.count;
            
            break;
        case 8:
            return self.cityArr.count;
            
            break;
        default:
            return self.districtArr.count;
            
            break;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
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
