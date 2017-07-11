//
//  PersonBaseInfoController.m
//  CommunityProject
//
//  Created by bjike on 17/4/26.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PersonBaseInfoController.h"
#import "UploadImageNet.h"
#import "PersonMoreInfoController.h"

#define SaveInfoURL @"appapi/app/editUserInfo"
@interface PersonBaseInfoController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *prestigeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *contributeCountLabel;
@property (weak, nonatomic) IBOutlet UIView *presLeftView;
@property (weak, nonatomic) IBOutlet UIView *preRightView;

@property (weak, nonatomic) IBOutlet UIView *conRightView;
@property (weak, nonatomic) IBOutlet UITextField *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sexYesBtn;

@property (weak, nonatomic) IBOutlet UIButton *sexNoBtn;

@property (weak, nonatomic) IBOutlet UIView *conLeftView;

@property (weak, nonatomic) IBOutlet UITextField *provinceTF;

@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *countryTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@property (weak, nonatomic) IBOutlet UILabel *lingLabel;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preRightWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preLeftWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conRightWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conLeftWidthCons;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,strong)UIImage *headImage;
@property (nonatomic,assign)NSInteger sexInt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expLeftCons;
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
//标记pickerView的数据源1,2,3地址
@property (nonatomic,assign)int flag;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
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
//计数 爱好选中3项 第四次的时候提示用户 并且不能选中
@property (nonatomic,assign)NSInteger count;
//提示框
@property (nonatomic,strong)UIView * msgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation PersonBaseInfoController
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
    [self setUI];
}
//初始化传参过来的数据
-(void)setUI{
    self.count = 0;
    self.bottomView.hidden = YES;
    self.headImageView.layer.cornerRadius = 40;
    self.headImageView.layer.masksToBounds = YES;
    self.presLeftView.layer.cornerRadius = 5;
    self.preRightView.layer.cornerRadius = 5;
    self.conLeftView.layer.cornerRadius = 5;
    self.conRightView.layer.cornerRadius = 5;
    self.provinceTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.cityTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.countryTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.provinceTF.layer.borderWidth = 1;
    self.cityTF.layer.borderWidth = 1;
    self.countryTF.layer.borderWidth = 1;
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
    //总值暂定300 宽138
    self.flag = 1;
    NSInteger preCount = [self.prestigeCount integerValue];
    NSInteger expCount = [self.expCount integerValue];
    float a = (float)(preCount+4)/300;
    float b = (float)(expCount+4)/300;
    self.preRightWidthCons.constant = (1-a)*138;
    self.preLeftWidthCons.constant = a*138;
    self.conLeftWidthCons.constant = b*138;
    self.conRightWidthCons.constant = (1-b)*138;
    self.preLeftCons.constant = self.preLeftWidthCons.constant+5;
    self.expLeftCons.constant = self.conLeftWidthCons.constant+5;

    [self.sexNoBtn setBackgroundImage:[UIImage imageNamed:@"noSelBtn"] forState:UIControlStateNormal];
    [self.sexYesBtn setBackgroundImage:[UIImage imageNamed:@"noSelBtn"] forState:UIControlStateNormal];
    [self.sexNoBtn setBackgroundImage:[UIImage imageNamed:@"chooseSel"] forState:UIControlStateSelected];
    [self.sexYesBtn setBackgroundImage:[UIImage imageNamed:@"chooseSel"] forState:UIControlStateSelected];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userPortraitUrl]];
    self.contributeCountLabel.text = self.contributeCount;
    self.nicknameLabel.text = self.nickname;
    self.userLabel.text = self.userId;
    if (self.sex == 1) {
        self.sexYesBtn.selected = YES;
    }else{
        self.sexNoBtn.selected = YES;
    }
    
    self.recommendLabel.text = self.recommendStr;
    self.lingLabel.text = self.lingStr;
    self.emailTF.text = self.email;
    //爱好
    
     NSString * hobby = [DEFAULTS objectForKey:@"favour"];
    NSSLog(@"%@",hobby);
    if ([hobby containsString:@"舞蹈"]) {
        self.danceBtn.selected = YES;
        self.count++;
    }
    if ([hobby containsString:@"音乐"]){
        self.musicBtn.selected = YES;
        self.count++;
    }
    if ([hobby containsString:@"画画"]){
        self.printBtn.selected = YES;
        self.count++;
    }
    if ([hobby containsString:@"乐器"]){
        self.intrusmentBtn.selected = YES;
        self.count++;
        
    }
    if ([hobby containsString:@"游戏"]){
        self.gameBtn.selected = YES;
        self.count++;
        
    }
    if ([hobby containsString:@"影视"]){
        self.movieBtn.selected = YES;
        self.count++;
        
    }
    if ([hobby containsString:@"旅行"]){
        self.travelBtn.selected = YES;
        self.count++;
        
    }
    if ([hobby containsString:@"棋类"]){
        self.chessBtn.selected = YES;
        self.count++;
        
    }
    if ([hobby containsString:@"美食"]){
        self.foodBtn.selected = YES;
        self.count++;
        
    }
    if ([hobby containsString:@"社交"]){
        self.chatBtn.selected = YES;
        self.count++;
        
    }
    if ([hobby containsString:@"阅读"]){
        self.readBtn.selected = YES;
        self.count++;
        
    }
    if ([hobby containsString:@"运动"]){
        self.motionBtn.selected = YES;
        self.count++;
        
    }
