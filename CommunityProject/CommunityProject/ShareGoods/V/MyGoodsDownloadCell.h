//
//  MyGoodsDownloadCell.h
//  CommunityProject
//
//  Created by bjike on 2017/7/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGoodsDownloadModel.h"

@interface MyGoodsDownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *KBLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong)MyGoodsDownloadModel * downloadModel;

@end
