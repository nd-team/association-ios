//
//  CircleCommentCell.h
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleCommentModel.h"

@interface CircleCommentCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *judgeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbHeightCons;
@property (nonatomic,strong)CircleCommentModel * commentModel;

@end
