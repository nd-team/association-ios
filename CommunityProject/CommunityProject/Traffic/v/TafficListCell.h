//
//  TafficListCell.h
//  CommunityProject
//
//  Created by bjike on 2017/7/6.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TafficeListModel.h"

typedef void(^PushBlock)(UIViewController * vc);
typedef void(^ShareBlock)(NSString *imageUrl, NSString * title, NSString *idStr);

@interface TafficListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;

@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (nonatomic,strong)TafficeListModel * listModel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (nonatomic,copy)PushBlock block;

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSString * likes;
@property (nonatomic,copy)ShareBlock  share;

@end
