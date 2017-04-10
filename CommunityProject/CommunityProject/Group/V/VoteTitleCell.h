//
//  VoteTitleCell.h
//  LoveChatProject
//
//  Created by bjike on 17/3/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoteListModel.h"

typedef void(^VoteIDBlock)(NSString * idStr,BOOL isSingle,BOOL isRemove);
typedef void(^SelectRowBlock)(NSIndexPath * selectPath);

@interface VoteTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic,strong)OptionModel * optionModel;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)VoteIDBlock block;
@property (nonatomic,assign)BOOL isSingle;
@property (nonatomic,copy)SelectRowBlock selectBlock;

@end
