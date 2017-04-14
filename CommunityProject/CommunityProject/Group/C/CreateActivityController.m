//
//  CreateActivityController.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CreateActivityController.h"
#import "NameViewController.h"
#import "MyLocationViewController.h"
#import "ActImageCell.h"
#import "ActivityRecommendController.h"
#import "UploadActImageNet.h"

#define CreateActivityURL @"appapi/app/foundActives"
@interface CreateActivityController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *actImage;

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *startTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *endTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *endTF;
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
@property (weak, nonatomic) IBOutlet UITextField *limitTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImage;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbHeightContraints;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,assign)int time;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,strong)NSMutableArray * actArr;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recomHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;

@end

@implementation CreateActivityController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.name != nil) {
        self.titleLabel.text = self.name;
    }
    if (self.limitPeople != nil) {
        self.limitTF.text = self.limitPeople;
    }
    if (self.area != nil) {
        self.areaTF.text = self.area;
    }
    if (self.dataArr.count != 0) {
        self.tbTopCons.constant = 14;
        self.tbHeightContraints.constant = self.dataArr.count *205;
        [self.tableView reloadData];
    }
    if (self.recommendStr != 0) {
        self.conTopCons.constant = 10;
        self.contentLabel.text = self.recommendStr;
        CGSize size = [self.contentLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        if (self.dataArr.count != 0) {
            self.recomHeightCons.constant = 69+self.tbHeightContraints.constant+size.height;
        }else{
            self.recomHeightCons.constant = 69+size.height;
        }
        self.moreImage.hidden = NO;
        self.moreLabel.hidden = YES;
    }
    self.heightCons.constant = 578+self.recomHeightCons.constant;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}
-(void)setUI{
    self.bottomView.hidden = YES;
    self.moreImage.hidden = YES;
    self.tbHeightContraints.constant = 0;
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushAlbums)];
    [self.actImage addGestureRecognizer:tap1];
}

-(void)pushAlbums{
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.changeLabel.hidden = YES;
    //dismiss系统的设置自定义
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    UploadImageModel * item = [UploadImageModel new];
    item.image = originalImage;
    item.isPlaceHolder = NO;
    item.isHide = YES;
    [self.actArr addObject:item];
    self.actImage.image = originalImage;
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ActImageCell"];
    cell.uploadModel = self.dataArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.titleLabel) {
        [self setName:@"活动名称" andType:4 andPlace:@"设置活动名称"];
    }else if (textField == self.limitTF){
        [self setName:@"限制人数" andType:5 andPlace:@"设置人数"];
    }else if (textField == self.startTimeLabel){
        self.bottomView.hidden = NO;
        self.time = 1;
    }else if (textField == self.endTF){
        self.bottomView.hidden = NO;
        self.time = 3;

    }else if (textField == self.endTimeLabel){
        self.bottomView.hidden = NO;
        self.time = 2;

    }else if (textField == self.areaTF){
        MyLocationViewController * location = [MyLocationViewController new];
        location.actDelegate = self;
        location.isAct = YES;
        [self.navigationController pushViewController:location animated:YES];
    }
    return NO;
}
-(void)setName:(NSString *)name andType:(int)type andPlace:(NSString *)place{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    NameViewController * nameVC = [sb instantiateViewControllerWithIdentifier:@"NameViewController"];
    nameVC.name = name;
    nameVC.titleCount = type;
    nameVC.placeHolder = place;
    nameVC.createDelegate = self;
    nameVC.rightStr = @"保存";
    [self.navigationController pushViewController:nameVC animated:YES];

}
- (IBAction)finishClick:(id)sender {
    if (self.time == 1) {
        self.startTimeLabel.text = [NowDate getDetailTime:self.datePicker.date];
    }else if (self.time == 2){
        self.endTimeLabel.text = [NowDate getDetailTime:self.datePicker.date];
    }else{
        self.endTF.text = [NowDate getDetailTime:self.datePicker.date];
    }
    self.bottomView.hidden = YES;
}

- (IBAction)moreClick:(id)sender {
    [self.dataArr removeAllObjects];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    ActivityRecommendController * recom = [sb instantiateViewControllerWithIdentifier:@"ActivityRecommendController"];
    recom.delegate = self;
    [self.navigationController pushViewController:recom animated:YES];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendClick:(id)sender {
    if (self.area.length != 0 && self.limitPeople.length != 0 && self.name.length != 0 && self.recommendStr.length != 0&&self.startTimeLabel.text.length != 0 && self.endTF.text.length != 0 && self.actImage.image != nil&& self.endTimeLabel.text.length != 0) {
        [self postCreateActivity];
    }else{
        return;
//        [self showMessage:@"请填写完整信息"];
    }
 
}
-(void)postCreateActivity{
        NSString * nickname = [DEFAULTS objectForKey:@"nickname"];
        WeakSelf;
        NSDictionary * params = @{@"userId":self.userID,@"groupId":self.groupID,@"activesTitle":self.titleLabel.text,@"activesContent":self.recommendStr,@"activesLimit":self.limitTF.text,@"activesStart":self.startTimeLabel.text,@"activesEnd":self.endTimeLabel.text,@"activesAddress":self.areaTF.text,@"activesClosing":self.endTF.text};
    [self.actArr addObjectsFromArray:self.dataArr];
    [UploadActImageNet postDataWithUrl:[NSString stringWithFormat:NetURL,CreateActivityURL] andParams:params andArray:self.dataArr getBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"建活动失败%@",error);
//            [weakSelf showMessage:@"创建活动失败"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                NSSLog(@"%@",dict);
                [weakSelf back];
                //发送一条消息富文本
                RCRichContentMessage * richMsg = [RCRichContentMessage messageWithTitle:self.titleLabel.text digest:self.contentLabel.text imageURL:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"activesImage"]]]  extra:nil];
                [[RCIM sharedRCIM]sendMediaMessage:ConversationType_GROUP targetId:self.groupID content:richMsg pushContent:[NSString stringWithFormat:@"%@发起活动%@",nickname,self.titleLabel.text] pushData:self.contentLabel.text progress:^(int progress, long messageId) {
                    //风火轮加载
                    
                    
                } success:^(long messageId) {
                    //发送消息成功
                    
                } error:^(RCErrorCode errorCode, long messageId) {
                    //发送失败
//                    [weakSelf showMessage:@"发送消息失败"];

                } cancel:^(long messageId) {
                    //取消发送消息
//                    [weakSelf showMessage:@"你取消了发送消息"];
                    
                }];
                
            }else{
//                [weakSelf showMessage:@"创建活动失败"];
            }
        }

    }];

}
-(void)back{
    WeakSelf;
    self.delegate.isRef = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)actArr{
    if (!_actArr) {
        _actArr = [NSMutableArray new];
    }
    return _actArr;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.widthContraints.constant = KMainScreenWidth+5;
}
@end
