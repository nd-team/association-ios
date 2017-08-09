//
//  CarColorCell.h
//  CommunityProject
//
//  Created by bjike on 2017/8/7.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarColorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
-(void)showView:(NSString *)color;

@end
