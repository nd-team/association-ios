//
//  VoteTitleCell.m
//  LoveChatProject
//
//  Created by bjike on 17/3/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "VoteTitleCell.h"

@implementation VoteTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"noSelBtn"] forState:UIControlStateNormal];
    [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"chooseSel"] forState:UIControlStateSelected];
    [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"noSelBtn"] forState:UIControlStateDisabled];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOptionModel:(OptionModel *)optionModel{
    _optionModel = optionModel;
    self.titleDetailLabel.text = _optionModel.content;
    if (_optionModel.count != 0) {
        self.countLabel.text = [NSString stringWithFormat:@"%ld票",(long)_optionModel.count];
    }else{
        self.countLabel.text = @"";
    }
}
- (IBAction)chooseClick:(id)sender {
    self.chooseBtn.selected = !self.chooseBtn.selected;
    UIButton * button = (UIButton *)sender;
    VoteTitleCell * cell = (VoteTitleCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OptionModel * model = self.dataArr[indexPath.row];
    //单选
    if (self.isSingle) {        
        if (self.chooseBtn.selected) {
            self.block([NSString stringWithFormat:@"%ld",(long)model.id],YES,NO);
            self.selectBlock(indexPath);
        }
    }else{
        if (self.chooseBtn.selected) {
            self.block([NSString stringWithFormat:@"%ld",(long)model.id],NO,NO);
        }else{
            self.block([NSString stringWithFormat:@"%ld",(long)model.id],NO,YES);
        }
    }
   
}
@end
