//
//  CircleCommentController.m
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CircleCommentController.h"
#import "CircleCommentCell.h"
#import "CircleCommentModel.h"
#import "CircleImageCell.h"
#import "MJPhotoBrowser.h"


#define CommentURL @"appapi/app/selectArticleComment"
#define JudgeURL @"appapi/app/articleComment"
#define ReplyCommentURL @"appapi/app/replyArticleComment"
#define CircleDetailURL @"appapi/app/friendsCircleInfo"
#define ZanURL @"appapi/app/userPraise"

@interface CircleCommentController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conHeightCons;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zanImage;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic,assign)CGFloat height;

@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeightCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomCons;

//
@property (weak, nonatomic) IBOutlet UITextView *placeLabel;
//当前用户
@property (nonatomic,copy)NSString * userId;
//回复评论的参数
@property (nonatomic,strong)NSMutableDictionary * params;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
//分页
@property (nonatomic,assign)int page;

@end

@implementation CircleCommentController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"正文";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10DB9F);
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleCommentCell" bundle:nil] forCellReuseIdentifier:@"CircleCommentCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CircleImageCell" bundle:nil] forCellWithReuseIdentifier:@"CircleImageCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 84;
    //监听键盘变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    self.userId = [DEFAULTS objectForKey:@"userId"];
    self.page = 1;
    if (!self.isMsg) {
        [self setUI];
    }
    [self netWork];
    //点击手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];

}
-(void)netWork{
    NSInteger status = [[RCIMClient sharedRCIMClient]getCurrentNetworkStatus];
    if (status == 0) {
        //无网从本地加载数据
        [self showMessage:@"亲，没有连接网络"];
    }else{
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            if (weakSelf.isMsg) {
                //请求数据
                [weakSelf getCircleDetailData];
            }else{
                //获取评论数据 朋友圈
                [weakSelf getCommentListData];
                
            }
        });
        
    }
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}
-(void)setUI{

    //传参过来
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = self.name;
    self.contentLabel.text = self.content;
    self.timeLabel.text = self.time;
    self.placeLabel.text = self.placeStr;
    //根据数据变化view的高度
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat labelHeight = 0;
        CGFloat imageHeight = 0;
        if (self.content.length == 0) {
            labelHeight = 0;
            self.conHeightCons.constant = 0;
        }else{
            //取到label的高度
            CGRect rect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(KMainScreenWidth-73, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            labelHeight = rect.size.height;
            self.conHeightCons.constant = labelHeight;
        }
        if (self.collectionArr.count == 0) {
            self.collHeightCons.constant = 0;
        }else if(self.collectionArr.count <= 3){
            self.collHeightCons.constant = 103;
        }else if(self.collectionArr.count <= 6){
            self.collHeightCons.constant = 206;
        }else if(self.collectionArr.count <= 9){
            self.collHeightCons.constant = 309;
        }
        imageHeight = self.collHeightCons.constant;
        CGRect frame = self.headerView.frame;
        if (self.content.length != 0 && self.collectionArr.count != 0) {
            frame.size.height = 126+labelHeight+imageHeight;
        }else if (self.content.length == 0 && self.collectionArr.count != 0){
            frame.size.height = 117+labelHeight+imageHeight;
        }else{
            frame.size.height = 119+labelHeight+imageHeight;
        }
        self.headerView.frame = frame;
    });
