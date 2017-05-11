//
//  CircleCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CircleCell.h"
#import "CircleImageCell.h"
#import "CircleCommentController.h"
#import "MJPhotoBrowser.h"

@implementation CircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CircleImageCell" bundle:nil] forCellWithReuseIdentifier:@"CircleImageCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setCircleModel:(CircleListModel *)circleModel{
    _circleModel = circleModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_circleModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = _circleModel.nickname;
    self.timeLabel.text = _circleModel.releaseTime;
    self.contentLabel.text = _circleModel.content;
    if (![_circleModel.likedNumber isEqualToString:@"0"]) {
        [self.loveBtn setTitle:_circleModel.likedNumber forState:UIControlStateNormal];
    }else{
        [self.loveBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if (![_circleModel.commentNumber isEqualToString:@"0"]) {
        [self.judgeBtn setTitle:_circleModel.commentNumber forState:UIControlStateNormal];
    }else{
        [self.judgeBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if ([_circleModel.likeStatus isEqualToString:@"0"]) {
        self.loveBtn.selected = NO;
    }else{
        self.loveBtn.selected = YES;
    }
    [self.collectionView reloadData];
}
- (IBAction)loveClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    UIButton * button = (UIButton *)sender;
    CircleCell * cell = (CircleCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    CircleListModel * model = self.dataArr[indexPath.row];
    NSDictionary * dic = @{@"userId":userId,@"articleId":[NSString stringWithFormat:@"%ld",(long)model.id],@"type":@"2",@"status":self.loveBtn.selected?@"1":@"0"};
    self.block(dic,indexPath,self.loveBtn.selected);
    
}

- (IBAction)judgeClick:(id)sender {
    //进入详情
    UIButton * button = (UIButton *)sender;
    CircleCell * cell = (CircleCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    CircleListModel * model = self.dataArr[indexPath.row];
    //进入详情
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    CircleCommentController * comment = [sb instantiateViewControllerWithIdentifier:@"CircleCommentController"];
    comment.headUrl = model.userPortraitUrl;
    comment.name = model.nickname;
    comment.time = model.releaseTime;
    comment.content = model.content;
    comment.collectionArr = model.images;
    comment.likeCount = model.likedNumber;
    comment.commentCount = model.commentNumber;
    comment.isLike = model.likeStatus;
    comment.idStr = [NSString stringWithFormat:@"%ld",(long)model.id];
    comment.placeStr = [NSString stringWithFormat:@"评论%@",model.nickname];
    self.pushBlock(comment);

}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _circleModel.images.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CircleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleImageCell" forIndexPath:indexPath];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_circleModel.images[indexPath.row]]]] placeholderImage:[UIImage imageNamed:@"default"]];
    return cell;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KMainScreenWidth-73)/3, 103);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CircleImageCell * cell = (CircleImageCell *) [collectionView cellForItemAtIndexPath:indexPath];

    //看大图
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < _circleModel.images.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_circleModel.images[i]]]];
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

@end
