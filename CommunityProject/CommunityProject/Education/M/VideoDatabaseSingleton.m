
//
//  VideoDatabaseSingleton.m
//  CommunityProject
//
//  Created by bjike on 2017/6/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "VideoDatabaseSingleton.h"

@implementation VideoDatabaseSingleton
+(instancetype)shareDatabase{
    
    static VideoDatabaseSingleton * single = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        single = [VideoDatabaseSingleton new];
        
    });
    
    return single;
}
-(instancetype)init{
    
    
    if (self = [super init]) {
        
        NSString * dataPath = [NSHomeDirectory()stringByAppendingString:@"/Documents/videoDownloadlist.rdb"];
        
        _database = [[FMDatabase alloc]initWithPath:dataPath];
        
        //        NSSLog(@"%@",dataPath);
        
        if (![_database open]) {
            
            NSSLog(@"打开数据库失败");
            
        }
        if (![_database executeUpdate:@"create table if not exists VideoDownloadListModel (id integer primary key autoincrement, activesId text,nickname text,headImage blob,title text,firstImage blob,content text,likesStatus text,checkCollect text,time text,videoData blob,mbStr text,videoUrl text)"]) {
            
            NSSLog(@"创建表失败");
        }
        
    }
    return self;
}
-(void)insertDatabase:(VideoDownloadListModel *)model{
    
    
    if (![_database executeUpdate:@"insert into VideoDownloadListModel (activesId,nickname,headImage,title,firstImage,content,likesStatus,checkCollect,time,mbStr,videoUrl) values (?,?,?,?,?,?,?,?,?,?,?)",model.activesId,model.nickname,model.headImage,model.title,model.firstImage,model.content,model.likesStatus,model.checkCollect,model.time,model.mbStr,model.videoUrl]) {
        
        NSSLog(@"插入失败");
    }
    
    
}
-(NSArray *)searchDatabase{
    
    FMResultSet * set = [self.database executeQuery:@"select * from VideoDownloadListModel"];
    
    NSMutableArray * newArr = [NSMutableArray new];
    
    while ([set next]) {
        
        VideoDownloadListModel * model = [VideoDownloadListModel new];
        
        model.activesId = [set stringForColumn:@"activesId"];
        model.nickname = [set stringForColumn:@"nickname"];
        model.headImage = [set dataForColumn:@"headImage"];
        model.title = [set stringForColumn:@"title"];
        model.firstImage = [set dataForColumn:@"firstImage"];
        model.content = [set stringForColumn:@"content"];
        model.likesStatus = [set stringForColumn:@"likesStatus"];
        model.checkCollect = [set stringForColumn:@"checkCollect"];
        model.time = [set stringForColumn:@"time"];
//        model.videoData = [set dataForColumn:@"videoData"];
        model.mbStr = [set stringForColumn:@"mbStr"];
        model.videoUrl = [set stringForColumn:@"videoUrl"];
        [newArr addObject:model];
    }
    
    return newArr;
    
}
-(NSArray *)searchDatabaseModel:(NSString * )idStr{
    FMResultSet * set = [self.database executeQuery:[NSString stringWithFormat:@"select * from VideoDownloadListModel where activesId = %@",idStr]];
    NSMutableArray * newArr = [NSMutableArray new];
    while ([set next]) {
        
        VideoDownloadListModel * model = [VideoDownloadListModel new];
        
        model.activesId = [set stringForColumn:@"activesId"];
        model.nickname = [set stringForColumn:@"nickname"];
        model.headImage = [set dataForColumn:@"headImage"];
        model.title = [set stringForColumn:@"title"];
        model.firstImage = [set dataForColumn:@"firstImage"];
        model.content = [set stringForColumn:@"content"];
        model.likesStatus = [set stringForColumn:@"likesStatus"];
        model.checkCollect = [set stringForColumn:@"checkCollect"];
        model.time = [set stringForColumn:@"time"];
//        model.videoData = [set dataForColumn:@"videoData"];
        model.mbStr = [set stringForColumn:@"mbStr"];
        model.videoUrl = [set stringForColumn:@"videoUrl"];
        [newArr addObject:model];
    }
    return newArr;
}
//删除某一条视频
-(void)deleteDatabase:(NSString *)idStr{
    
    if (![self.database executeUpdate:@"delete from VideoDownloadListModel where activesId = ?",idStr]) {
        
        NSSLog(@"删除失败");
        
    }
    
}
-(void)deleteDatabaseFromUrl:(NSString *)url{
    if (![self.database executeUpdate:@"delete from VideoDownloadListModel where videoUrl = ?",url]) {
        
        NSSLog(@"删除失败");
        
    }
}

@end
