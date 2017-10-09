//
//  VideoDatabaseSingleton.h
//  CommunityProject
//
//  Created by bjike on 2017/6/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoDownloadListModel.h"

@interface VideoDatabaseSingleton : NSObject
@property (nonatomic,strong)FMDatabase * database;

+(instancetype)shareDatabase;

-(void)insertDatabase:(VideoDownloadListModel*)model;

-(NSArray *)searchDatabase;
-(NSArray *)searchDatabaseModel:(NSString *)idStr;

-(void)deleteDatabase:(NSString *)idStr;
-(void)deleteDatabaseFromUrl:(NSString *)url;


@end
