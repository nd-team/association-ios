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
        self.tbHeightContraints.constant = self.dataArr.count *195;
        [self.tableView reloadData];
    }
    if (self.recommendStr != 0) {
        self.contentLabel.text = self.recommendStr;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomView.hidden = YES;
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
    //dismiss系统的设置自定义
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    self.actImage.image = originalImage;
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ActImageCell"];
//    cell.headImageView.image = self.dataArr[indexPath.row];
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
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    ActivityRecommendController * recom = [sb instantiateViewControllerWithIdentifier:@"ActivityRecommendController"];
    recom.delegate = self;
    [self.navigationController pushViewController:recom animated:YES];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendClick:(id)sender {
//    if (self.area.length != 0 && self.personCount.length != 0 && self.content.length != 0 && self.titleTF.text.length != 0&&self.startTF.text.length != 0 && self.endTF.text.length != 0 && self.actImage.image != nil) {
//        [self postCreateActivity];
//    }else{
//        [self showMessage:@"请填写完整信息"];
//    }
 
}
-(void)postCreateActivity{
    //    NSString * nickname = [DEFAULTS objectForKey:@"nickname"];
    //    WeakSelf;
    //    NSDictionary * params = @{@"userId":self.userID,@"group_id":self.groupID,@"actives_title":self.titleLabel.text,@"actives_content":self.contentLabel.text,@"actives_limit":self.personTF.text,@"actives_start":self.startTF.text,@"actives_end":self.endTF.text,@"actives_address":self.areaTF.text};
    //    [UploadImageNet postDataWithUrl:CreateActURL andParams:params andImage:self.headImageView.image getBlock:^(NSURLResponse *response, NSError *error, id data) {
    //        if (error) {
    //            NSSLog(@"建活动失败%@",error);
    //            [weakSelf showMessage:@"创建活动失败"];
    //        }else{
    //            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //            NSNumber * code = jsonDic[@"code"];
    //            if ([code intValue] == 200) {
    //                NSDictionary * data = jsonDic[@"data"];
    //                //发送一条消息富文本
    //                RCRichContentMessage * richMsg = [RCRichContentMessage messageWithTitle:self.titleTF.text digest:self.contentLabel.text imageURL:[NSString stringWithFormat:@"https://al.bjike.com/%@",[NowDate changeUrl:data[@"avatar_image"]]]  extra:nil];
    //                [[RCIM sharedRCIM]sendMediaMessage:ConversationType_GROUP targetId:self.groupID content:richMsg pushContent:[NSString stringWithFormat:@"%@发起活动%@",nickname,self.titleTF.text] pushData:self.contentLabel.text progress:^(int progress, long messageId) {
    //
    //
    //                } success:^(long messageId) {
    //                    //发送消息成功
    //                    weakSelf.delegate.isRef = YES;
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //                        [weakSelf.navigationController popViewControllerAnimated:YES];
    //                    });
    //                } error:^(RCErrorCode errorCode, long messageId) {
    //                    //发送失败
    //                    [weakSelf showMessage:@"发送消息失败"];
    //
    //                } cancel:^(long messageId) {
    //                    //取消发送消息
    //                    [weakSelf showMessage:@"你取消了发送消息"];
    //
    //                }];
    //
    //            }else{
    //                [weakSelf showMessage:@"创建活动失败"];
    //            }
    //        }
    //    }];
    
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.widthContraints.constant = KMainScreenWidth+5;
}
@end
