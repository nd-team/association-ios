//
//  PlatformCommentController.m
//  CommunityProject
//
//  Created by bjike on 17/5/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PlatformCommentController.h"
#import "AllCommentsCell.h"
#import "CommentsListModel.h"

#define CommentListURL @"appapi/app/selectArticleComment"
#define CommentURL @"appapi/app/articleComment"
#define ZanURL @"appapi/app/commentLikes"

@interface PlatformCommentController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * userId;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextView *commentTF;
@property (weak, nonatomic) IBOutlet UITextView *placeTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeightCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightCons;
//分页
@property (nonatomic,assign)int page;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@end

@implementation PlatformCommentController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"评论列表";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10DB9F);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    CGRect rect = self.headView.frame;
    //平台活动
    if (self.type == 6) {
        self.headView.hidden = YES;
        rect.size.height = 0;
    }else{
        self.headView.hidden = NO;
        [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];

        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default.png"]];
        self.contentLabel.text = [NSString stringWithFormat:@"“%@”",self.content];
        rect.size.height = 84;
    }
    self.headView.frame = rect;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
    //监听键盘变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    //点击手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    self.page = 1;
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf getCommentListData];
    });
    //上下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getCommentListData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getCommentListData];
    }];
   
    self.tableView.mj_footer.automaticallyHidden = YES;

}
-(void)tapClick{
    [self.commentTF resignFirstResponder];
    if (self.commentTF.text.length == 0) {
        self.placeTF.hidden = NO;
    }else{
        self.placeTF.hidden = YES;
    }
}
-(void)keyboardWillShow:(NSNotification *)nofi{
    NSDictionary * userInfo = [nofi userInfo];
    NSValue * aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyRect = [aValue CGRectValue];
    self.bottomCons.constant = keyRect.size.height;
    
}
-(void)keyBoardWillHidden:(NSNotification *)nofi{
    //改变输入框的位置
    self.bottomCons.constant = 0;
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)getCommentListData{
    WeakSelf;
    NSDictionary * dict = @{@"userId":self.userId,@"articleId":self.idStr,@"type":[NSString stringWithFormat:@"%d",self.type],@"page":[NSString stringWithFormat:@"%d",self.page]};
    //    NSSLog(@"%@",dict);
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CommentListURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSSLog(@"评论列表获取失败：%@",error);
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
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    for (NSDictionary * dic in comArr) {
                        CommentsListModel * comment = [[CommentsListModel alloc]initWithDictionary:dic error:nil];
                        [weakSelf.dataArr addObject:comment];
                    }
                }
            }else{
                [weakSelf showMessage:@"加载评论失败"];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            CGRect rect = self.footerView.frame;
            if (weakSelf.dataArr.count == 0) {
                     rect.size.height = KMainScreenHeight-125-74;
                    weakSelf.tableView.mj_footer.hidden = YES;
            }else{
                rect.size.height = 0;
                weakSelf.footerView.hidden = YES;
            }
            self.footerView.frame = rect;

        }
    }];
   
}

#pragma mark - tableView-delegate and DataSources
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据评论内容计算 高度
    CommentsListModel * list = self.dataArr[indexPath.row];
    if (list.height != 0) {
        return list.height;
    }
    return 88;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllCommentsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AllCommentsCell"];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    cell.commentModel = self.dataArr[indexPath.row];
    WeakSelf;
    cell.block = ^(NSDictionary * params,NSIndexPath * index,BOOL isSel){
        [weakSelf userLike:params andIndexPath:index andIsLove:isSel];
    };
    return cell;

}

-(void)userLike:(NSDictionary *)params andIndexPath:(NSIndexPath *)index andIsLove:(BOOL) isSel{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ZanURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"评论点赞失败：%@",error);
            [weakSelf showMessage:@"评论点赞失败"];
        }else{
            
            NSNumber * code = data[@"code"];
            //刷新一个cell
            if ([code intValue] == 200) {
                CommentsListModel * list = self.dataArr[index.row];
                if (isSel) {
                    list.likesStatus = @"1";
                    list.likes =  [NSString stringWithFormat:@"%d",[list.likes intValue]+1];
                }else{
                    list.likesStatus = @"0";
                    list.likes =  [NSString stringWithFormat:@"%d",[list.likes intValue]-1];
                }
                [UIView performWithoutAnimation:^{
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }else if ([code intValue] == 1029){
                [weakSelf showMessage:@"评论多次点赞失败"];
            }else{
                [weakSelf showMessage:@"评论点赞失败"];
            }
        }
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 41;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 41)];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 150, 40)];
    titleLabel.text = [NSString stringWithFormat:@"评论(%ld)",(unsigned long)self.dataArr.count];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = UIColorFromRGB(0x333333);
    [view addSubview:titleLabel];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 40, KMainScreenWidth-30, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xebebeb);
    [view addSubview:lineView];
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGSize)sizeWithString:(NSString *)str andWidth:(CGFloat)width andFont:(CGFloat)font{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size;
}
#pragma mark-textView-delegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeTF.hidden = NO;
    }else{
        self.placeTF.hidden = YES;
    }
    //是否有候选字符
    if (textView.markedTextRange == nil) {
        //行间距
        NSMutableParagraphStyle * paraStyle = [NSMutableParagraphStyle new];
        paraStyle.lineSpacing = 4;
        NSDictionary * att = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paraStyle};
        self.commentTF.attributedText = [[NSAttributedString alloc]initWithString:textView.text attributes:att];
        //获取输入总高度
        CGSize allSize = [self sizeWithString:textView.text andWidth:KMainScreenWidth-20 andFont:15];
        //获取一行的高度
        CGSize size = [self sizeWithString:@"hello" andWidth:KMainScreenWidth-20 andFont:15];
        NSInteger line = allSize.height/size.height;
        if (line == 1) {
            self.tvHeightCons.constant = 35;
        }else if(line <= 4 && line>1){
            self.tvHeightCons.constant = allSize.height+line*4;
        }else{
            self.tvHeightCons.constant = (size.height+4)*4;
        }
        self.bottomHeightCons.constant = 20+self.tvHeightCons.constant;
        
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text == nil) {
        //return不可用
        
    }
    if ([text isEqualToString:@"\n"]) {
        
        //汉字
        [self.commentTF resignFirstResponder];
        //回复评论
//        if (self.params.count != 0) {
//            [self.params setValue:self.contentTV.text forKey:@"content"];
//            [self postSendComment:[NSString stringWithFormat:NetURL,ReplyCommentURL] andParams:self.params];
//        }else{
            //评论
            NSMutableDictionary * mDic = [NSMutableDictionary new];
            [mDic setValue:self.idStr forKey:@"articleId"];
            [mDic setValue:self.userId forKey:@"userId"];
            [mDic setValue:self.commentTF.text forKey:@"content"];
            [mDic setValue:[NSString stringWithFormat:@"%d",self.type] forKey:@"type"];
            [self postSendComment:[NSString stringWithFormat:NetURL,CommentURL] andParams:mDic];
//        }
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
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                weakSelf.commentTF.text = @"";
                weakSelf.tvHeightCons.constant = 35;
                weakSelf.bottomHeightCons.constant = 20+self.tvHeightCons.constant;
                //评论成功、回复评论成功或者插入一条数据
                [weakSelf getCommentListData];
            }else{
                [weakSelf showMessage:@"回复评论失败"];
            }
            
        }
        
    }];
}
//手势代理方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    return YES;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

@end