//    [self.tableView beginUpdates];
    
    //变换颜色
    if ([self.commentCount isEqualToString:@"0"]) {
        self.commentLabel.text = @"评论";
        self.commentLabel.textColor = UIColorFromRGB(0x666666);
    }else{
        self.commentLabel.attributedText = [ImageUrl changeTextColor:[NSString stringWithFormat:@"评论 %@",self.commentCount] andFirstString:@"评论 " andColor:UIColorFromRGB(0x666666) andFont:[UIFont systemFontOfSize:15] andRangeStr:self.commentCount andChangeColor:UIColorFromRGB(0x999999) andSecondFont:[UIFont systemFontOfSize:12]];
 
    }
    if ([self.likeCount isEqualToString:@"0"]) {
        self.zanLabel.text = @"";
    }else{
        self.zanLabel.text = self.likeCount;
    }
    if ([self.isLike isEqualToString:@"0"]) {
        //未点赞
        _zanImage.image = [UIImage imageNamed:@"darkHeart"];
        _zanBtn.selected = NO;
    }else{
        _zanImage.image = [UIImage imageNamed:@"heart"];
        _zanBtn.selected = YES;
    }
    //上下拉刷新
    self.tableView.mj_footer.automaticallyHidden = YES;
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getCommentListData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getCommentListData];
    }];
}
-(void)getCircleDetailData{
    WeakSelf;
    NSDictionary * dict = @{@"userId":self.userId,@"articleId":self.idStr};
//    NSSLog(@"%@",dict);
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CircleDetailURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"朋友圈详情失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            if (!weakSelf.tableView.mj_footer.isRefreshing) {
                [self.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                //初始化数据
                weakSelf.headUrl = [NSString stringWithFormat:@"%@",dict[@"userPortraitUrl"]];
                weakSelf.name = dict[@"nickname"];
                weakSelf.time = dict[@"releaseTime"];
                weakSelf.content = dict[@"content"];
                weakSelf.collectionArr = dict[@"images"];
                weakSelf.commentCount = [NSString stringWithFormat:@"%@",dict[@"commentNumber"]];
                weakSelf.likeCount = [NSString stringWithFormat:@"%@",dict[@"likes"]];
                weakSelf.isLike = [NSString stringWithFormat:@"%@",dict[@"likesStatus"]];
                [weakSelf setUI];
                NSArray * comArr = dict[@"comments"];
//                NSSLog(@"%@",comArr);
                for (NSDictionary * dic in comArr) {
                    CircleCommentModel * comment = [[CircleCommentModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:comment];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                    [weakSelf.tableView reloadData];
                });

            }else{
                [weakSelf showMessage:@"加载朋友圈详情失败咯！"];
            }
            
        }
    }];

}
-(void)tapClick{
    [self.contentTV resignFirstResponder];
    if (self.contentTV.text.length == 0) {
        self.placeLabel.hidden = NO;
    }else{
        self.placeLabel.hidden = YES;
    }
}
-(void)getCommentListData{
    WeakSelf;
    NSDictionary * dict = @{@"userId":self.userId,@"articleId":self.idStr,@"type":@"2",@"page":[NSString stringWithFormat:@"%d",self.page]};
//    NSSLog(@"%@",dict);
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CommentURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"朋友圈评论失败：%@",error);
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
                        CircleCommentModel * comment = [[CircleCommentModel alloc]initWithDictionary:dic error:nil];
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
#pragma mark - tableView-delegate and DataSources

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCommentModel * model = self.dataArr[indexPath.row];
    if (model.height != 0) {
        return model.height;
    }
    return 84;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCommentCell"];
    cell.commentModel = self.dataArr[indexPath.row];
    cell.tbView = self.tableView;
    cell.baseArr = self.dataArr;    
    WeakSelf;
    cell.block = ^(NSString * commentId,NSString * nickname){
        [weakSelf.contentTV becomeFirstResponder];
        weakSelf.placeLabel.text = [NSString stringWithFormat:@"回复%@",nickname];
        weakSelf.params = [NSMutableDictionary new];
        [weakSelf.params setValue:weakSelf.idStr forKey:@"articleId"];
        [weakSelf.params setValue:commentId forKey:@"commentId"];
        [weakSelf.params setValue:weakSelf.userId forKey:@"userId"];
        [weakSelf.params setValue:@"2" forKey:@"type"];
    };
    
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CircleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleImageCell" forIndexPath:indexPath];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.collectionArr[indexPath.row]]]] placeholderImage:[UIImage imageNamed:@"default"]];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //看大图
    CircleImageCell * cell = (CircleImageCell *) [collectionView cellForItemAtIndexPath:indexPath];

    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < self.collectionArr.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.collectionArr[i]]]];
        photo.srcImageView = cell.headImageView; //设置来源哪一个UIImageView
        [photos addObject:photo];
    }
    brower.photos = photos;
    
    //3.设置默认显示的图片索引
    brower.currentPhotoIndex = indexPath.row;
    
    //4.显示浏览器
    [brower show];

}
//原文的评论
- (IBAction)judgeClick:(id)sender {
    [self.params removeAllObjects];
    self.placeLabel.text = self.placeStr;
    [self.contentTV becomeFirstResponder];
}
#pragma mark-textView-delegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView == self.contentTV) {
        
        if (textView.text.length == 0) {
            self.placeLabel.hidden = NO;
        }else{
            self.placeLabel.hidden = YES;
        }
        //是否有候选字符
        if (textView.markedTextRange == nil) {
            //行间距
            NSMutableParagraphStyle * paraStyle = [NSMutableParagraphStyle new];
            paraStyle.lineSpacing = 4;
            NSDictionary * att = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paraStyle};
            self.contentTV.attributedText = [[NSAttributedString alloc]initWithString:textView.text attributes:att];
            //获取输入总高度
            CGSize allSize = [self sizeWithString:textView.text andWidth:KMainScreenWidth-55.5 andFont:15];
            //获取一行的高度
            CGSize size = [self sizeWithString:@"hello" andWidth:KMainScreenWidth-55.5 andFont:15];
            NSInteger line = allSize.height/size.height;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (line == 1) {
                    self.tvHeightCons.constant = 40;
                }else if(line <= 4 && line>1){
                    self.tvHeightCons.constant = allSize.height+line*4;
                }else{
                    self.tvHeightCons.constant = (size.height+4)*4;
                }
                self.bottomHeightCons.constant = 10+self.tvHeightCons.constant;

            });
            
        }
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == self.contentTV) {
        
        if (textView.text == nil) {
            //return不可用
            
        }
        if ([text isEqualToString:@"\n"]) {
            
            //汉字
            [self.contentTV resignFirstResponder];
            //回复评论
            if (self.params.count != 0) {
                [self.params setValue:self.contentTV.text forKey:@"content"];
                [self postSendComment:[NSString stringWithFormat:NetURL,ReplyCommentURL] andParams:self.params];
            }else{
                //评论
                NSMutableDictionary * mDic = [NSMutableDictionary new];
                [mDic setValue:self.idStr forKey:@"articleId"];
                [mDic setValue:self.userId forKey:@"userId"];
                [mDic setValue:self.contentTV.text forKey:@"content"];
                [mDic setValue:@"2" forKey:@"type"];
                [self postSendComment:[NSString stringWithFormat:NetURL,JudgeURL] andParams:mDic];
            }
            return NO;
        }
        
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
                [weakSelf.params removeAllObjects];
                weakSelf.contentTV.text = @"";
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.tvHeightCons.constant = 40;
                    weakSelf.bottomHeightCons.constant = 10+self.tvHeightCons.constant;
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
- (IBAction)zanClick:(id)sender {
    _zanBtn.selected = !_zanBtn.selected;
    
   //发送点赞
    [self userLike];
}
-(void)userLike{
    NSDictionary * params = @{@"userId":self.userId,@"articleId":self.idStr,@"type":@"2",@"status":self.zanBtn.selected?@"1":@"0"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ZanURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"朋友圈点赞失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯，操作失败！"];
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                //+1-1
                NSInteger zan = [weakSelf.likeCount integerValue];
                if (weakSelf.zanBtn.selected) {
                    weakSelf.zanImage.image = [UIImage imageNamed:@"heart"];
                    self.zanLabel.text = [NSString stringWithFormat:@"%ld",(long)zan+1];
                }else{
                    weakSelf.zanImage.image = [UIImage imageNamed:@"darkHeart"];
                    self.zanLabel.text = [NSString stringWithFormat:@"%ld",(long)zan-1];

                }
            }else if ([code intValue] == 1029){
                [weakSelf showMessage:@"不要重复点赞"];
            }else if ([code intValue] == 1030){
                [weakSelf showMessage:@"非朋友点赞失败"];
            }else{
                [weakSelf showMessage:@"点赞失败"];
            }
        }
        
    }];
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}

//手势代理方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UICollectionView class]]) {
        return NO;
    }
    return YES;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
