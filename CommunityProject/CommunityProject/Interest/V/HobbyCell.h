//
//  HobbyCell.h
//  CommunityProject
//
//  Created by bjike on 17/4/14.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SingleBlock)(NSIndexPath * selectPath);
@interface HobbyCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *hobbyBtn;
@property (nonatomic,strong)UICollectionView * collectionView;
//单选
@property (nonatomic,copy)SingleBlock block;

@end
