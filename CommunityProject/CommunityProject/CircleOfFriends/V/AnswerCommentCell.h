//
//  AnswerCommentCell.h
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleCommentModel.h"

@interface AnswerCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic,strong)CircleAnswerModel * answerModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conHeightCons;

@end
