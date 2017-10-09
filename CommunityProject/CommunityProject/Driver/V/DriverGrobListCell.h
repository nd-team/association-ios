//
//  DriverGrobListCell.h
//  CommunityProject
//
//  Created by bjike on 2017/8/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverGrobListModel.h"

typedef void(^PassagerOrderBlock)(NSString * startAddress,NSString * endAddress,NSString * phone,CLLocationCoordinate2D  startCoor,CLLocationCoordinate2D endCoor,NSString * headUrl,NSString * idStr,NSString * kilemile,NSString * money,NSString * time);
@interface DriverGrobListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (weak, nonatomic) IBOutlet UIButton *grobBtn;

@property (nonatomic,strong)DriverGrobListModel * listModel;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;

@property (nonatomic,copy)PassagerOrderBlock orderBlock;

@end
