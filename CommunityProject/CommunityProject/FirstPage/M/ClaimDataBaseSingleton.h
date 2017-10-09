//
//  ClaimDataBaseSingleton.h
//  CommunityProject
//
//  Created by bjike on 17/3/16.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClaimModel.h"

@interface ClaimDataBaseSingleton : NSObject
@property (nonatomic,strong)FMDatabase * database;

+(instancetype)shareDatabase;

-(void)insertDatabase:(ClaimModel*)model;

-(NSArray *)searchDatabase;

-(void)deleteDatabase:(ClaimModel *)model;

@end
