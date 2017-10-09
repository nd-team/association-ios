//
//  MyDownloadCell.h
//  CommunityProject
//
//  Created by bjike on 2017/6/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoDownloadListModel.h"

@interface MyDownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mbLabel;
@property (nonatomic,strong)VideoDownloadListModel * videoModel;

@end
