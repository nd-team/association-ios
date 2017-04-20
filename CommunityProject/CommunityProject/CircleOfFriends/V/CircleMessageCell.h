//
//  CircleMessageCell.h
//  CommunityProject
//
//  Created by bjike on 17/4/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleUnreadMessageModel.h"

@interface CircleMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@property (nonatomic,strong)CircleUnreadMessageModel * messageModel;

@end
