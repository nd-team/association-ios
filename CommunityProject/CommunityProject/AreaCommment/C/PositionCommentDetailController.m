//
//  PositionCommentDetailController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/22.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PositionCommentDetailController.h"
#import "CircleImageCell.h"
#import "MJPhotoBrowser.h"
#import "PutNet.h"

#define ZanURL @"comment/like/%@"
@interface PositionCommentDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;

@property (weak, nonatomic) IBOutlet UIImageView *fifthImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeightCons;
@property (nonatomic,copy)NSString * userId;

@end

@implementation PositionCommentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"点评详情";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CircleImageCell" bundle:nil] forCellWithReuseIdentifier:@"PositionCommentDetailCell"];
    [self setUI];
    
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setUI{
    self.userId = [DEFAULTS objectForKey:@"userId"];
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];
    self.loveBtn.selected = self.isLove;
    [self.headImageView zy_cornerRadiusRoundingRect];
    NSString * url = [NSString stringWithFormat:JAVAURL,@"file/thumbnails?path=%@"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:url,self.headUrl]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = self.nickname;
    NSString * time = [self.time componentsSeparatedByString:@" "][0];
    NSArray * timeArr = [time componentsSeparatedByString:@"-"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@月%@日",timeArr[0],timeArr[1]];
    self.commentLabel.text = self.comment;
    if ([self.score isEqualToString:@"0"]) {
        [self setScoreImage:@"starDark" andSecond:@"starDark" andThird:@"starDark" andFourth:@"starDark" andFive:@"starDark"];
    }else if ([self.score isEqualToString:@"1"]){
        [self setScoreImage:@"starYellow" andSecond:@"starDark" andThird:@"starDark" andFourth:@"starDark" andFive:@"starDark"];
        
    }else if ([self.score isEqualToString:@"2"]){
        [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starDark" andFourth:@"starDark" andFive:@"starDark"];
        
    }else if ([self.score isEqualToString:@"3"]){
        [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starDark" andFive:@"starDark"];
        
    }else if ([self.score isEqualToString:@"4"]){
        [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starYellow" andFive:@"starDark"];
        
    }else if ([self.score isEqualToString:@"5"]){
        [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starYellow" andFive:@"starYellow"];
    }
    //计算高度
    CGFloat contentHei = [ImageUrl boundingRectWithString:self.comment width:(KMainScreenWidth-85) height:MAXFLOAT font:15].height;
    if (self.collectArr.count == 0) {
        self.collHeightCons.constant = 0;
    }else if (self.collectArr.count < 4 && self.collectArr.count > 0) {
        self.collHeightCons.constant = 100;
    }else if (self.collectArr.count < 7 && self.collectArr.count >=4){
        self.collHeightCons.constant = 200;
    }else{
        self.collHeightCons.constant = 300;
    }
    CGFloat allHeight = self.collHeightCons.constant+contentHei+134;
    if (allHeight > KMainScreenHeight) {
        self.viewHeightCons.constant = allHeight;
    }else{
        self.viewHeightCons.constant = KMainScreenHeight;
    }
    [self.collectionView reloadData];
    
}
-(void)setScoreImage:(NSString *)first andSecond:(NSString *)second andThird:(NSString *)third andFourth:(NSString *)four andFive:(NSString *)five{
    self.firstImage.image = [UIImage imageNamed:first];
    self.secondImage.image = [UIImage imageNamed:second];
    self.thirdImage.image = [UIImage imageNamed:third];
    self.fourthImage.image = [UIImage imageNamed:four];
    self.fifthImage.image = [UIImage imageNamed:five];
}

#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CircleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PositionCommentDetailCell" forIndexPath:indexPath];
    NSString * url = [NSString stringWithFormat:JAVAURL,@"file/thumbnails?path=%@"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:url,self.collectArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"default"]];
    return cell;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KMainScreenWidth-85)/3, 100);
}
//看大图
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CircleImageCell * cell = (CircleImageCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    //看大图
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < self.collectArr.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString * url = [NSString stringWithFormat:JAVAURL,@"file/original/pic?path=%@"];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:url,self.collectArr[i]]];
        photo.srcImageView = cell.headImageView; //设置来源哪一个UIImageView
        [photos addObject:photo];
    }
    brower.photos = photos;
    
    //3.设置默认显示的图片索引
    brower.currentPhotoIndex = indexPath.row;
    
    //4.显示浏览器
    [brower show];

}
//评论点赞
- (IBAction)loveClick:(id)sender {
    WeakSelf;
    self.loveBtn.selected = !self.loveBtn.selected;
    NSString * url = [NSString stringWithFormat:ZanURL,self.commentId];
    [PutNet putDataWithUrl:[NSString stringWithFormat:JAVAURL,url] andParams:nil andHeader:self.userId returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"平台点赞失败：%@",error);
            weakSelf.loveBtn.selected = NO;
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 0) {
                weakSelf.loveBtn.selected = YES;
//                if (self.loveBtn.selected) {
//                    self.likes = [NSString stringWithFormat:@"%zi",[self.likes integerValue]+1];
//                }else{
//                    self.likes = [NSString stringWithFormat:@"%zi",[self.likes integerValue]-1];
//                }
//                [weakSelf.loveBtn setTitle:self.likes forState:UIControlStateNormal];
                
            }else{
                weakSelf.loveBtn.selected = NO;
                [weakSelf showMessage:@"点赞失败"];
            }
        }

    }];
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}

@end
