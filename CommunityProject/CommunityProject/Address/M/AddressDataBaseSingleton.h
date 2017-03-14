//
//  AddressDataBaseSingleton.h
//  LoveChatProject
//
//  Created by bjike on 17/1/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendsListModel.h"

@interface AddressDataBaseSingleton : NSObject
@property (nonatomic,strong)FMDatabase * database;

+(instancetype)shareDatabase;

-(void)insertDatabase:(FriendsListModel*)model;

-(NSArray *)searchDatabase;

-(void)deleteDatabase:(FriendsListModel *)model;

@end
