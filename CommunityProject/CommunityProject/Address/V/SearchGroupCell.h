//
//  SearchGroupCell.h
//  CommunityProject
//
//  Created by bjike on 17/3/27.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchGroupModel.h"

typedef void(^PresentView)(UIViewController * vc);
@interface SearchGroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *applicationBtn;

@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;

@property (nonatomic,strong)SearchGroupModel * groupModel;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)PresentView block;

@end
