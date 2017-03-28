//
//  GroupMessageCell.h
//  CommunityProject
//
//  Created by bjike on 17/3/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupApplicationModel.h"
#import "ApplicationTwoModel.h"

@interface GroupMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (nonatomic,strong)GroupApplicationModel * groupModel;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UITableView * myTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *unseeBtn;
@property (nonatomic,strong)ApplicationTwoModel * twoModel;
@property (nonatomic,strong)NSMutableArray * dataTwoArr;
//是否是第一组
//@property (nonatomic,assign)BOOL isFirst;
@property (nonatomic,copy)NSString * groupName;
//群ID
@property (nonatomic,copy)NSString * groupId;

@end
