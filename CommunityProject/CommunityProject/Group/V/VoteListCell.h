//
//  VoteListCell.h
//  CommunityProject
//
//  Created by bjike on 17/4/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoteListModel.h"

typedef void(^PushBlock)(UIViewController * vc);
@interface VoteListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseThreeLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@property (nonatomic,strong)VoteListModel * voteModel;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,copy)PushBlock block;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthCons;
@end
