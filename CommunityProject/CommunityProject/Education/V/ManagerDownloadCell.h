//
//  ManagerDownloadCell.h
//  CommunityProject
//
//  Created by bjike on 2017/6/26.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRDownloadModel.h"

typedef void(^RefreshDownloadBlock)(void);
@interface ManagerDownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *projessLabel;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic,strong)SRDownloadModel * videoModel;

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)RefreshDownloadBlock block;

@end
