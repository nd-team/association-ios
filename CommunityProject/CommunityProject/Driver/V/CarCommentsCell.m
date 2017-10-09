//
//  CarCommentsCell.m
//  CommunityProject
//
//  Created by bjike on 2017/8/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CarCommentsCell.h"

@implementation CarCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.headImageView zy_cornerRadiusRoundingRect];
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCommentModel:(MyCarListCommentsModel *)commentModel{
    _commentModel = commentModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:_commentModel.userPortraitUrl]]] placeholderImage:[UIImage imageNamed:@"default.png"]];
    self.nameLabel.text = _commentModel.userName;
    self.contentLabel.text = _commentModel.content;
    NSInteger count = [_commentModel.starNumber integerValue];
    switch (count) {
        case 0:
            [self setScoreImage:@"starDark" andSecond:@"starDark" andThird:@"starDark" andFourth:@"starDark" andFive:@"starDark"];
            
            break;
        case 1:
            [self setScoreImage:@"starYellow" andSecond:@"starDark" andThird:@"starDark" andFourth:@"starDark" andFive:@"starDark"];
            
            break;
        case 2:
            [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starDark" andFourth:@"starDark" andFive:@"starDark"];
            
            break;
        case 3:
            [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starDark" andFive:@"starDark"];
            
            break;
        case 4:
            [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starYellow" andFive:@"starDark"];
            
            break;
            
        default:
            [self setScoreImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starYellow" andFive:@"starYellow"];
            
            break;
    }
    
}
-(void)setScoreImage:(NSString *)first andSecond:(NSString *)second andThird:(NSString *)third andFourth:(NSString *)four andFive:(NSString *)five{
    self.firstImage.image = [UIImage imageNamed:first];
    self.secondImage.image = [UIImage imageNamed:second];
    self.thirdImage.image = [UIImage imageNamed:third];
    self.fourthImage.image = [UIImage imageNamed:four];
    self.fifthImage.image = [UIImage imageNamed:five];
    
}
@end
