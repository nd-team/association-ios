//
//  HelpAnswerCell.h
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpAnswerListModel.h"

typedef void(^PushBlock)(UIViewController * vc);
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

@property (nonatomic,copy)PushBlock block;
@property (nonatomic,strong)NSString * iDStr;
@property (nonatomic,strong)NSString * titleStr;
@property (nonatomic,strong)NSString * hostId;

@end
