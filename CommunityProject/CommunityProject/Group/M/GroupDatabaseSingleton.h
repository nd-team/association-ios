//
//  GroupDatabaseSingleton.h
//  LoveChatProject
//
//  Created by bjike on 17/2/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupModel.h"

@interface GroupDatabaseSingleton : NSObject
@property (nonatomic,strong)FMDatabase * database;

+(instancetype)shareDatabase;

-(void)insertDatabase:(GroupModel*)model;

-(NSArray *)searchDatabase;

-(void)deleteDatabase:(GroupModel *)model;

@end
