//
//  SendRaiseCell.h
//  CommunityProject
//
//  Created by bjike on 2017/8/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TitleBlock)(NSString * titleStr);
@interface SendRaiseCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (nonatomic,copy)TitleBlock block;

@end
