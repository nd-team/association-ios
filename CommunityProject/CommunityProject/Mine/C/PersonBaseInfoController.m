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
@property (weak, nonatomic) IBOutlet UITextField *birthTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@property (weak, nonatomic) IBOutlet UILabel *lingLabel;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
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
//标记tableview的数据源
@property (nonatomic,assign)int flag;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

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
//    [self getAllData];
}
//初始化传参过来的数据
-(void)setUI{
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
    self.preLeftWidthCons.constant = [self.prestigeCount integerValue];
    self.preRightWidthCons.constant = 138-[self.prestigeCount integerValue]+4;
    self.conLeftWidthCons.constant = [self.expCount integerValue];
    self.conRightWidthCons.constant = 138-[self.expCount integerValue]+4;
    self.flag = 1;
    self.preLeftCons.constant = self.preLeftWidthCons.constant-4;
    self.expLeftCons.constant = self.conLeftWidthCons.constant-4;
    [self.sexNoBtn setBackgroundImage:[UIImage imageNamed:@"noSelBtn"] forState:UIControlStateNormal];
    [self.sexYesBtn setBackgroundImage:[UIImage imageNamed:@"noSelBtn"] forState:UIControlStateNormal];
    [self.sexNoBtn setBackgroundImage:[UIImage imageNamed:@"chooseSel"] forState:UIControlStateSelected];
    [self.sexYesBtn setBackgroundImage:[UIImage imageNamed:@"chooseSel"] forState:UIControlStateSelected];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userPortraitUrl]];
    self.contributeCountLabel.text = self.contributeCount;
    self.prestigeCountLabel.text = self.prestigeCount;
    self.experienceCountLabel.text = self.expCount;
    self.nicknameLabel.text = self.nickname;
    self.userLabel.text = self.userId;
    self.phoneTF.text = self.mobile;
    if (self.sex == 1) {
        self.sexYesBtn.selected = YES;
    }else{
        self.sexNoBtn.selected = YES;
    }
    
    self.recommendLabel.text = self.recommendStr;
    self.lingLabel.text = self.lingStr;
    self.birthTF.text = self.birthday;
    self.ageTF.text = self.ageStr;
    self.emailTF.text = self.email;
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    if ([self.pickerView.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.pickerView.delegate pickerView:self.pickerView didSelectRow:0 inComponent:0];
    }

//    NSSLog(@"%@",self.address);
    //手势回收键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    [self.view addGestureRecognizer:tap];
}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)saveInfo{
    [self resign];
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf submitData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    }
-(void)submitData{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userId"];
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setValue:self.nicknameLabel.text forKey:@"nickname"];
    [params setValue:userID forKey:@"userId"];
    NSString * status = [NSString stringWithFormat:@"%ld",self.sexInt];
    [params setValue:status forKey:@"sex"];
    [params setValue:self.emailTF.text forKey:@"email"];
    [params setValue:self.phoneTF.text forKey:@"mobile"];
    NSString *address = [NSString stringWithFormat:@"%@%@%@",self.provinceTF.text,self.cityTF.text,self.countryTF.text];
    [params setValue:address forKey:@"address"];
    [params setValue:self.birthday forKey:@"birthDate"];
    [params setValue:self.ageTF.text forKey:@"age"];
    NSSLog(@"%@",self.birthday);
    WeakSelf;
    [UploadImageNet postDataWithUrl:[NSString stringWithFormat:NetURL,SaveInfoURL] andParams:params andImage:self.headImage getBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"修改个人信息失败:%@",error);
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
                [DEFAULTS setValue:weakSelf.phoneTF.text forKey:@"mobile"];
                [DEFAULTS setInteger:[weakSelf.ageTF.text integerValue]  forKey:@"age"];
                [DEFAULTS setValue:weakSelf.birthday forKey:@"birthday"];
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
                NSSLog(@"修改个人信息失败");
            }
        }
    }];
 
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nicknameLabel) {
        [self.nicknameLabel resignFirstResponder];
        [self.phoneTF becomeFirstResponder];
    }else if (textField == self.phoneTF){
        [self.phoneTF resignFirstResponder];
        [self.ageTF becomeFirstResponder];
    }else if (textField == self.ageTF){
        [self.ageTF resignFirstResponder];
        [self.emailTF becomeFirstResponder];
    }else{
        [self resign];
    }
    return YES;
}
-(void)resign{
    [self.nicknameLabel resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.ageTF resignFirstResponder];
    [self.emailTF resignFirstResponder];
}
- (IBAction)moreClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    PersonMoreInfoController * person = [sb instantiateViewControllerWithIdentifier:@"PersonMoreInfoController"];
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
    //获取tableview滑动到哪行
    if (self.flag == 1) {
        self.provinceTF.text = self.provinceArr[self.proIndex];
    }else if (self.flag == 2){
        self.cityTF.text = self.cityArr[self.cityIndex];

    }else if (self.flag == 3){
        self.countryTF.text = self.districtArr[self.districtIndex];

    }else{
        [self common];
    }
    self.bottomView.hidden = YES;

}

