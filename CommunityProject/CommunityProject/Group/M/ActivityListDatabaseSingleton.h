//
//  ActivityListDatabaseSingleton.h
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityListModel.h"

@interface ActivityListDatabaseSingleton : NSObject
@property (nonatomic,strong)FMDatabase * database;

+(instancetype)shareDatabase;

-(void)insertDatabase:(ActivityListModel*)model;

-(NSArray *)searchDatabase;

-(void)deleteDatabase:(ActivityListModel *)model;

@end
