//
//  AppTwoCell.m
//  CommunityProject
//
//  Created by bjike on 17/3/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AppTwoCell.h"

@implementation AppTwoCell
-(void)setAppModel:(AppModel *)appModel{
    _appModel = appModel;
    self.headImageView.image = [UIImage imageNamed:_appModel.imageName];
    self.nameLabel.text = _appModel.name;
}
@end
