//
//  GroupListCell.h
//  LoveChatProject
//
//  Created by bjike on 17/2/9.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"

@interface GroupListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong)GroupModel * model;
@end