//    NSSLog(@"%@",self.address);
    //手势回收键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    [self.view addGestureRecognizer:tap];
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
-(void)saveInfo{
    //昵称长度超过12提示用户
    int length = [ImageUrl convertToInt:self.nicknameLabel.text];
    if (length > 12) {
        //请输入少于7个中文的昵称
        [self showMessage:@"亲，昵称不可输入超过6个中文哦！"];
        return;
    }
    [self resign];
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf submitData];
    });
    }
-(void)submitData{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userId"];
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setValue:self.nicknameLabel.text forKey:@"nickname"];
    [params setValue:userID forKey:@"userId"];
    NSString * status = [NSString stringWithFormat:@"%ld",(long)self.sexInt];
    [params setValue:status forKey:@"sex"];
    [params setValue:self.emailTF.text forKey:@"email"];
    NSString *address = [NSString stringWithFormat:@"%@%@%@",self.provinceTF.text,self.cityTF.text,self.countryTF.text];
    [params setValue:address forKey:@"address"];
    //爱好
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
    
    [params setValue:hobby forKey:@"favour"];
    WeakSelf;
    [UploadImageNet postDataWithUrl:[NSString stringWithFormat:NetURL,SaveInfoURL] andParams:params andImage:self.headImage getBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"修改个人信息失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                RCUserInfo * userInfo = [RCIM sharedRCIM].currentUserInfo;
                //重新保存数据
                if (weakSelf.headImage != nil) {
                    NSString * head = [ImageUrl changeUrl:dict[@"userPortraitUrl"]];
                    NSString * url = [NSString stringWithFormat:NetURL,head];
                    [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:url]];
                    userInfo.portraitUri = url;
                    [userDefaults setValue:url forKey:@"userPortraitUrl"];
                    [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:[RCIM sharedRCIM].currentUserInfo.userId];
                    
                }
                [DEFAULTS setValue:weakSelf.emailTF.text forKey:@"email"];
                [DEFAULTS setValue:[NSString stringWithFormat:@"%@%@%@",weakSelf.provinceTF.text,weakSelf.cityTF.text,weakSelf.countryTF.text] forKey:@"address"];
                [DEFAULTS setInteger:weakSelf.sexInt forKey:@"sex"];
                
                if (![weakSelf.nickname isEqualToString:weakSelf.nicknameLabel.text]){
                    [userDefaults setValue:self.nicknameLabel.text forKey:@"nickname"];
                    [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:[RCIM sharedRCIM].currentUserInfo.userId];
                }
                [userDefaults synchronize];
                weakSelf.delegete.isRef = YES;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showMessage:@"修改个人信息失败"];

            }
        }
    }];
 
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nicknameLabel) {
        [self.nicknameLabel resignFirstResponder];
        [self.emailTF becomeFirstResponder];
    }else{
        [self resign];
    }
    return YES;
}
-(void)resign{
    [self.nicknameLabel resignFirstResponder];
    [self.emailTF resignFirstResponder];
}
- (IBAction)moreClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    PersonMoreInfoController * person = [sb instantiateViewControllerWithIdentifier:@"PersonMoreInfoController"];
    person.isCurrent = YES;
    person.name = @"个人信息";
    [self.navigationController pushViewController:person animated:YES];
    
}
- (IBAction)yesClick:(id)sender {
    self.sexYesBtn.selected = !self.sexYesBtn.selected;
    if (self.sexYesBtn.selected) {
        self.sexNoBtn.selected = NO;
        self.sexInt = 1;
    }
}

