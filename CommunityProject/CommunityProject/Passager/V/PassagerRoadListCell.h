//
//  PassagerRoadListCell.h
//  CommunityProject
//
//  Created by bjike on 2017/8/16.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverRecordModel.h"

@interface PassagerRoadListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *startAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAreaLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic,strong)DriverRecordModel * roadModel;

@end
