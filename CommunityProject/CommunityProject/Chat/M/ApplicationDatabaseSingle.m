//
//  ApplicationDatabaseSingle.m
//  CommunityProject
//
//  Created by bjike on 17/3/28.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ApplicationDatabaseSingle.h"

@implementation ApplicationDatabaseSingle
+(instancetype)shareDatabase{
    
    static ApplicationDatabaseSingle * single = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        single = [ApplicationDatabaseSingle new];
        
    });
    
    return single;
}
-(instancetype)init{
    
    
    if (self = [super init]) {
        
        NSString * dataPath = [NSHomeDirectory()stringByAppendingString:@"/Documents/message.rdb"];
        
        _database = [[FMDatabase alloc]initWithPath:dataPath];
        
        //        NSSLog(@"%@",dataPath);
        
        if (![_database open]) {
            
            NSSLog(@"打开数据库失败");
            
        }
        if (![_database executeUpdate:@"create table if not exists ApplicationFriendsModel (id integer primary key autoincrement, userId text,nickname text,userPortraitUrl text,addFriendMessage text,addtime text,mobile text,email text,status text)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(ApplicationFriendsModel *)model{
    
    
    if (![_database executeUpdate:@"insert into ApplicationFriendsModel (userId,nickname,userPortraitUrl,addFriendMessage,addtime,mobile,email,status) values (?,?,?,?,?,?,?,?)",model.userId,model.nickname,model.userPortraitUrl,model.addFriendMessage,model.addtime,model.mobile,model.email,model.status]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from ApplicationFriendsModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        ApplicationFriendsModel * model = [ApplicationFriendsModel new];
        
        model.userId = [set stringForColumn:@"userId"];
        model.nickname = [set stringForColumn:@"nickname"];
        model.userPortraitUrl = [set stringForColumn:@"userPortraitUrl"];
        model.addFriendMessage = [set stringForColumn:@"addFriendMessage"];
        model.addtime = [set stringForColumn:@"addtime"];
        model.mobile = [set stringForColumn:@"mobile"];
        model.email = [set stringForColumn:@"email"];
        model.status = [set stringForColumn:@"status"];
        [newArr addObject:model];
    }
    
    return newArr;
    
}

-(void)deleteDatabase:(ApplicationFriendsModel *)model{
    
    if (![self.database executeUpdate:@"delete from ApplicationFriendsModel where userId = ?",model.userId]) {
        
        NSSLog(@"删除失败");
        
    }
    
}
@end
