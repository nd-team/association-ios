//
//  AreaHistrorySingleton.m
//  ISSP
//
//  Created by bjike on 17/2/11.
//  Copyright © 2017年 bjike. All rights reserved.
//

#import "AreaHistrorySingleton.h"

@implementation AreaHistrorySingleton
+(instancetype)shareDatabase{
    
    static AreaHistrorySingleton * single = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        single = [AreaHistrorySingleton new];
        
    });
    
    return single;
}
-(instancetype)init{
    
    
    if (self = [super init]) {
        
        NSString * dataPath = [NSHomeDirectory()stringByAppendingString:@"/Documents/history.rdb"];
        
        _database = [[FMDatabase alloc]initWithPath:dataPath];
        
        //        NSSLog(@"%@",dataPath);
        
        if (![_database open]) {
            
            NSSLog(@"打开数据库失败");
            
        }
        if (![_database executeUpdate:@"create table if not exists HistoryAreaModel (id integer primary key autoincrement, area text,longitude text,latitude text,time text)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(HistoryModel *)model{
    
    
    if (![_database executeUpdate:@"insert into HistoryAreaModel (area,longitude,latitude,time) values (?,?,?,?)",model.area,model.longitude,model.latitude,model.time]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from HistoryAreaModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        HistoryModel * model = [HistoryModel new];
        
        model.area = [set stringForColumn:@"area"];
        model.longitude = [set stringForColumn:@"longitude"];
        model.latitude = [set stringForColumn:@"latitude"];
        model.time = [set stringForColumn:@"time"];
        [newArr addObject:model];
    }
    
    return newArr;
    
}

-(void)deleteDatabase:(HistoryModel *)model{
    
    if (![self.database executeUpdate:@"delete from HistoryAreaModel where time = ?",model.time]) {
        
        NSSLog(@"删除失败");
        
    }
    
}

@end
