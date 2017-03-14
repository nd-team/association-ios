//
//  GroupDatabaseSingleton.m
//  LoveChatProject
//
//  Created by bjike on 17/2/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GroupDatabaseSingleton.h"

@implementation GroupDatabaseSingleton

+(instancetype)shareDatabase{
    
    static GroupDatabaseSingleton * single = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        single = [GroupDatabaseSingleton new];
        
    });
    
    return single;
}
-(instancetype)init{
    
    
    if (self = [super init]) {
        
        NSString * dataPath = [NSHomeDirectory()stringByAppendingString:@"/Documents/group.rdb"];
        
        _database = [[FMDatabase alloc]initWithPath:dataPath];
        
//        NSSLog(@"%@",dataPath);
        
        if (![_database open]) {
            
            NSSLog(@"打开数据库失败");
            
        }
        if (![_database executeUpdate:@"create table if not exists GroupModel (id integer primary key autoincrement, groupId text,groupName text,groupPortraitUrl text,role text)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(GroupModel *)model{
    
    
    if (![_database executeUpdate:@"insert into GroupModel (groupId,groupName,groupPortraitUrl,role) values (?,?,?,?)",model.groupId,model.groupName,model.groupPortraitUrl,model.role]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from GroupModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        GroupModel * model = [GroupModel new];
        
        model.groupId = [set stringForColumn:@"groupId"];
        model.groupName = [set stringForColumn:@"groupName"];
        model.groupPortraitUrl = [set stringForColumn:@"groupPortraitUrl"];
        model.role = [set stringForColumn:@"role"];
        [newArr addObject:model];
    }
    
    return newArr;
    
}

-(void)deleteDatabase:(GroupModel *)model{
    
    if (![self.database executeUpdate:@"delete from GroupModel where groupId = ?",model.groupId]) {
        
        NSSLog(@"删除失败");
        
    }
    
}

@end
