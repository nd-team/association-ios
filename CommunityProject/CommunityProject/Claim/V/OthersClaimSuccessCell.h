//
//  OthersClaimSuccessCell.h
//  CommunityProject
//
//  Created by bjike on 17/5/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OthersClaimModel.h"
//别人认领当前用户成功
@interface OthersClaimSuccessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)OthersClaimModel * otherModel;

@end
