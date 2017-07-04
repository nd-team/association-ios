//
//  HelpAnswerCell.h
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpAnswerListModel.h"

@interface HelpAnswerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (nonatomic,strong)HelpAnswerListModel * helpModel;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSString * likes;

@end
