//
//  FirstAppDataBaseSingleton.m
//  CommunityProject
//
//  Created by bjike on 17/3/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "FirstAppDataBaseSingleton.h"

@implementation FirstAppDataBaseSingleton
+(instancetype)shareDatabase{
    
    static FirstAppDataBaseSingleton * single = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        single = [FirstAppDataBaseSingleton new];
        
    });
    
    return single;
}
-(instancetype)init{
    
    
    if (self = [super init]) {
        
        NSString * dataPath = [NSHomeDirectory()stringByAppendingString:@"/Documents/application.rdb"];
        
        _database = [[FMDatabase alloc]initWithPath:dataPath];
        
        // NSSLog(@"%@",dataPath);
        
        if (![_database open]) {
            
            NSSLog(@"打开数据库失败");
            
        }
        if (![_database executeUpdate:@"create table if not exists AppModel (id integer primary key autoincrement, imageName text,name text,isHidden bool)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(AppModel *)model{
    
    
    if (![_database executeUpdate:@"insert into AppModel (imageName,name,isHidden) values (?,?,?)",model.imageName,model.name,model.isHidden]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from AppModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        AppModel * model = [AppModel new];
        
        model.name = [set stringForColumn:@"name"];
        model.imageName = [set stringForColumn:@"imageName"];
        model.isHidden = [set boolForColumn:@"isHidden"];
        [newArr addObject:model];
    }
    
    return newArr;
    
}

-(void)deleteDatabase:(AppModel *)model{
    
    if (![self.database executeUpdate:@"delete from AppModel where name = ?",model.name]) {
        
        NSSLog(@"删除失败");
        
    }
    
}

@end
