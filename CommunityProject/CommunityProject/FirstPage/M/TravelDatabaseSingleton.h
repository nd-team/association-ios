//
//  TravelDatabaseSingleton.h
//  CommunityProject
//
//  Created by bjike on 17/5/4.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TravelModel.h"

@interface TravelDatabaseSingleton : NSObject
@property (nonatomic,strong)FMDatabase * database;

+(instancetype)shareDatabase;

-(void)insertDatabase:(TravelModel *)model;

-(NSArray *)searchDatabase;

-(void)deleteDatabase:(TravelModel *)model;

@end
