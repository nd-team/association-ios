//
//  GoodsListDatabaseSingleton.h
//  CommunityProject
//
//  Created by bjike on 2017/7/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyGoodsDownloadModel.h"

@interface GoodsListDatabaseSingleton : NSObject
@property (nonatomic,strong)FMDatabase * database;

+(instancetype)shareDatabase;

-(void)insertDatabase:(MyGoodsDownloadModel*)model;

-(NSArray *)searchDatabase;
-(NSArray *)searchDatabaseModel:(NSString *)time;

-(void)deleteDatabase:(NSString *)time;


@end
