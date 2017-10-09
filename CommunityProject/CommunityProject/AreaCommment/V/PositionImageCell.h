//
//  PositionImageCell.h
//  CommunityProject
//
//  Created by bjike on 2017/7/21.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadImageModel.h"

typedef void(^Refresh)(void);
typedef void(^DeleteBlock)(NSIndexPath * selectPath);
typedef void(^ChangeBlock)(UploadImageModel * model,NSIndexPath *selectPath);
@interface PositionImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic,strong) UploadImageModel * uploadModel;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,copy)Refresh refresh;
@property (nonatomic,copy)DeleteBlock delete;
@property (nonatomic,assign)CGFloat isRaise;

@property (nonatomic,copy)ChangeBlock change;

@end
