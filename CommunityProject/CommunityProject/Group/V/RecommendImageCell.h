//
//  RecommendImageCell.h
//  CommunityProject
//
//  Created by bjike on 17/4/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadImageModel.h"

@interface RecommendImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (nonatomic,strong) UploadImageModel * uploadModel;

@property (weak, nonatomic) IBOutlet UIButton *delectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
