//
//  ActImageCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ActImageCell.h"

@implementation ActImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUploadModel:(UploadImageModel *)uploadModel{
    
    _uploadModel = uploadModel;
        
    self.headImageView.image = _uploadModel.image;
    
}
@end
