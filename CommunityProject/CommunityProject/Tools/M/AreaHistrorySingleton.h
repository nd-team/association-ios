//
//  AreaHistrorySingleton.h
//  ISSP
//
//  Created by bjike on 17/2/11.
//  Copyright © 2017年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryModel.h"

@interface AreaHistrorySingleton : NSObject
@property (nonatomic,strong)FMDatabase * database;

+(instancetype)shareDatabase;

-(void)insertDatabase:(HistoryModel*)model;

-(NSArray *)searchDatabase;

-(void)deleteDatabase:(HistoryModel *)model;

@end
