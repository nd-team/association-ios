//
//  ChooseCell.h
//  CommunityProject
//
//  Created by bjike on 17/3/31.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberListModel.h"

typedef void(^ChooseManagerBlock)(NSString * groupUserId,BOOL isSingle);
typedef void(^SelectRowBlock)(NSIndexPath * selectPath);

@interface ChooseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (nonatomic,strong)MemberListModel * memberModel;
@property (nonatomic,assign)int isSingle;
@property (nonatomic,copy)ChooseManagerBlock managerBlock;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)SelectRowBlock selectBlock;

@end
