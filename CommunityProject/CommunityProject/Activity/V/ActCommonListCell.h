//
//  ActCommonListCell.h
//  CommunityProject
//
//  Created by bjike on 17/5/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlatformActListModel.h"

@interface ActCommonListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *travelImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (nonatomic,strong)PlatformActListModel * actModel;
@end