- (IBAction)datePickerClick:(id)sender {

    [self common];
}
-(void)common{
    NSString * time = [NowDate getTime:self.datePicker.date];
    NSArray * arr = [time componentsSeparatedByString:@"-"];
    self.birthTF.text = [NSString stringWithFormat:@"%@年%@月%@日",arr[0],arr[1],arr[2]];
    self.birthday = time;
}
-(void)getAllData{
    self.allArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
    for (NSDictionary *dci in self.allArr) {
        [self.provinceArr addObject:[[dci allKeys] firstObject]];
    }
    [self.pickerView reloadComponent:0];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.birthTF) {
        self.bottomView.hidden = NO;
        self.pickerView.hidden = YES;
        self.datePicker.hidden = NO;
        self.flag = 4;
        return NO;
    }else if (textField == self.provinceTF||textField == self.cityTF || textField == self.countryTF){
        self.bottomView.hidden = NO;
        self.datePicker.hidden = YES;
        self.pickerView.hidden = NO;
        if (textField == self.provinceTF) {
            self.flag = 1;
            [self getAllData];
        }else if (textField == self.cityTF){
            if (self.allArr.count != 0) {
                
                self.flag = 2;
                for (NSDictionary *dict in self.allArr) {
                    
                    if ([dict objectForKey:self.provinceArr[self.proIndex]]) {
                        self.cityArr = [NSMutableArray arrayWithArray:[[dict objectForKey:self.provinceArr[self.proIndex]] allKeys]];
                        break;
                    }
                }
                [self.pickerView reloadComponent:0];
                [self.pickerView selectRow:0 inComponent:0 animated:YES];
            }
        }else{
            if (self.provinceArr.count != 0) {
                self.flag = 3;
                for (NSDictionary *dict in self.allArr) {
                    
                    if ([dict objectForKey:self.provinceArr[self.proIndex]]) {
                        self.districtArr = [NSMutableArray arrayWithArray:[[dict objectForKey:self.provinceArr[self.proIndex]] objectForKey:self.cityArr[self.cityIndex]]];
                        
                    }
                }
                
                [self.pickerView reloadComponent:0];
                [self.pickerView selectRow:0 inComponent:0 animated:YES];

            }
        }
        return NO;
    }else{
        return YES;
    }
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
    
    return 50;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //改变选择时的颜色
    UILabel * label = (UILabel *)[pickerView viewForRow:row forComponent:0];
    label.backgroundColor = [UIColor whiteColor];
    if (self.flag == 1) {
        self.proIndex = row;
        self.cityIndex = 0;
        self.districtIndex = 0;
    }
    
   else if (self.flag == 2) {
        self.cityIndex = row;
       self.districtIndex = 0;
       
    }
    
   else {
        self.districtIndex = row;
    }
    
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.flag == 1) {
        return [self.provinceArr objectAtIndex:row];
    }else if (self.flag == 2){
        return [self.cityArr objectAtIndex:row];
    }else if (self.flag == 3){
        return [self.districtArr objectAtIndex:row];
    }
    
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.flag == 1) {
        return self.provinceArr.count;
    }else if (self.flag == 2){
        return self.cityArr.count;
    }else if (self.flag == 3){
        return self.districtArr.count;
    }
    
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth+5;
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
