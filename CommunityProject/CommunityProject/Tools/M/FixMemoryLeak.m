//
//  FixMemoryLeak.m
//  ISSP
//
//  Created by bjike on 16/9/24.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "FixMemoryLeak.h"

@implementation FixMemoryLeak
//解决AFNetworking内存泄漏
+(AFHTTPSessionManager *)sharedHTTPSession{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(& onceToken, ^{
        
        
        manager = [AFHTTPSessionManager manager];
        
    });
    
    return manager;
}
@end
