
//
//  GoodsListDatabaseSingleton.m
//  CommunityProject
//
//  Created by bjike on 2017/7/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GoodsListDatabaseSingleton.h"

@implementation GoodsListDatabaseSingleton
+(instancetype)shareDatabase{
    
    static GoodsListDatabaseSingleton * single = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        single = [GoodsListDatabaseSingleton new];
        
    });
    
    return single;
}
-(instancetype)init{
    
    
    if (self = [super init]) {
        
        NSString * dataPath = [NSHomeDirectory()stringByAppendingString:@"/Documents/fileDownloadlist.rdb"];
        
        _database = [[FMDatabase alloc]initWithPath:dataPath];
        
        //        NSSLog(@"%@",dataPath);
        
        if (![_database open]) {
            
            NSSLog(@"打开数据库失败");
            
        }
        if (![_database executeUpdate:@"create table if not exists MyGoodsDownloadModel (id integer primary key autoincrement, data blob,title text,type text,time text,kbStr text)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(MyGoodsDownloadModel *)model{
    
    
    if (![_database executeUpdate:@"insert into MyGoodsDownloadModel (data,title,type,time,kbStr) values (?,?,?,?,?)",model.data,model.title,model.type,model.time,model.kbStr]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from MyGoodsDownloadModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        MyGoodsDownloadModel * model = [MyGoodsDownloadModel new];
        model.type = [set stringForColumn:@"type"];
        model.data = [set dataForColumn:@"data"];
        model.title = [set stringForColumn:@"title"];
        model.time = [set stringForColumn:@"time"];
        model.kbStr = [set stringForColumn:@"kbStr"];
        [newArr addObject:model];
    }
    
    return newArr;
    
}
-(NSArray *)searchDatabaseModel:(NSString * )time{
    FMResultSet * set = [self.database executeQuery:[NSString stringWithFormat:@"select * from MyGoodsDownloadModel where time = %@",time]];
    NSMutableArray * newArr = [NSMutableArray new];
    while ([set next]) {
        MyGoodsDownloadModel * model = [MyGoodsDownloadModel new];
        model.type = [set stringForColumn:@"type"];
        model.data = [set dataForColumn:@"data"];
        model.title = [set stringForColumn:@"title"];
        model.time = [set stringForColumn:@"time"];
        model.kbStr = [set stringForColumn:@"kbStr"];
        [newArr addObject:model];
    }
    return newArr;
}
//删除某一条视频
-(void)deleteDatabase:(NSString *)time{
    
    if (![self.database executeUpdate:@"delete from MyGoodsDownloadModel where time = ?",time]) {
        
        NSSLog(@"删除失败");
        
    }
    
}
@end
