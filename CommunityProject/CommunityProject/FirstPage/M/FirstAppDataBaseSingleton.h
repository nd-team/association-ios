//
//  FirstAppDataBaseSingleton.h
//  CommunityProject
//
//  Created by bjike on 17/3/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModel.h"
@interface FirstAppDataBaseSingleton : NSObject
@property (nonatomic,strong)FMDatabase * database;

+(instancetype)shareDatabase;

-(void)insertDatabase:(AppModel*)model;

-(NSArray *)searchDatabase;

-(void)deleteDatabase:(AppModel *)model;

@end
