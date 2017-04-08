//
//  VoteCell.h
//  CommunityProject
//
//  Created by bjike on 17/4/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TextFieldBlock)(NSString * text);

@interface VoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *chooseTF;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,strong)TextFieldBlock block;

@end
