//
//  VoteViewController.h
//  LoveChatProject
//
//  Created by bjike on 17/3/6.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoteListController.h"
@interface VoteViewController : UIViewController
@property (nonatomic,copy)NSString * groupID;
@property (nonatomic,copy)NSString * groupName;
@property (nonatomic,copy)NSString * chooseType;
@property (nonatomic,assign)VoteListController * delegate;

@end
