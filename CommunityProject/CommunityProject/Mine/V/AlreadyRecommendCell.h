//
//  AlreadyRecommendCell.h
//  CommunityProject
//
//  Created by bjike on 17/4/26.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlreadyRecommendModel.h"

@interface AlreadyRecommendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (nonatomic,strong)AlreadyRecommendModel * model;

@end
