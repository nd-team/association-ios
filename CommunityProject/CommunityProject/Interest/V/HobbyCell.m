//
//  HobbyCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/14.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HobbyCell.h"

@implementation HobbyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.hobbyBtn setTitleColor:UIColorFromRGB(0x18bc8b) forState:UIControlStateNormal];
    [self.hobbyBtn setTitleColor:UIColorFromRGB(0x11624a) forState:UIControlStateSelected];
    [self.hobbyBtn setBackgroundImage:[UIImage imageNamed:@"hobbyWhite"] forState:UIControlStateNormal];
    [self.hobbyBtn setBackgroundImage:[UIImage imageNamed:@"hobbyGreen"] forState:UIControlStateSelected];


}
- (IBAction)hobbyClick:(id)sender {
    self.hobbyBtn.selected = !self.hobbyBtn.selected;
    UIButton * button = (UIButton *)sender;
    HobbyCell * cell = (HobbyCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    self.block(indexPath);
    
}

@end
