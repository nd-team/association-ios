//
//  HeadDetailCell.h
//  CommunityProject
//
//  Created by bjike on 17/4/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinUserModel.h"

@interface HeadDetailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (nonatomic,strong)JoinUserModel * userModel;

@end
