//
//  ApplicationFormController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/4.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ApplicationFormController.h"
#import "CarCityCell.h"
#import "SearchCityController.h"
#import "CarShapeController.h"
#import "UploadImageNet.h"

#define DriverURL @"appapi/app/driverRegister"
@interface ApplicationFormController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *carCityTF;
@property (weak, nonatomic) IBOutlet UITextField *carNumTF;

@property (weak, nonatomic) IBOutlet UITextField *driverTF;

@property (weak, nonatomic) IBOutlet UITextField *registerDateTF;

@property (weak, nonatomic) IBOutlet UITextField *driverNameTF;

@property (weak, nonatomic) IBOutlet UITextField *cardTF;
@property (weak, nonatomic) IBOutlet UITextField *driverDateTF;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (weak, nonatomic) IBOutlet UIView *timeView;
//区分车辆注册日期和领取日期
@property (nonatomic,assign)BOOL isFirst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *carShapeLabel;
@property (nonatomic,strong)UIWindow * window;
@property (weak, nonatomic) IBOutlet UIImageView *licenseImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (nonatomic,assign)BOOL isUpload;


@end

@implementation ApplicationFormController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];

    if (![ImageUrl isEmptyStr:self.cityStr]) {
        self.cityLabel.text = self.cityStr;
    }
    if (![ImageUrl isEmptyStr:self.shapeStr]) {
        self.carShapeLabel.text = self.shapeStr;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self tableHidden:YES];
    [self timeViewHidden:YES];
//    [self.window addSubview:self.timeView];
    self.timeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    //datePicker的字体颜色和线条颜色
    [self.datePicker setValue:UIColorFromRGB(0x333333) forKey:@"textColor"];
    [self.datePicker setValue:UIColorFromRGB(0xdcdcdc) forKey:@"textShadowColor"];

    for (UIView * view in self.datePicker.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            for (UIView * subView in view.subviews) {
//                NSSLog(@"%f",subView.frame.size.height);
                if (subView.frame.size.height == 0.5) {
                    subView.backgroundColor = UIColorFromRGB(0x10db9f);
                }
            }
        }
    }
    self.carCityTF.layer.borderColor = UIColorFromRGB(0xECEEF0).CGColor;
    self.carCityTF.layer.borderWidth = 1;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBoard)];
    [self.view addGestureRecognizer:tap];
}
-(void)hideBoard{
    [self.carNumTF resignFirstResponder];
    [self.driverNameTF resignFirstResponder];
    [self.driverTF resignFirstResponder];
    [self.cardTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CarCityCell"];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xffeca9);
    cell.nameLabel.text = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.carCityTF.text = [NSString stringWithFormat:@"  %@",self.dataArr[indexPath.row]];
    self.tableView.hidden = YES;
}

-(void)tableHidden:(BOOL)isHidden{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.hidden = isHidden;
    });
}
-(void)timeViewHidden:(BOOL)isHidden{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timeView.hidden = isHidden;
    });
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.carNumTF) {
        [self.carNumTF resignFirstResponder];
    }else if (textField == self.driverTF){
        [self.driverTF resignFirstResponder];
    }else if (textField == self.driverNameTF){
        [self.driverNameTF resignFirstResponder];
    }else if (textField == self.cardTF){
        [self.cardTF resignFirstResponder];
    }else if (textField == self.phoneTF){
        [self.phoneTF resignFirstResponder];
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.carCityTF || textField == self.registerDateTF || textField == self.driverDateTF) {
        [self hideBoard];
        if (textField == self.registerDateTF) {
            self.isFirst = YES;
            [self timeViewHidden:NO];
        }else if (textField == self.driverDateTF) {
            self.isFirst = NO;
            [self timeViewHidden:NO];
        }else if (textField == self.carCityTF){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            });
        }
        return NO;
    }else{
        return YES;
    }
}

