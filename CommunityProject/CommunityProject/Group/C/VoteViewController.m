//
//  VoteViewController.m
//  LoveChatProject
//
//  Created by bjike on 17/3/6.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "VoteViewController.h"
#import "VoteCell.h"
#import "VoteTypeController.h"
#import "UploadImageNet.h"

#define CreateVoteURL @"appapi/app/foundVote"
@interface VoteViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *titleTV;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;

@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
//保存选项内容
@property (nonatomic,strong)NSMutableArray * chooseArr;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickier;
//table的个数
@property (nonatomic,assign)int count;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (nonatomic,copy)NSString * userId;

@end

@implementation VoteViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    if (self.chooseType.length != 0) {
        self.chooseLabel.text = self.chooseType;
    }else{
        self.chooseLabel.text = @"单选";
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    
}
-(void)setUI{
    //默认3个数据
    self.count = 3;
    self.navigationItem.title = @"新建投票";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    //导航栏按钮 创建群组
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 40) titleColor:UIColorFromRGB(0x121212) font:14 andTitle:@"发 布" andLeft:15 andTarget:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.endTimeLabel.text = [NowDate currentDetailTime];
    self.timeView.hidden = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];
    [self.tableView setEditing:YES animated:YES];
    self.tableView.editing = YES;
    if (self.titleTV.text.length == 0) {
        self.placeLabel.hidden = NO;
    }else{
        self.placeLabel.hidden = YES;
    }
}
-(void)leftClick{
    [DEFAULTS removeObjectForKey:@"indexPath"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tapClick{
    [self.titleTV resignFirstResponder];
    self.timeView.hidden = YES;
}
-(void)rightClick{
    NSSLog(@"%@",self.chooseArr);
    if (self.titleTV.text.length == 0) {
        [self showMessage:@"请输入投票标题"];
        return;
    }
    if (self.chooseArr.count == 0) {
        [self showMessage:@"请输入投票选项"];
        return;
    }
    NSString * type ;
    if ([self.chooseLabel.text isEqualToString:@"单选"]) {
        type = @"0";
    }else{
        type = @"1";
    }
    WeakSelf;
    NSString * nickname = [DEFAULTS objectForKey:@"nickname"];
    NSData * data = [NSJSONSerialization dataWithJSONObject:self.chooseArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary * param = @{@"groupId":self.groupID,@"userId":self.userId,@"voteTitle":self.titleTV.text,@"mode":type,@"endTime":self.endTimeLabel.text,@"voteOption":str};
    NSSLog(@"%@==%@",param,self.chooseArr);
    [UploadImageNet postDataWithUrl:[NSString stringWithFormat:NetURL,CreateVoteURL] andParams:param andImage:self.headImageView.image getBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"发起投票%@",error);
              [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [weakSelf.chooseArr removeAllObjects];
                [DEFAULTS removeObjectForKey:@"indexPath"];
                NSDictionary * dict = data[@"data"];
                //图文消息
                RCRichContentMessage *rich = [RCRichContentMessage messageWithTitle:weakSelf.titleTV.text digest:str imageURL:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"voteImage"]]] extra:[NSString stringWithFormat:@"活动结束时间:%@",weakSelf.endTimeLabel.text]];
                [[RCIM sharedRCIM]sendMediaMessage:ConversationType_GROUP targetId:self.groupID content:rich pushContent:[NSString stringWithFormat:@"%@在%@发起了群投票“%@”",nickname,self.groupName,self.titleTV.text] pushData:nil progress:^(int progress, long messageId) {
                    //风火轮加载
                    
                    
                } success:^(long messageId) {
                    NSSLog(@"发送成功");
                  
                } error:^(RCErrorCode errorCode, long messageId) {
                    [weakSelf showMessage:@"发送失败"];
                } cancel:^(long messageId) {
                    [weakSelf showMessage:@"取消了发送"];
                }];
                weakSelf.delegate.isRef = YES;
                [weakSelf leftClick];
            }else if ([code intValue] == 1015){
                [weakSelf showMessage:@"请上传文件"];
            }else{
                 [weakSelf showMessage:@"创建投票失败"];
            }
        }

    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VoteCell"];
    if (indexPath.row < self.count-1) {
        cell.lineView.hidden = NO;
        cell.chooseTF.placeholder = [NSString stringWithFormat:@"选项%ld",(long int)indexPath.row+1];
    }else if(indexPath.row == self.count-1){
        cell.chooseTF.enabled = NO;
        cell.lineView.hidden = YES;
    }
    WeakSelf;
    cell.block = ^(NSString *text){
        [weakSelf.chooseArr addObject:text];
    };
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.count-1) {
        return 42;
    }else{
        return 34.5;
    }
}
//编辑模式
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
        return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 1 && indexPath.row <= self.count-2) {
        //删除模式
        return UITableViewCellEditingStyleDelete;
    }else if (indexPath.row == self.count-1){
        //插入模式
        return UITableViewCellEditingStyleInsert;
        
    }else{
        //第一二个没有
        return UITableViewCellEditingStyleNone;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.count--;
        VoteCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        //清空TF内容
        cell.chooseTF.text = @"";
        //删除那行的数据
        [self.chooseArr removeObjectAtIndex:indexPath.row];
        [_tableView beginUpdates];
        //删除一个cell
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert){
        self.count++;
        [_tableView beginUpdates];
        //增加一个cell
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }

}
- (IBAction)endTimeClick:(id)sender {
    
    self.timeView.hidden = !self.timeView.hidden;
    
}
- (IBAction)finishClick:(id)sender {
    self.endTimeLabel.text = [NowDate getDetailTime:self.datePickier.date];
    self.timeView.hidden = YES;
}
- (IBAction)datePickerClick:(id)sender {
    self.endTimeLabel.text = [NowDate getDetailTime:self.datePickier.date];

}

- (IBAction)chooseClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    VoteTypeController * vote = [sb instantiateViewControllerWithIdentifier:@"VoteTypeController"];
    vote.delegate = self;
    [self.navigationController pushViewController:vote animated:YES];
 
}
-(NSMutableArray *)chooseArr{
    if (!_chooseArr) {
        _chooseArr = [NSMutableArray new];
    }
    return _chooseArr;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.placeLabel.hidden = YES;
    return YES;
}
#pragma mark-照片
- (IBAction)addImageClick:(id)sender {
    [self openAlbums];
}
-(void)openAlbums{
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //dismiss系统的设置自定义
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
    
    self.headImageView.image = originalImage;
    
}
//手势代理方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UITableView class]]) {
        
        return NO;
    }
    if ([touch.view isKindOfClass:[UIButton class]]) {
        
        return NO;
    }
    return YES;
}
-(void)showMessage:(NSString *)msg{
    UIView * msgView = [UIView showViewTitle:msg];
    [self.view addSubview:msgView];
    [UIView animateWithDuration:1.0 animations:^{
        msgView.frame = CGRectMake(20, KMainScreenHeight-150, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
        //完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}
@end
