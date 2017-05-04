//
//  TravelDatabaseSingleton.m
//  CommunityProject
//
//  Created by bjike on 17/5/4.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "TravelDatabaseSingleton.h"

@implementation TravelDatabaseSingleton
+(instancetype)shareDatabase{
    
    static TravelDatabaseSingleton * single = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        single = [TravelDatabaseSingleton new];
        
    });
    
    return single;
}
-(instancetype)init{
    
    
    if (self = [super init]) {
        
        NSString * dataPath = [NSHomeDirectory()stringByAppendingString:@"/Documents/travel.rdb"];
        
        _database = [[FMDatabase alloc]initWithPath:dataPath];
        
        //        NSSLog(@"%@",dataPath);
        
        if (![_database open]) {
            
            NSSLog(@"打开数据库失败");
            
        }
        if (![_database executeUpdate:@"create table if not exists TravelModel (id integer primary key autoincrement, activesImage text,title text,address text)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(TravelModel *)model{
    
    
    if (![_database executeUpdate:@"insert into TravelModel (activesImage,title,address) values (?,?,?)",model.activesImage,model.title,model.address]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from TravelModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        TravelModel * model = [TravelModel new];
        
        model.activesImage = [set stringForColumn:@"activesImage"];
        model.title = [set stringForColumn:@"title"];
        model.address = [set stringForColumn:@"address"];
        [newArr addObject:model];
    }
    
    return newArr;
    
}

-(void)deleteDatabase:(TravelModel *)model{
    
    if (![self.database executeUpdate:@"delete from TravelModel where activesImage = ?",model.activesImage]) {
        
        NSSLog(@"删除失败");
        
    }
    
}

@end
