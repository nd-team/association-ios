//
//  ApplicationCenterCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/16.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ApplicationCenterCell.h"

@implementation ApplicationCenterCell
-(void)setAppModel:(AppModel *)appModel{
    _appModel = appModel;
    self.headImageView.image = [UIImage imageNamed:_appModel.imageName];
    self.nameLabel.text = _appModel.name;
}
@end
