//
//  EducationListCell.h
//  CommunityProject
//
//  Created by bjike on 2017/6/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EducationListModel.h"

@interface EducationListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong)EducationListModel * listModel;

@end
