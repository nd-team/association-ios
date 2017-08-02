//
//  HelpCommentController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/5.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HelpCommentController.h"
#import "HelpCommentCell.h"
#import "CommentDetailListModel.h"

#define AcceptURL @"appapi/app/answerSeekAdopt"
#define ReplyURL @"appapi/app/replyArticleComment"
#define CommentURL @"appapi/app/articleComment"
#define LOOKCommentURL @"appapi/app/selectArticleComment"

@interface HelpCommentController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (nonatomic,strong)NSMutableArray * dataArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomCons;

@property (weak, nonatomic) IBOutlet UITextView *commentTV;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomHeightCons;
@property (nonatomic,copy) NSString * userId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeightCons;
@property (nonatomic,assign)int page;

@end

@implementation HelpCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回答";

    self.userId = [DEFAULTS objectForKey:@"userId"];
    if ([self.userId isEqualToString:self.hostId]) {
        self.acceptBtn.hidden = NO;
    }else{
        self.acceptBtn.hidden = YES;
    }
    [self.acceptBtn setBackgroundImage:[UIImage imageNamed:@"acceptAnswer"] forState:UIControlStateNormal];
    [self.acceptBtn setBackgroundImage:[UIImage imageNamed:@"disagreeBtn"] forState:UIControlStateDisabled];
    //监听键盘变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [self setUI];
    [self netWork];
    
}
-(void)keyboardWillShow:(NSNotification *)nofi{
    NSDictionary * userInfo = [nofi userInfo];
    NSValue * aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyRect = [aValue CGRectValue];
    self.viewBottomCons.constant = keyRect.size.height;
    
}
-(void)keyBoardWillHidden:(NSNotification *)nofi{
    //改变输入框的位置
    self.viewBottomCons.constant = 0;
    
}
-(void)setUI{
    self.page = 1;
    self.titleLabel.text = self.titleStr;
    self.nameLabel.text = self.nameStr;
    self.timeLabel.text = self.time;
    [self.headImageView zy_cornerRadiusRoundingRect];
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.commentLabel.text = self.comment;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 114;
    [self.loveBtn setTitle:[NSString stringWithFormat:@"%@",self.loveCount] forState:UIControlStateNormal];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = [self.commentLabel.text boundingRectWithSize:CGSizeMake(KMainScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        CGRect frame = self.headView.frame;
        frame.size.height = 175+rect.size.height;
        self.headView.frame = frame;
    });
    WeakSelf;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getCommentListData];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getCommentListData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
}
-(void)netWork{
    NSInteger status = [[RCIMClient sharedRCIMClient]getCurrentNetworkStatus];
    if (status == 0) {
        //无网从本地加载数据
        [self showMessage:@"亲，没有连接网络哦！"];
    }else{
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf getCommentListData];
        });
        
    }
    
}
-(void)getCommentListData{
    WeakSelf;
    NSDictionary * dict = @{@"userId":self.userId,@"articleId":self.answerId,@"type":@"4",@"page":[NSString stringWithFormat:@"%d",self.page]};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,LOOKCommentURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"评论列表失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            if (weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }else{
            if (!self.tableView.mj_footer.isRefreshing) {
                [self.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                NSArray * comArr = dict[@"comments"];
                if (comArr.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    for (NSDictionary * dic in comArr) {
                        CommentDetailListModel * comment = [[CommentDetailListModel alloc]initWithDictionary:dic error:nil];
                        [weakSelf.dataArr addObject:comment];
                    }
                }
                
            }else{
                [weakSelf showMessage:@"加载评论失败！"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                if (weakSelf.tableView.mj_footer.isRefreshing) {
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
            });
           
        }
    }];
}
//采纳答案
- (IBAction)acceptClick:(id)sender {
    WeakSelf;
    NSDictionary * dict = @{@"userId":self.userId,@"seekId":self.actiId,@"answerId":self.answerId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,AcceptURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"采纳答案失败:%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                weakSelf.acceptBtn.enabled = NO;
            }else if ([code intValue] == 1026){
                [weakSelf showMessage:@"已有用户采纳"];
            }else if ([code intValue] == 1027){
                [weakSelf showMessage:@"采纳失败"];
            }else if ([code intValue] == 1028){
                [weakSelf showMessage:@"非法操作"];
            }else{
                [weakSelf showMessage:@"采纳失败"];
            }
        }
    }];
}
//评论点赞--后台没做
- (IBAction)loveClick:(id)sender {
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HelpCommentCell"];
    cell.commentModel = self.dataArr[indexPath.row];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentDetailListModel * model = self.dataArr[indexPath.row];
    return model.height;
}
//分组
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 40)];
    view.backgroundColor = UIColorFromRGB(0xeceef0);
    UILabel * label2 = [UILabel initFrame:CGRectMake(10, 0, 100, 40) andTitle:@"评论" andTextColor:UIColorFromRGB(0x121212) andFont:14];
    [view addSubview:label2];
    return view;
    
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
    }
    //是否有候选字符
    if (textView.markedTextRange == nil) {
        //行间距
        NSMutableParagraphStyle * paraStyle = [NSMutableParagraphStyle new];
        paraStyle.lineSpacing = 4;
        NSDictionary * att = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paraStyle};
        self.commentTV.attributedText = [[NSAttributedString alloc]initWithString:textView.text attributes:att];
        dispatch_async(dispatch_get_main_queue(), ^{
            //获取输入总高度
            CGSize allSize = [self sizeWithString:textView.text andWidth:KMainScreenWidth-20 andFont:14];
            //获取一行的高度
            CGSize size = [self sizeWithString:@"hello" andWidth:KMainScreenWidth-20 andFont:14];
            NSInteger line = allSize.height/size.height;
            if (line == 1) {
                self.tvHeightCons.constant = 40;
            }else if(line <= 4 && line>1){
                self.tvHeightCons.constant = allSize.height+line*4;
            }else{
                self.tvHeightCons.constant = (size.height+4)*4;
            }
            self.BottomHeightCons.constant = 10+self.tvHeightCons.constant;

        });
        
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text == nil) {
        //return不可用
        
    }
    if ([text isEqualToString:@"\n"]) {
        //汉字
        [self.commentTV resignFirstResponder];
        //回复评论
        NSMutableDictionary * mDic = [NSMutableDictionary new];
//        [mDic setValue:self.answerId forKey:@"commentId"];
        [mDic setValue:self.answerId forKey:@"articleId"];
        [mDic setValue:self.userId forKey:@"userId"];
        [mDic setValue:self.commentTV.text forKey:@"content"];
        [mDic setValue:@"4" forKey:@"type"];
        [self postSendComment:[NSString stringWithFormat:NetURL,CommentURL] andParams:mDic];
        
        return NO;
    }
    
    
    return YES;
}
//评论和回复评论
-(void)postSendComment:(NSString *)url andParams:(NSMutableDictionary *)mDic{
    WeakSelf;
    [AFNetData postDataWithUrl:url andParams:mDic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"评论失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯，操作失败！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                weakSelf.commentTV.text = @"";
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.tvHeightCons.constant = 40;
                    weakSelf.BottomHeightCons.constant = 10+self.tvHeightCons.constant;
                });
                //评论成功、回复评论成功或者插入一条数据
                [weakSelf getCommentListData];
            }else{
                [weakSelf showMessage:@"评论失败！"];
            }
            
        }
        
    }];
}

-(CGSize)sizeWithString:(NSString *)str andWidth:(CGFloat)width andFont:(CGFloat)font{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
@end
