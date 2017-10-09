//
//  TypeAddFriendCell.h
//  CommunityProject
//
//  Created by bjike on 17/4/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPeopleListModel.h"

@interface TypeAddFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;


@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *recomendLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (nonatomic,strong)MyPeopleListModel * listModel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UITableView * tableView;

@end
