//
//  MyCarListCommentsModel.h
//  CommunityProject
//
//  Created by bjike on 2017/8/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MyCarListCommentsModel : JSONModel
@property (nonatomic,copy)NSString * userPortraitUrl;
@property (nonatomic,copy)NSString * userName;
@property (nonatomic,copy)NSString * starNumber;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,assign)CGFloat height;

@end
