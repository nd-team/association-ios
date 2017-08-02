//
//  PositionCommentListCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PositionCommentListCell.h"
#import "CircleImageCell.h"
#import "MJPhotoBrowser.h"
#import "PutNet.h"

#define ZanURL @"/comment/like/%@"

@implementation PositionCommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];
    [self.headImageView zy_cornerRadiusRoundingRect];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CircleImageCell" bundle:nil] forCellWithReuseIdentifier:@"FirstPositionImageCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCommentModel:(PositionCommentListModel *)commentModel{
    _commentModel = commentModel;
    self.nameLabel.text = _commentModel.nickname;
    self.commentLabel.text = _commentModel.content;
    self.likes = _commentModel.likes;
    self.loveCountLabel.text = [NSString stringWithFormat:@"赞 %@",_commentModel.likes];
    NSString * url = [NSString stringWithFormat:NetURL,_commentModel.headPath];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default"]];
    if (_commentModel.alreadyLikes) {
        self.loveBtn.selected = YES;
    }else{
        self.loveBtn.selected = NO;
    }
    NSString * time = [_commentModel.createTime componentsSeparatedByString:@" "][0];
    NSArray * timeArr = [time componentsSeparatedByString:@"-"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@月%@日",timeArr[1],timeArr[2]];
    if ([_commentModel.scoreType isEqualToString:@"FIRST"]){
        [self setScoreImage:@"starYellow" andSecond:@"starDark" andThird:@"starDark" andFourth:@"starDark" andFive:@"starDark"];

    }else if ([_commentModel.scoreType isEqualToString:@"SECOND"]){
        [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starDark" andFourth:@"starDark" andFive:@"starDark"];
        
    }else if ([_commentModel.scoreType isEqualToString:@"THIRD"]){
        [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starDark" andFive:@"starDark"];
        
    }else if ([_commentModel.scoreType isEqualToString:@"FOURTH"]){
        [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starYellow" andFive:@"starDark"];
        
    }else if ([_commentModel.scoreType isEqualToString:@"FIFTH"]){
        [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starYellow" andFive:@"starYellow"];
        
    }else{
        [self setScoreImage:@"starDark" andSecond:@"starDark" andThird:@"starDark" andFourth:@"starDark" andFive:@"starDark"];
 
    }
       dispatch_async(dispatch_get_main_queue(), ^{
           NSInteger count = _commentModel.images.count;
           NSInteger shu = count%3;
           if (shu != 0) {
               self.collHeightCons.constant = count/3*100+100;
           }else{
               self.collHeightCons.constant = count/3*100;
           }

        [self.collectionView reloadData];
    });

}
-(void)setScoreImage:(NSString *)first andSecond:(NSString *)second andThird:(NSString *)third andFourth:(NSString *)four andFive:(NSString *)five{
    self.firstImage.image = [UIImage imageNamed:first];
    self.secondImage.image = [UIImage imageNamed:second];
    self.thirdImage.image = [UIImage imageNamed:third];
    self.fourthImage.image = [UIImage imageNamed:four];
    self.fiveImage.image = [UIImage imageNamed:five];

}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _commentModel.images.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CircleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstPositionImageCell" forIndexPath:indexPath];
    //缩略图
    NSString * url = [NSString stringWithFormat:JAVAURL,@"file/thumbnails?path=%@"];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:url,_commentModel.images[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"default"]];
    return cell;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KMainScreenWidth-93)/3, 100);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CircleImageCell * cell = (CircleImageCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    //看大图
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < _commentModel.images.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        //查看原图
        NSString * url = [NSString stringWithFormat:JAVAURL,@"file/original/pic?path=%@"];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:url,_commentModel.images[i]]];
        photo.srcImageView = cell.headImageView; //设置来源哪一个UIImageView
        [photos addObject:photo];
    }
    brower.photos = photos;
    
    //3.设置默认显示的图片索引
    brower.currentPhotoIndex = indexPath.row;
    
    //4.显示浏览器
    [brower show];
    
    
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UICollectionView class]]) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}
//评论点赞
- (IBAction)loveClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    PositionCommentListCell * cell = (PositionCommentListCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    PositionCommentListModel * model = self.dataArr[indexPath.row];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    WeakSelf;
    self.loveBtn.selected = !self.loveBtn.selected;
    NSString * url = [NSString stringWithFormat:ZanURL,model.idStr];
//    NSSLog(@"url:%@",[NSString stringWithFormat:JAVAURL,url]);
    [PutNet putDataWithUrl:[NSString stringWithFormat:JAVAURL,url] andParams:nil andHeader:userId returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"平台点赞失败：%@",error);
            weakSelf.loveBtn.selected = NO;
        }else{
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = dict[@"code"];
            if ([code intValue] == 0) {
                weakSelf.loveBtn.selected = !self.loveBtn.selected;
                if (self.loveBtn.selected) {
                    weakSelf.likes = [NSString stringWithFormat:@"%zi",[self.likes integerValue]+1];
                }else{
                    weakSelf.likes = [NSString stringWithFormat:@"%zi",[self.likes integerValue]-1];
                }
                weakSelf.loveCountLabel.text = [NSString stringWithFormat:@"赞 %@",self.likes];
                
            }else{
                weakSelf.loveBtn.selected = NO;
            }
        }
        
    }];
}
@end
