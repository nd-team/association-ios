//
//  ClaimCenterCell.h
//  CommunityProject
//
//  Created by bjike on 17/5/11.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClaimCenterModel.h"

@interface ClaimCenterCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *darkView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong)ClaimCenterModel * centerModel;

@end
