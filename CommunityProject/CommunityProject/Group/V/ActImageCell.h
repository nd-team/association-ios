//
//  ActImageCell.h
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadImageModel.h"

@interface ActImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (nonatomic,strong) UploadImageModel * uploadModel;

@end
