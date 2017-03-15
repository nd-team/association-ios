//
//  AddressDataBaseSingleton.m
//  LoveChatProject
//
//  Created by bjike on 17/1/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AddressDataBaseSingleton.h"

@implementation AddressDataBaseSingleton
+(instancetype)shareDatabase{
    
    static AddressDataBaseSingleton * single = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        single = [AddressDataBaseSingleton new];
        
    });
    
    return single;
}
-(instancetype)init{
    
    
    if (self = [super init]) {
        
        NSString * dataPath = [NSHomeDirectory()stringByAppendingString:@"/Documents/friend.rdb"];
        
        _database = [[FMDatabase alloc]initWithPath:dataPath];
        
//        NSSLog(@"%@",dataPath);
        
        if (![_database open]) {
            
            NSSLog(@"打开数据库失败");
            
        }
        if (![_database executeUpdate:@"create table if not exists FriendsListModel (id integer primary key autoincrement, userId text,nickname text,userPortraitUrl text,displayName text,mobile text,email text)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(FriendsListModel *)model{
    
    
    if (![_database executeUpdate:@"insert into FriendsListModel (userId,nickname,userPortraitUrl,displayName,mobile,email) values (?,?,?,?,?,?)",model.userId,model.nickname,model.userPortraitUrl,model.displayName,model.mobile,model.email]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from FriendsListModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        FriendsListModel * model = [FriendsListModel new];
        
        model.userId = [set stringForColumn:@"userId"];
        model.nickname = [set stringForColumn:@"nickname"];
        model.userPortraitUrl = [set stringForColumn:@"userPortraitUrl"];
        model.displayName = [set stringForColumn:@"displayName"];
        model.mobile = [set stringForColumn:@"mobile"];
        model.email = [set stringForColumn:@"email"];
        [newArr addObject:model];
    }
    
    return newArr;
    
}

-(void)deleteDatabase:(FriendsListModel *)model{
    
    if (![self.database executeUpdate:@"delete from FriendsListModel where userId = ?",model.userId]) {
        
        NSSLog(@"删除失败");
        
    }
    
}

@end
