//
//  ClaimDataBaseSingleton.m
//  CommunityProject
//
//  Created by bjike on 17/3/16.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ClaimDataBaseSingleton.h"

@implementation ClaimDataBaseSingleton
+(instancetype)shareDatabase{
    
    static ClaimDataBaseSingleton * single = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        single = [ClaimDataBaseSingleton new];
        
    });
    
    return single;
}
-(instancetype)init{
    
    
    if (self = [super init]) {
        
        NSString * dataPath = [NSHomeDirectory()stringByAppendingString:@"/Documents/claim.rdb"];
        
        _database = [[FMDatabase alloc]initWithPath:dataPath];
        
        //        NSSLog(@"%@",dataPath);
        
        if (![_database open]) {
            
            NSSLog(@"打开数据库失败");
            
        }
        if (![_database executeUpdate:@"create table if not exists ClaimModel (id integer primary key autoincrement, userId text,nickname text,userPortraitUrl text,fullName text,numberId text,recommendId text)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(ClaimModel *)model{
    
    
    if (![_database executeUpdate:@"insert into ClaimModel (userId,nickname,userPortraitUrl,displayName,numberId,email) values (?,?,?,?,?,?)",model.userId,model.nickname,model.userPortraitUrl,model.fullName,model.numberId,model.recommendId]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from ClaimModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        ClaimModel * model = [ClaimModel new];
        
        model.userId = [set stringForColumn:@"userId"];
        model.nickname = [set stringForColumn:@"nickname"];
        model.userPortraitUrl = [set stringForColumn:@"userPortraitUrl"];
        model.fullName = [set stringForColumn:@"fullName"];
        model.numberId = [set stringForColumn:@"numberId"];
        model.recommendId = [set stringForColumn:@"recommendId"];
        [newArr addObject:model];
    }
    
    return newArr;
    
}

-(void)deleteDatabase:(ClaimModel *)model{
    
    if (![self.database executeUpdate:@"delete from ClaimModel where recommendId = ?",model.recommendId]) {
        
        NSSLog(@"删除失败");
        
    }
    
}
@end
