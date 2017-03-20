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
        if (![_database executeUpdate:@"create table if not exists ClaimModel (id integer primary key autoincrement, claimNumberId text,nickname text,userPortraitUrl text,fullName text,numberId text,recommendId text,claimNickName text,claimFullName text)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(ClaimModel *)model{
    
    
    if (![_database executeUpdate:@"insert into ClaimModel (recommendId,nickname,userPortraitUrl,fullName,numberId,claimNumberId,claimNickName,claimFullName) values (?,?,?,?,?,?,?,?)",model.recommendId,model.nickname,model.userPortraitUrl,model.fullName,model.numberId,model.claimNumberId,model.claimNickName,model.claimFullName]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from ClaimModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        ClaimModel * model = [ClaimModel new];
        
        model.claimNumberId = [set stringForColumn:@"claimNumberId"];
        model.nickname = [set stringForColumn:@"nickname"];
        model.userPortraitUrl = [set stringForColumn:@"userPortraitUrl"];
        model.fullName = [set stringForColumn:@"fullName"];
        model.numberId = [set stringForColumn:@"numberId"];
        model.recommendId = [set stringForColumn:@"recommendId"];
        model.claimNickName = [set stringForColumn:@"claimNickName"];
        model.claimFullName = [set stringForColumn:@"claimFullName"];
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
