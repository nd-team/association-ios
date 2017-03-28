//
//  ApplicationDatabaseSingle.h
//  CommunityProject
//
//  Created by bjike on 17/3/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationFriendsModel.h"

@interface ApplicationDatabaseSingle : NSObject
@property (nonatomic,strong)FMDatabase * database;

+(instancetype)shareDatabase;

-(void)insertDatabase:(ApplicationFriendsModel*)model;

-(NSArray *)searchDatabase;

-(void)deleteDatabase:(ApplicationFriendsModel *)model;
@end