- (IBAction)noClick:(id)sender {
    self.sexNoBtn.selected = !self.sexNoBtn.selected;
    if (self.sexNoBtn.selected) {
        self.sexYesBtn.selected = NO;
        self.sexInt = 2;
    }
    
}

- (IBAction)changeHeadImageClick:(id)sender {
    [self pushAlbums];
}
-(void)pushAlbums{
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //dismiss系统的设置自定义
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    self.headImageView.image = originalImage;
    self.headImage = originalImage;
}

- (IBAction)finishClick:(id)sender {
    switch (self.flag) {
        case 1:
            self.provinceTF.text = self.provinceArr[self.proIndex];
            
            break;
        case 2:
            self.cityTF.text = self.cityArr[self.cityIndex];
            
            break;
        default :
            self.countryTF.text = self.districtArr[self.districtIndex];
            
            break;
    }
    self.bottomView.hidden = YES;
}
-(void)getAllData{
    self.allArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
    for (NSDictionary *dci in self.allArr) {
        [self.provinceArr addObject:[[dci allKeys] firstObject]];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.provinceTF||textField == self.cityTF || textField == self.countryTF){
        [self resign];
        if (textField == self.provinceTF) {
            [self hidden];
            self.flag = 1;
            [self getAllData];
        }else if (textField == self.cityTF){
            if (self.provinceTF.text.length != 0) {
                [self hidden];
                self.flag = 2;
                for (NSDictionary *dict in self.allArr) {
                    
                    if ([dict objectForKey:self.provinceArr[self.proIndex]]) {
                        self.cityArr = [NSMutableArray arrayWithArray:[[dict objectForKey:self.provinceArr[self.proIndex]] allKeys]];
                        break;
                    }
                }
            }
        }else if(textField == self.countryTF){
            if (self.cityTF.text.length != 0) {
                [self hidden];
                self.flag = 3;
                for (NSDictionary *dict in self.allArr) {
                    
                    if ([dict objectForKey:self.provinceArr[self.proIndex]]) {
                        self.districtArr = [NSMutableArray arrayWithArray:[[dict objectForKey:self.provinceArr[self.proIndex]] objectForKey:self.cityArr[self.cityIndex]]];
                        
                    }
                }
            }
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
-(void)hidden{
    self.bottomView.hidden = NO;
    self.datePicker.hidden = YES;
    self.pickerView.hidden = NO;
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
        default:
        {
            self.districtIndex = row;
        }
            break;
    }
    
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (self.flag) {
        case 1:
            return [self.provinceArr objectAtIndex:row];
            
        case 2:
            return [self.cityArr objectAtIndex:row];
            
        default:
            return [self.districtArr objectAtIndex:row];
            
        }

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (self.flag) {
        case 1:
            return self.provinceArr.count;
            
        case 2:
            return self.cityArr.count;
            
        default:
            return self.districtArr.count;
            
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
- (IBAction)danceClick:(id)sender {
    [self hobbyAction:self.danceBtn];
    
}
-(void)hobbyAction:(UIButton *)btn{
    if (self.count>2) {
        if(btn.selected){
            self.count--;
            btn.selected = !btn.selected;
        }else{
            //提示用户不可点击
            [self showMessage:@"爱好最多选择3项哦！"];
        }
    }else{
        btn.selected = !btn.selected;
        if(btn.selected){
            self.count++;
        }else{
            self.count--;
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
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
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
