//
//  AnswerCommentCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AnswerCommentCell.h"

@implementation AnswerCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor orangeColor].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setAnswerModel:(CircleAnswerModel *)answerModel{
    _answerModel = answerModel;
    NSSLog(@"%@",_answerModel.content);
    self.detailLabel.attributedText = [ImageUrl commentTextColor:[NSString stringWithFormat:@"%@回复%@:%@",_answerModel.nickname,_answerModel.fromNickname,_answerModel.content] andFirstString:_answerModel.nickname andFirstColor:UIColorFromRGB(0xe71717) andFirstFont:[UIFont systemFontOfSize:12] andSecondStr:@"回复" andSecondColor:UIColorFromRGB(0x333333) andSecondFont:[UIFont systemFontOfSize:12] andThirdStr:_answerModel.fromNickname andThirdColor:UIColorFromRGB(0xe71717) andThirdFont:[UIFont systemFontOfSize:12]andFourthStr:_answerModel.content andFourthColor:UIColorFromRGB(0x333333) andFourthFont:[UIFont systemFontOfSize:12]];
    CGSize labelSize = [self sizeWithString:self.detailLabel.text andWidth:KMainScreenWidth-50 andFont:12];
    _answerModel.height = labelSize.height;
    
}
-(CGSize)sizeWithString:(NSString *)str andWidth:(CGFloat)width andFont:(CGFloat)font{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size;
}
@end
