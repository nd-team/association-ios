//
//  ClaimCell.h
//  CommunityProject
//
//  Created by bjike on 17/3/16.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClaimModel.h"

@interface ClaimCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *claimBtn;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *recomendPersonLabel;
@property (nonatomic,strong)ClaimModel *claimModel;

@end
