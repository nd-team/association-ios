//
//  AllCommentsCell.h
//  CommunityProject
//
//  Created by bjike on 17/5/22.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsListModel.h"

typedef void(^ZanBlock)(NSDictionary * params,NSIndexPath * index,BOOL isSel);
@interface AllCommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;

@property (nonatomic,strong)CommentsListModel * commentModel;

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@property (nonatomic,copy)ZanBlock block;

@end
