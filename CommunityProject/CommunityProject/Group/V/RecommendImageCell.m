//
//  RecommendImageCell.m
//  CommunityProject
//
//  Created by bjike on 17/4/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "RecommendImageCell.h"

@implementation RecommendImageCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    
}
-(void)setUploadModel:(UploadImageModel *)uploadModel{
    
    _uploadModel = uploadModel;
    
    self.delectButton.hidden = _uploadModel.isHide;
    
    self.headImageView.image = _uploadModel.image;
    
}
- (IBAction)delectClicked:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DelectImage" object:nil];
    
}
@end