- (IBAction)finishClick:(id)sender {
    if ([self checkLayal]) {
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf submit];
        });

    }
}
-(void)submit{
    NSMutableDictionary * params = [NSMutableDictionary new];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:self.cityLabel.text forKey:@"city"];
    [params setValue:self.carNumTF.text forKey:@"licensePlate"];
    [params setValue:self.carShapeLabel.text forKey:@"carModels"];
    [params setValue:self.driverTF.text forKey:@"carUser"];
    [params setValue:self.registerDateTF.text forKey:@"registerTime"];
    [params setValue:self.driverNameTF.text forKey:@"fullName"];
    [params setValue:self.phoneTF.text forKey:@"mobile"];
    [params setValue:self.cardTF.text forKey:@"idcard"];
    [params setValue:self.driverDateTF.text forKey:@"firstDate"];
    WeakSelf;
    [UploadImageNet postDataWithUrl:[NSString stringWithFormat:NetURL,DriverURL] andParams:params andImage:self.licenseImageView.image getBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"修改个人信息失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [weakSelf showMessage:@"提交信息成功，等待审核"];
            }else if ([code intValue] == 1015){
                [weakSelf showMessage:@"提交失败，请上传驾驶照"];
            }else{
                [weakSelf showMessage:@"提交失败，请重新提交"];
            }
        }
    }];
}
-(BOOL)checkLayal{
    BOOL a = YES;
    if ([ImageUrl isEmptyStr:self.cityLabel.text]) {
        a = NO;
        [self showMessage:@"请选择您的城市！"];
    }else if ([ImageUrl isEmptyStr:self.carNumTF.text]){
        a = NO;
        [self showMessage:@"请填写您的车牌号！"];
    }else if ([ImageUrl isEmptyStr:self.carShapeLabel.text]){
        a = NO;
        [self showMessage:@"请选择您的车型！"];
    }else if ([ImageUrl isEmptyStr:self.driverTF.text]){
        a = NO;
        [self showMessage:@"请填写您的车主姓名！"];
    }else if ([ImageUrl isEmptyStr:self.registerDateTF.text]){
        a = NO;
        [self showMessage:@"请选择您的车辆注册日期！"];
    }else if ([ImageUrl isEmptyStr:self.driverNameTF.text]){
        a = NO;
        [self showMessage:@"请填写您的司机姓名！"];
    }else if ([ImageUrl isEmptyStr:self.phoneTF.text]){
        a = NO;
        [self showMessage:@"请填写您的司机手机号码！"];
    }else if ([ImageUrl isEmptyStr:self.driverDateTF.text]){
        a = NO;
        [self showMessage:@"请选择您的领取驾照日期！"];
    }else if ([ImageUrl isEmptyStr:self.cardTF.text]){
        a = NO;
        [self showMessage:@"请填写您的身份证号码！"];
    }else if (!self.isUpload){
        a = NO;
        [self showMessage:@"请上传您的驾驶证照片！"];
    }
    return a;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}

- (IBAction)cancelClick:(id)sender {
    [self timeViewHidden:YES];

}
- (IBAction)sureClick:(id)sender {
    [self timeViewHidden:YES];
    [self time];

}
- (IBAction)datePickerClick:(id)sender {
    
    [self time];
}
-(void)time{
    NSString * time = [NowDate getTime:self.datePicker.date];
    if (self.isFirst) {
        self.registerDateTF.text = time;
    }else{
        self.driverDateTF.text = time;
    }
}
- (IBAction)uploadImageClick:(id)sender {
    [self hideBoard];
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
    self.licenseImageView.image = originalImage;
    self.isUpload = YES;
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PushCitySearch"]) {
        SearchCityController * search = segue.destinationViewController;
        search.delegate = self;
    }else if ([segue.identifier isEqualToString:@"ChooseShapePush"]){
        CarShapeController * shape = segue.destinationViewController;
        shape.delegate = self;
    }
}


-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
        [_dataArr addObjectsFromArray:@[@"京",@"沪",@"津",@"渝",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"宁",@"青",@"新"]];
    }
    return _dataArr;
}
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}
@end
