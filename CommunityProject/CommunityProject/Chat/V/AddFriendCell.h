//
//  AddFriendCell.h
//  LoveChatProject
//
//  Created by bjike on 17/1/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchFriendModel.h"

@interface AddFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UITableView * myTableView;
@property (nonatomic,strong)SearchFriendModel * searchModel;
@end
