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
#import "LookBigImageController.h"

#define CommentURL @"appapi/app/selectArticleComment"
#define JudgeURL @"appapi/app/articleComment"
#define ReplyCommentURL @"appapi/app/replyArticleComment"

@interface CircleCommentController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightCons;
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
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic,copy)NSString * userId;
//回复评论的参数
@property (nonatomic,strong)NSMutableDictionary * params;

@end

@implementation CircleCommentController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //监听键盘变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    self.userId = [DEFAULTS objectForKey:@"userId"];
    [self setUI];
    //获取评论数据
    [self getCommentListData];
    
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
    self.navigationItem.title = @"正文";
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleCommentCell" bundle:nil] forCellReuseIdentifier:@"CircleCommentCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CircleImageCell" bundle:nil] forCellWithReuseIdentifier:@"CircleImageCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 84;
    //传参过来
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = self.name;
    self.contentLabel.text = self.content;
    self.timeLabel.text = self.time;
    self.placeLabel.text = self.placeStr;
    //根据数据变化view的高度
    [self.tableView beginUpdates];
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
    if (self.content.length != 0 && self.collectionArr.count != 0) {
        self.headerHeightCons.constant = 126+labelHeight+imageHeight;
    }else if (self.content.length == 0 && self.collectionArr.count != 0){
        self.headerHeightCons.constant = 117+labelHeight+imageHeight;
    }else{
        self.headerHeightCons.constant = 119+labelHeight+imageHeight;
    }
    CGRect frame = self.headerView.frame;
    frame.size.height = self.headerHeightCons.constant;
    self.headerView.frame = frame;
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView layoutIfNeeded];
    [self.tableView endUpdates];
    //变换颜色
    self.commentLabel.attributedText = [ImageUrl changeTextColor:[NSString stringWithFormat:@"评论 %@",self.commentCount] andFirstString:@"评论 " andColor:UIColorFromRGB(0x666666) andFont:[UIFont systemFontOfSize:15] andRangeStr:self.commentCount andChangeColor:UIColorFromRGB(0x999999) andSecondFont:[UIFont systemFontOfSize:12]];
    if ([self.likeCount isEqualToString:@"0"]) {
        self.zanLabel.text = @"";
    }else{
        self.zanLabel.text = self.likeCount;
    }
    if ([self.isLike isEqualToString:@"0"]) {
        //未点赞
        _zanImage.image = [UIImage imageNamed:@"darkHeart"];
    }else{
        _zanImage.image = [UIImage imageNamed:@"heart"];
    }
    //点击手势隐藏键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
   
    
}
-(void)tapClick{
    [self.contentTV resignFirstResponder];
}
-(void)getCommentListData{
    WeakSelf;
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    NSDictionary * dict = @{@"userId":userId,@"articleId":self.idStr,@"type":@"2"};
    NSSLog(@"%@",dict);
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CommentURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"朋友圈评论失败：%@",error);
        }else{
            if (self.dataArr.count != 0) {
                [self.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            NSSLog(@"%@",data);
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                NSArray * comArr = dict[@"comments"];
                NSSLog(@"%@",comArr);
                for (NSDictionary * dic in comArr) {
                    CircleCommentModel * comment = [[CircleCommentModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:comment];
                }
                [weakSelf.tableView reloadData];
            }
            
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCommentCell"];
    cell.commentModel = self.dataArr[indexPath.row];
    CGFloat labelHeight = 0;
    CGFloat imageHeight = 0;
    CircleCommentModel * model = self.dataArr[indexPath.row];
    //判断一级文字
    //取到label的高度
    CGSize size = [self sizeWithString:cell.contentLabel.text andWidth:KMainScreenWidth-45 andFont:13];
    labelHeight = size.height;
    cell.conHeightCons.constant = labelHeight;
    if (model.replyUsers.count == 0) {
        cell.tbHeightCons.constant = 0;
        imageHeight = 75;
    }else {
        cell.tbHeightCons.constant = 27*model.replyUsers.count;
        imageHeight = 90;
    }
    self.height = labelHeight+imageHeight+cell.tbHeightCons.constant;
    [cell layoutIfNeeded];
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
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    //看大图
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    LookBigImageController * look = [sb instantiateViewControllerWithIdentifier:@"LookBigImageController"];
    look.imageArr = self.collectionArr;
    look.count = indexPath.row+1;
    NSSLog(@"%ld",indexPath.row+1);
    [self.navigationController pushViewController:look animated:YES];
}
//原文的评论
- (IBAction)judgeClick:(id)sender {
    [self.params removeAllObjects];
    self.placeLabel.text = self.placeStr;
    [self.contentTV becomeFirstResponder];
}
#pragma mark-textView-delegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeLabel.hidden = NO;
    }else{
        self.placeLabel.hidden = YES;
    }
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
    if (line == 1) {
        self.tvHeightCons.constant = 40;
    }else if(line <= 4 && line>1){
        self.tvHeightCons.constant = allSize.height+line*4;
    }else{
        self.tvHeightCons.constant = (size.height+4)*4;
    }
    self.bottomHeightCons.constant = 10+self.tvHeightCons.constant;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text == nil) {
        //return不可用
        
    }
    if ([text isEqualToString:@"\n"]) {
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
    return YES;
}
//评论和回复评论
-(void)postSendComment:(NSString *)url andParams:(NSMutableDictionary *)mDic{
    WeakSelf;
    [AFNetData postDataWithUrl:url andParams:mDic returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"评论失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            NSSLog(@"%@",data);
            if ([code intValue] == 200) {
                [self.params removeAllObjects];
                self.contentTV.text = @"";
                //评论成功、回复评论成功或者插入一条数据
                [weakSelf getCommentListData];
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
@end
