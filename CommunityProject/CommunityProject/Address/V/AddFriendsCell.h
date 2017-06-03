//
//  AddFriendsCell.h
//  CommunityProject
//
//  Created by bjike on 2017/6/2.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchFriendModel.h"

typedef void(^PushBlock)(UIViewController * vc);

@interface AddFriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *commonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UIButton *relationshipBtn;

@property (nonatomic,strong)SearchFriendModel * friendModel;
@property (weak, nonatomic) IBOutlet UIButton *isFriendBtn;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,copy)PushBlock block;

@end
