//
//  ActivityListDatabaseSingleton.m
//  CommunityProject
//
//  Created by bjike on 17/3/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ActivityListDatabaseSingleton.h"

@implementation ActivityListDatabaseSingleton
+(instancetype)shareDatabase{
    
    static ActivityListDatabaseSingleton * single = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        single = [ActivityListDatabaseSingleton new];
        
    });
    
    return single;
}
-(instancetype)init{
    
    
    if (self = [super init]) {
        
        NSString * dataPath = [NSHomeDirectory()stringByAppendingString:@"/Documents/actList.rdb"];
        
        _database = [[FMDatabase alloc]initWithPath:dataPath];
        
        //        NSSLog(@"%@",dataPath);
        
        if (![_database open]) {
            
            NSSLog(@"打开数据库失败");
            
        }
        if (![_database executeUpdate:@"create table if not exists ActivityListModel (id integer primary key autoincrement, activesId integer,activesTitle text,activesImage text,activesStart text,activesEnd text,activesAddress text,activesContent text,activesLimit integer)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(ActivityListModel *)model{
    
    
    if (![_database executeUpdate:@"insert into ActivityListModel (activesId,activesTitle,activesImage,activesStart,activesEnd,activesAddress,activesContent,activesLimit) values (?,?,?,?,?,?,?,?)",model.activesId,model.activesTitle,model.activesImage,model.activesStart,model.activesEnd,model.activesAddress,model.activesContent,model.activesLimit]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from ActivityListModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        ActivityListModel * model = [ActivityListModel new];
        
        model.activesId = [set intForColumn:@"activesId"];
        model.activesTitle = [set stringForColumn:@"activesTitle"];
        model.activesImage = [set stringForColumn:@"activesImage"];
        model.activesStart = [set stringForColumn:@"activesStart"];
        model.activesEnd = [set stringForColumn:@"activesEnd"];
        model.activesAddress = [set stringForColumn:@"activesAddress"];
        model.activesContent = [set stringForColumn:@"activesContent"];
        model.activesLimit = [set intForColumn:@"activesLimit"];

        [newArr addObject:model];
    }
    
    return newArr;
    
}

-(void)deleteDatabase:(ActivityListModel *)model{
    
    if (![self.database executeUpdate:@"delete from ActivityListModel where activesId = ?",model.activesId]) {
        
        NSSLog(@"删除失败");
        
    }
    
}

@end
