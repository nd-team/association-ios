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
@interface CircleCommentController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>

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

@end

@implementation CircleCommentController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    //获取评论数据
    [self getCommentListData];
}
-(void)setUI{
    self.navigationItem.title = @"正文";
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleCommentCell" bundle:nil] forCellReuseIdentifier:@"CircleCommentCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CircleImageCell" bundle:nil] forCellWithReuseIdentifier:@"CircleImageCell"];
    //传参过来
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = self.name;
    self.contentLabel.text = self.content;
    self.timeLabel.text = self.time;
    //变换颜色
    self.commentLabel.attributedText = [ImageUrl changeTextColor:[NSString stringWithFormat:@"评论%@",self.commentCount] andFirstString:@"评论" andColor:UIColorFromRGB(0x666666) andFont:[UIFont systemFontOfSize:15] andRangeStr:self.commentCount andChangeColor:UIColorFromRGB(0x999999) andSecondFont:[UIFont systemFontOfSize:12]];
    self.zanLabel.text = self.likeCount;
    if ([self.isLike isEqualToString:@"0"]) {
        //未点赞
        _zanImage.image = [UIImage imageNamed:@"darkHeart"];
    }else{
        _zanImage.image = [UIImage imageNamed:@"heart"];
    }
    
}
-(void)getCommentListData{
    WeakSelf;
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CommentURL] andParams:@{@"userId":userId,@"articleId":self.idStr,@"type":@"2"} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"朋友圈评论失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                NSArray * comArr = dict[@"comments"];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCommentCell"];
    cell.commentModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //评论
    
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CircleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleImageCell" forIndexPath:indexPath];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    //看大图
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    LookBigImageController * look = [sb instantiateViewControllerWithIdentifier:@"LookBigImageController"];
    look.imageArr = self.collectionArr;
    look.count = indexPath.row;
    [self.navigationController pushViewController:look animated:YES];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
